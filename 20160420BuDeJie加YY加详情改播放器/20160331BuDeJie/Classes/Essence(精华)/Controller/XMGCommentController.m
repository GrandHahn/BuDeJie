//
//  XMGCommentController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/8/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//
/**
 处理cell的思路
 1.定义属性，让XMGTopicViewController传递cell给XMGCommentController
 2.修改cell的frame，添加cell到自己view上
 3.点击返回，让XMGTopicViewController自己重新添加cell到tableview上
 以上方案已被否决 X
 原因：
 1.把cell添加到tableview额外的内边距里，同时希望section的header有吸顶并且位置随滚动变化，需要在scrollViewDidScroll中监听滚动同时修改contentInset的y值，会导致tableview的向上滚动效果差，无加速度效果
 2.把传入的topiccell通过cellForRowAtIndexPath加载，当向下滚动到无法看见topiccell的时候，再点击返回上一个界面，想把topiccell重新添加到tableview上时，会导致topiccell无法在XMGTopicViewController中显示，原因未知（估计跟cell的循环机制有关）
 3.最后采用直接再用XMGTopicCell创建一个topiccell，可以避免以上问题
 */

/**
 释放视频资源的地方：
 1.viewDidDisappear，
 2.dealloc,
 4.点击了另一视频topicVideoViewDidClickVideo,
 5.视频离开了屏幕scrollViewDidScroll，
 */

#import "XMGCommentController.h"
#import <AFNetworking.h>
#import "XMGCommentItem.h"
#import "XMGCommentCell.h"
#import "XMGTopicVideoView.h"
#import "AVPlayerView.h"
#import "UMSocial.h"
#import "XMGTopicVoiceView.h"
static NSString * const ID = @"commentcell";
static NSString * const topicID = @"topiccell";
@interface XMGCommentController () <XMGTopicVideoViewDelegate, XMGTopicCellDelegate, UMSocialUIDelegate, XMGTopicVoiceViewDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray<XMGCommentItem *> *commentItemArray;
@property (nonatomic, strong) NSMutableArray<XMGCommentItem *> *hotCommentItemArray;
@property (nonatomic, assign) CGRect oriFrame;


@property (nonatomic, assign) BOOL isFooterRefreshing;


@property (nonatomic, weak) AVPlayerView *playV;
@end

@implementation XMGCommentController

- (NSMutableArray<XMGCommentItem *> *)commentItemArray {
    if (!_commentItemArray) {
        _commentItemArray = [NSMutableArray array];
    }
    return _commentItemArray;
}

- (NSMutableArray<XMGCommentItem *> *)hotCommentItemArray {
    if (!_hotCommentItemArray) {
        _hotCommentItemArray = [NSMutableArray array];
    }
    return _hotCommentItemArray;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(self.topicItem.cellHeight, 0, 0, 0);
//#warning - 处理cell的思路，步骤2
//    self.oriFrame = self.topicCell.frame;
//    CGRect tempF = self.topicCell.frame;
//    tempF.origin.y = -tempF.size.height;
//#warning - 由于重写了topicCell的setFrame,所以要加10
//    tempF.size.height += 10;
//    self.topicCell.frame = tempF;
//    [self.tableView addSubview:self.topicCell];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XMGCommentCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XMGTopicCell" bundle:nil] forCellReuseIdentifier:topicID];

    [self loadNewTopic];
    
    [self setupRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#warning - 由于弹出播放器此方法会被调用，不在此处传递topicCell
//    _oriFrame.size.height += 10;
//    self.topicCell.frame = _oriFrame;
//    [self.pushVC.view addSubview:self.topicCell];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 释放视频
    if (self.playV == nil) return;
    [self.playV stopAndReleaseAll];
    [self.playV removeFromSuperview];
    self.playV = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 释放视频
    if (self.playV == nil) return;
    [self.playV stopAndReleaseAll];
    [self.playV removeFromSuperview];
    self.playV = nil;
}





// 加载新帖子
- (void)loadNewTopic {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.topicItem.ID;
    parameters[@"hot"] = @1;
//    parameters[@"lastcid"] = @0;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [responseObject writeToFile:@"/Users/hahn/Desktop/课后练习/20160412BuDeJie/topic2.plist" atomically:YES];
        
        // 当没评论时，返回的是NSArray，判断为非NSDictionary就返回
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            return;
        }
        
        NSArray *comments = responseObject[@"data"];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in comments) {
            XMGCommentItem *item = [XMGCommentItem commentItemWithDict:dict];
            [tempArr addObject:item];
        }
        self.commentItemArray = tempArr;
        
        
        // 热评
        NSArray *hotComments = responseObject[@"hot"];
        NSMutableArray *tempArrHot = [NSMutableArray array];
        for (NSDictionary *dict in hotComments) {
            XMGCommentItem *item = [XMGCommentItem commentItemWithDict:dict];
            [tempArrHot addObject:item];
        }
        self.hotCommentItemArray = tempArrHot;
        
        
        
        [self.tableView reloadData];
//        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //        self.header.text = @"下拉加载更多";
        //        if (self.isHeaderRefreshing == NO) {
        //            return;
        //        }
        
//        [self headeEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
//        [self headeEndRefreshing];
    }];
}


// 加载更多帖子
- (void)loadMoreTopic {
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.topicItem.ID;
    parameters[@"hot"] = @1;
    
    XMGCommentItem *item = self.commentItemArray.lastObject;
    parameters[@"lastcid"] = item.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *comments = responseObject[@"data"];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in comments) {
            XMGCommentItem *item = [XMGCommentItem commentItemWithDict:dict];
            [tempArr addObject:item];
        }
        [self.commentItemArray addObjectsFromArray:tempArr];
        
        [self.tableView reloadData];
        
        [self footerEndRefreshing];
        
        // 没有更多了
        if (tempArr.count == 0) {
            UILabel *footer = (UILabel *)self.tableView.tableFooterView;
            footer.text = @"";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [self footerEndRefreshing];
    }];
}

#pragma mark - footer

// 添加刷新控件
- (void)setupRefresh {
    // 尾部
    UILabel *footer = [[UILabel alloc] init];
    footer.xmg_height = 35;
    footer.text = @"上拉加载更多";
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor lightGrayColor];
//    footer.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = footer;
}

// 根据位置处理尾部显示内容
- (void)dealFooter {
    // 防止程序启动就调用
    if (self.commentItemArray.count == 0) return;
    // 正在上拉刷新就返回
    if (self.isFooterRefreshing) return;
    
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.xmg_height;
    if (self.tableView.contentOffset.y > offsetY) {
        [self footerBeginRefreshing];
    }
}
// 头部开始刷新
- (void)footerBeginRefreshing {
    self.isFooterRefreshing = YES;
    // 加载更多数据
    [self loadMoreTopic];
}
// 头部结束刷新
- (void)footerEndRefreshing {
    self.isFooterRefreshing = NO;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat cellHeight = self.commentItemArray[indexPath.row].cellHeight;
    //    NSLog(@"%zd-----%f", indexPath.row, cellHeight);
    
    CGFloat cellHeight = 0;
    if ([self numberOfSectionsInTableView:tableView] == 3) {
        if (indexPath.section == 0) {
            cellHeight = self.topicItem.cellHeight;
        } else if (indexPath.section == 1) {
            cellHeight = self.hotCommentItemArray[indexPath.row].cellHeight;
        } else {
            cellHeight = self.commentItemArray[indexPath.row].cellHeight;
        }
    } else {
        if (indexPath.section == 0) {
            cellHeight = self.topicItem.cellHeight;
        } else {
            cellHeight = self.commentItemArray[indexPath.row].cellHeight;
        }
    }
    return cellHeight;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 44;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self numberOfSectionsInTableView:tableView] == 3) {
        if (section == 0) {
            return @"";
        } else if (section == 1) {
            return @"最热评论";
        } else {
            return @"最新评论";
        }
    } else {
        if (section == 0) {
            return @"";
        } else {
            return @"最新评论";
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hotCommentItemArray.count) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self numberOfSectionsInTableView:tableView] == 3) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return self.hotCommentItemArray.count;
        } else {
            return self.commentItemArray.count;
        }
    } else {
        if (section == 0) {
            return 1;
        } else {
            return self.commentItemArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    XMGCommentItem *item = self.commentItemArray[indexPath.row];
//    cell.item = item;
//    cell.delegate = self;
    if ([self numberOfSectionsInTableView:tableView] == 3) { // 有热评
        if (indexPath.section == 0) { // cell
//            XMGTopicCell *cell = nil;
//            cell = self.topicCell;
//            return cell;
            XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicID];
//            if (cell == nil) {
//                cell = [[XMGTopicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//            }
            XMGTopicItem *item = self.topicItem;
            cell.item = item;
            cell.delegate = self;
            
            // 注意：要在两处写，有热评和无热评
            cell.topicVideoView.delegate = self;
            
            cell.topicVoiceView.delegate = self;
            return cell;
        } else if (indexPath.section == 1) { // 热评
            XMGCommentItem *item = self.hotCommentItemArray[indexPath.row];
            XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.item = item;
            return cell;
        } else { // 普通评论
            XMGCommentItem *item = self.commentItemArray[indexPath.row];
            XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.item = item;
            return cell;
        }
    } else { // 无热评
        if (indexPath.section == 0) { // cell
            XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicID];
            //            if (cell == nil) {
            //                cell = [[XMGTopicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            //            }
            XMGTopicItem *item = self.topicItem;
            cell.item = item;
            cell.delegate = self;
            
            // 注意：要在两处写，有热评和无热评
            cell.topicVideoView.delegate = self;
            
            cell.topicVoiceView.delegate = self;
            return cell;
        } else { // 普通评论
            XMGCommentItem *item = self.commentItemArray[indexPath.row];
            XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.item = item;
            return cell;
        }
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    
//    if (offsetY > -64) {
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    }
//    if (offsetY < -self.topicItem.cellHeight-64) {
//        self.tableView.contentInset = UIEdgeInsetsMake(64 + self.topicItem.cellHeight, 0, 0, 0);
//    }
    
    
    [self dealFooter];
    
    
    
    
    // 如果离开屏幕，就暂停视频，但不释放
    if (self.playV == nil) return;
    
    XMGTopicCell *topicCell = (XMGTopicCell *)self.playV.superview.superview;
    
    CGFloat minY = topicCell.frame.origin.y;
    CGFloat maxY = topicCell.frame.origin.y + topicCell.frame.size.height;
    CGFloat contentMinY = scrollView.contentOffset.y;
    CGFloat contentMaxY = scrollView.contentOffset.y + scrollView.bounds.size.height;
    
    NSLog(@"%f,%f,%f,%f", minY, maxY, contentMinY, contentMaxY);
    if ((minY > contentMaxY)||(maxY < contentMinY)) {
        NSLog(@"minY > contentMaxY");
//        [self.playV stopAndReleaseAll];
//        [self.playV removeFromSuperview];
//        self.playV = nil;
        
        [self.playV pause];
    }
}

#pragma mark - XMGTopicVideoViewDelegate
- (void)topicVideoViewDidClickVideo:(XMGTopicVideoView *)topicVideoView {
    if (self.playV != nil) { // 已经创建了就直接添加上去，注：如果执行正确，此部分一般不会被执行，用来防止未被添加上去的情况
        self.playV.frame = topicVideoView.videoImageViewFrame;
        [topicVideoView addSubview:self.playV];
    } else { // 还没创建过
        AVPlayerView *playV = [AVPlayerView playerView];
        playV.urlStr = topicVideoView.item.videouri;
        playV.frame = topicVideoView.videoImageViewFrame;
        self.playV = playV;
        [topicVideoView addSubview:playV];
        [playV play];
    }
}

#pragma mark - XMGTopicVoiceViewDelegate
- (void)topicVoiceViewDidClickVoice:(XMGTopicVoiceView *)topicVoiceView {
    if (self.playV != nil) { // 已经创建了就直接添加上去，注：如果执行正确，此部分一般不会被执行，用来防止未被添加上去的情况
        self.playV.frame = topicVoiceView.bounds;
        [topicVoiceView addSubview:self.playV];
    } else { // 还没创建过
        AVPlayerView *playV = [AVPlayerView playerView];
        playV.urlStr = topicVoiceView.item.voiceuri;
        playV.frame = topicVoiceView.bounds;
        self.playV = playV;
        [topicVoiceView addSubview:playV];
        [playV play];
        [self.playV setPlayerViewAndVideoViewClearColor];
    }
}

#pragma mark - XMGTopicCellDelegate
- (void)topicCellDidClickRepost:(XMGTopicCell *)topicCell {
    XMGTopicItem *item = topicCell.item;
    NSString *shareUrl = item.weixin_url;
    [UMSocialData defaultData].extConfig.title = @"分享的title";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:shareUrl
                                     shareImage:[UIImage imageNamed:@"20160602facebook的reactnative"]
                                shareToSnsNames:nil
                                       delegate:self];
}

#pragma mark - 回调  默认UI分享完后
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
@end
