//
//  XMGTopicViewController
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/9.
//  Copyright © 2016年 Hahn. All rights reserved.
//
/**
 释放视频资源的地方：
 1.viewDidDisappear，
 2.dealloc,
 3.scrollview滚动到另一页（或点击了按钮）XMGEssenceViewScrollViewDidEndDecelerating,
 4.点击了另一视频topicVideoViewDidClickVideo,
 5.视频离开了屏幕scrollViewDidScroll，
 6.loadNewTopic
 */
#import "XMGTopicViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGTopicItem.h"
#import "XMGTopicCell.h"
#import "UMSocial.h"
#import "XMGCommentController.h"
#import "XMGTopicVideoView.h"
#import "AVPlayerView.h"
#import "XMGTopicVoiceView.h"
static NSString * const ID = @"cell";
@interface XMGTopicViewController () <XMGTopicCellDelegate, UMSocialUIDelegate, XMGTopicVideoViewDelegate, XMGTopicVoiceViewDelegate>
@property (nonatomic, strong) NSMutableArray<XMGTopicItem *> *topicItemArray;
@property (nonatomic, assign) BOOL isFooterRefreshing;
@property (nonatomic, assign) BOOL isHeaderRefreshing;
@property (nonatomic, strong) UILabel *header;
@property (nonatomic, strong) NSString *maxtime;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
// 记录被传递到详情页的cell
@property (nonatomic, strong) XMGTopicCell *pushedTopicCell;
@property (nonatomic, assign) CGRect pushedTopicCellFrame;

@property (nonatomic, weak) AVPlayerView *playV;


@end

@implementation XMGTopicViewController

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(99, 0, 44, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 添加刷新控件
    [self setupRefresh];
    
    // 加载新帖子
    //    [self loadNewTopic];
    
    
    //    UIEdgeInsets inset = self.tableView.contentInset;
    //    inset.top += self.header.xmg_height;
    //    self.tableView.contentInset = inset;
    //    // 加载新帖子
    //    [self loadNewTopic];
    
    
    [self headerBeginRefreshing];
    
    [self setupNote];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XMGTopicCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    [XMGTopicItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    
    // 加载广告要在loadNewTopic之后执行，否则会被loadMoreTopic里的cancel取消掉，注：可以放在loadMoreTopic里，此处则暂时这样加载
    [self loadTopicAd];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#warning - 此处处理cell不要写在viewWillAppear中，否则滑动返回时突然取消会导致详情页无cell
#warning - 处理cell的思路，步骤3
    // 从详情页返回时，把cell重新添加到tableview
    if (self.pushedTopicCell != nil) {
#warning - 由于重写了topicCell的setFrame,所以要加10
        _pushedTopicCellFrame.size.height += 10;
        self.pushedTopicCell.frame = _pushedTopicCellFrame;
        
        [self.tableView addSubview:self.pushedTopicCell];
        
        self.pushedTopicCell = nil;
        self.pushedTopicCellFrame = CGRectZero;
    }
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

- (void)setupNote {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:XMGTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:XMGTitleButtonDidRepeatClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XMGEssenceViewScrollViewDidEndDecelerating) name:XMGEssenceViewScrollViewDidEndDeceleratingNotification object:nil];
}

- (void)tabBarButtonDidRepeatClick {
    // 当前控制器界面在不在正中
    if (self.tableView.scrollsToTop == NO) return;
    // 当前控制器界面在不在窗口
    if (self.tableView.window == nil) return;
    //    XMGFunc
    [self headerBeginRefreshing];
}

- (void)titleButtonDidRepeatClick {
    // 当前控制器界面在不在正中
    if (self.tableView.scrollsToTop == NO) return;
    // 当前控制器界面在不在窗口
    if (self.tableView.window == nil) return;
    //    XMGFunc
    [self headerBeginRefreshing];
}
// scrollview拖动后应该释放视频
- (void)XMGEssenceViewScrollViewDidEndDecelerating {
    if (self.playV == nil) return;
    [self.playV stopAndReleaseAll];
    [self.playV removeFromSuperview];
    self.playV = nil;
}


// 添加刷新控件
- (void)setupRefresh {
    // 广告
//    UILabel *ad = [[UILabel alloc] init];
//    ad.xmg_height = 35;
//    ad.text = @"广告";
//    ad.textAlignment = NSTextAlignmentCenter;
//    ad.textColor = [UIColor whiteColor];
//    ad.backgroundColor = [UIColor grayColor];
//    self.tableView.tableHeaderView = ad;
    
    /**
     广告处理方案：
     获得数据再创建控件，否则如果先创建控件设为header，会导致得到数据后修改header宽高有问题
     */
    
    // 头部
    UILabel *header = [[UILabel alloc] init];
    header.xmg_height = 50;
    header.xmg_y = - header.xmg_height;
    header.xmg_width = self.tableView.xmg_width;
    header.text = @"下拉加载更多";
    header.textAlignment = NSTextAlignmentCenter;
//    header.textColor = [UIColor whiteColor];
//    header.backgroundColor = [UIColor redColor];
    header.textColor = [UIColor grayColor];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView addSubview:header];
    self.header = header;
    // 尾部
    UILabel *footer = [[UILabel alloc] init];
    footer.xmg_height = 35;
    footer.text = @"上拉加载更多";
    footer.textAlignment = NSTextAlignmentCenter;
//    footer.textColor = [UIColor whiteColor];
//    footer.backgroundColor = [UIColor redColor];
    footer.textColor = [UIColor grayColor];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = footer;
}

#pragma mark - 加载数据
// 统一修改类型
- (NSUInteger)type {
    return XMGTopicTypePicture;
}

// 加载新帖子
- (void)loadNewTopic {
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    if ([self.requestParaA isEqualToString:@"newlist"]) {
        parameters[@"a"] = self.requestParaA;
    }
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [responseObject writeToFile:@"/Users/hahn/Desktop/课后练习/20160412BuDeJie/topic2.plist" atomically:YES];
        NSArray *topics = responseObject[@"list"];
        self.topicItemArray = [XMGTopicItem mj_objectArrayWithKeyValuesArray:topics];
        [self.tableView reloadData];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //        self.header.text = @"下拉加载更多";
        //        if (self.isHeaderRefreshing == NO) {
        //            return;
        //        }
        
        [self headeEndRefreshing];
        
        
        // 释放视频
        if (self.playV == nil) return;
        [self.playV stopAndReleaseAll];
        [self.playV removeFromSuperview];
        self.playV = nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [self headeEndRefreshing];
    }];
}

// 加载更多帖子
- (void)loadMoreTopic {
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    if ([self.requestParaA isEqualToString:@"newlist"]) {
        parameters[@"a"] = self.requestParaA;
    }
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [responseObject writeToFile:@"/Users/hahn/Desktop/课后练习/20160412BuDeJie/topic.plist" atomically:YES];
        NSArray *topics = responseObject[@"list"];
        NSArray *appendArray = [XMGTopicItem mj_objectArrayWithKeyValuesArray:topics];
        [self.topicItemArray addObjectsFromArray:appendArray];
        [self.tableView reloadData];
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self footerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [self footerEndRefreshing];
    }];
}
// 加载广告
- (void)loadTopicAd {
    //    http://api.budejie.com/api/api_open.php?a=get_top_promotion&c=topic&openudid=19deb9dde5ccf65fe1623b59a5ebeff55bcbc319&asid=AC824640-5493-4DAD-B356-F84136BE8A55&ver=4.3&jbk=0&device=ios&client=iphone
    
    // 不要执行取消，但要在loadMoreTopic方法之后再调用，否则会被loadMoreTopic里的cancel取消掉
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php?a=get_top_promotion&c=topic&openudid=19deb9dde5ccf65fe1623b59a5ebeff55bcbc319&asid=AC824640-5493-4DAD-B356-F84136BE8A55&ver=4.3&jbk=0&device=ios&client=iphone" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *adDict = responseObject[@"result"][@"list"][0];
        
        YYAnimatedImageView *adImageV = [[YYAnimatedImageView alloc] init];
        [adImageV downloadImageWithOriginalImageName:adDict[@"image"] thumbnailImageName:nil placeholderImage:nil completed:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            CGFloat imgW = image.size.width;
            CGFloat imgH = image.size.height;
            CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//            CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
            CGFloat w = screenW;
            CGFloat h = w * imgH / imgW;
            // 公式： w/h = imgW/imgH
            adImageV.bounds = CGRectMake(0, 0, w, h);
            self.tableView.tableHeaderView = adImageV;
//            [self.tableView reloadData];
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = self.topicItemArray[indexPath.row].cellHeight;
    //    NSLog(@"%zd-----%f", indexPath.row, cellHeight);
    return cellHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    //    }
    XMGTopicItem *item = self.topicItemArray[indexPath.row];
    cell.item = item;
    cell.delegate = self;
    cell.topicVideoView.delegate = self;
    cell.topicVoiceView.delegate = self;
    return cell;
}

#pragma mark - XMGTopicVideoViewDelegate
- (void)topicVideoViewDidClickVideo:(XMGTopicVideoView *)topicVideoView {
    // 释放上一个视频
    if (self.playV != nil) {
        [self.playV stopAndReleaseAll];
        [self.playV removeFromSuperview];
        self.playV = nil;
    }
    
    AVPlayerView *playV = [AVPlayerView playerView];
//    XMGTopicCell *topicCell = (XMGTopicCell *)topicVideoView.superview;
    playV.urlStr = topicVideoView.item.videouri;
//    playV.urlStr = @"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4";
    playV.frame = topicVideoView.videoImageViewFrame;
    self.playV = playV;
    [topicVideoView addSubview:playV];
    
    [self.playV play];
}


#pragma mark - XMGTopicVoiceViewDelegate
- (void)topicVoiceViewDidClickVoice:(XMGTopicVoiceView *)topicVoiceView {
    // 释放上一个视频
    if (self.playV != nil) {
        [self.playV stopAndReleaseAll];
        [self.playV removeFromSuperview];
        self.playV = nil;
    }
    
    AVPlayerView *playV = [AVPlayerView playerView];
    //    XMGTopicCell *topicCell = (XMGTopicCell *)topicVideoView.superview;
    playV.urlStr = topicVoiceView.item.voiceuri;
    //    playV.urlStr = @"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4";
    playV.frame = topicVoiceView.bounds;
    self.playV = playV;
    [topicVoiceView addSubview:playV];
    
    [self.playV play];
    [self.playV setPlayerViewAndVideoViewClearColor];
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

- (void)topicCellDidClickComment:(XMGTopicCell *)topicCell {
    XMGCommentController *commentVC = [[XMGCommentController alloc] init];
    commentVC.topicItem = topicCell.item;
//    XMGTopicCell *cellcopy = [self duplicate:topicCell];
    commentVC.topicCell = topicCell;
    // 记录传递出去的cell
    self.pushedTopicCell = topicCell;
    self.pushedTopicCellFrame = topicCell.frame;
//    commentVC.pushVC = self;
//    NSLog(@"%f,%f,%f,%f", topicCell.frame.origin.x, topicCell.frame.origin.y, topicCell.frame.size.width, topicCell.frame.size.height);
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
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

#pragma mark - UIScrollViewDelegate
// 松开拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isHeaderRefreshing) {
        return;
    }
    CGFloat offsetY = - (self.header.xmg_height + self.tableView.contentInset.top);
    
    if (self.tableView.contentOffset.y < offsetY) {
        [self headerBeginRefreshing];
    }
    
}

// 滚动时就调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dealHeader];
    
    [self dealFooter];
    
    // 清缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    
    
    // 如果离开屏幕，就释放视频
    if (self.playV == nil) return;
    
    XMGTopicCell *topicCell = (XMGTopicCell *)self.playV.superview.superview;
    
    CGFloat minY = topicCell.frame.origin.y;
    CGFloat maxY = topicCell.frame.origin.y + topicCell.frame.size.height;
    CGFloat contentMinY = scrollView.contentOffset.y;
    CGFloat contentMaxY = scrollView.contentOffset.y + scrollView.bounds.size.height;
    
        NSLog(@"%f,%f,%f,%f", minY, maxY, contentMinY, contentMaxY);
    if ((minY > contentMaxY)||(maxY < contentMinY)) {
        NSLog(@"minY > contentMaxY");
        [self.playV stopAndReleaseAll];
        [self.playV removeFromSuperview];
        self.playV = nil;
    }
}

#pragma mark - header

// 根据位置处理头部显示内容
- (void)dealHeader {
    // 防止程序启动就调用
    if (self.header == nil) return;
    
    // 正在下拉刷新就返回
    if (self.isHeaderRefreshing) return;
    
    CGFloat offsetY = - (self.header.xmg_height + self.tableView.contentInset.top);
    if (self.tableView.contentOffset.y < offsetY) {
        self.header.text = @"松开刷新";
    } else {
        self.header.text = @"下拉加载更多";
    }
}

// 头部进入刷新
- (void)headerBeginRefreshing {
    self.isHeaderRefreshing = YES;
    self.header.text = @"正在刷新。。";
    
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.xmg_height;
        self.tableView.contentInset = inset;
        // 如果是点击刷新，则需要手动修改偏移量来下移
        CGPoint offset = self.tableView.contentOffset;
        offset.y = - inset.top;
        self.tableView.contentOffset = offset;
    }];
    // 加载新帖子
    [self loadNewTopic];
}
// 头部结束刷新
- (void)headeEndRefreshing {
#warning 这句加放在动画后面会导致启动时第一次刷新后，文字不恢复，原因不明
    self.isHeaderRefreshing = NO;
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.xmg_height;
        self.tableView.contentInset = inset;
    }];
}

#pragma mark - footer

// 根据位置处理尾部显示内容
- (void)dealFooter {
    // 防止程序启动就调用
    if (self.topicItemArray.count == 0) return;
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

@end
