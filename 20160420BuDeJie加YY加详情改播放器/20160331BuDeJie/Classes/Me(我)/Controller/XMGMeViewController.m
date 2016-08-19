//
//  XMGMeViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGMeViewController.h"
#import "XMGSettingViewController.h"
#import "XMGSquareCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGSquareItem.h"
#import "XMGWebViewController.h"

static NSString * const ID = @"cell";
static CGFloat const margin = 1;
static NSInteger const cols = 4;
#define itemWH ((XMGScreenW - (cols - 1) * margin) / (cols))
@interface XMGMeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *squareItemArray;
@property (nonatomic, weak) UICollectionView *collectionV;
@end

@implementation XMGMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *item1 = [UIBarButtonItem barButtonItemWithImageName:@"mine-setting-icon" highImageName:@"mine-setting-icon-click" target:self action:@selector(setting)];
    UIBarButtonItem *item2 = [UIBarButtonItem barButtonItemWithImageName:@"mine-moon-icon" selImageName:@"mine-moon-icon-click" target:self action:@selector(night:)];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
    
    self.navigationItem.title = @"我";

    // 设置footerView
    [self setUpFooterView];
    
    // 获取网络数据
    [self getFooterViewData];
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    cell.xmg_centerY = 250;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    NSLog(@"%@", cell);
}

- (void)resolvesquareItemArray {
    // 求余,计算是否刚好填充最后一行
    NSInteger count = self.squareItemArray.count % cols;
    // 没填充完,增加模型填充
    if (count) {
        count = 4 - count;
        for (int i = 0; i < count; i++) {
            XMGSquareItem *item = [[XMGSquareItem alloc] init];
            [self.squareItemArray addObject:item];
        }
    }
}

- (void)getFooterViewData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//        [responseObject writeToFile:@"/Users/hahn/Desktop/20160406BuDeJie/me.plist" atomically:YES];
        NSArray *array = responseObject[@"square_list"];
        self.squareItemArray = [XMGSquareItem mj_objectArrayWithKeyValuesArray:array];
        
        // 判断是否填充一行,没则填充
        [self resolvesquareItemArray];
        
//        [self.tableView reloadData];
        [self.collectionV reloadData];
        
        // collectionView高度
        NSInteger count = self.squareItemArray.count;
        NSInteger rows = (count - 1) / cols + 1;
        // 当collectionV.xmg_height小于里面的cell占的行高时，就会有滚动
        self.collectionV.xmg_height = rows * itemWH + (rows - 1) * margin;
//        self.collectionV.scrollEnabled = NO;
        
//        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionV.frame));
        // 系统根据内容自动计算滚动范围
        self.tableView.tableFooterView = self.collectionV;
        
#warning collectionV底下有空隙时，就调用这句解决。实际上不调用也没，原因未知
        // 重新计算contentSize
//        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

/*
 布局，注册cell，自定义cell
 */
- (void)setUpFooterView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XMGScreenW, 300) collectionViewLayout: layout];
    collectionV.backgroundColor = [UIColor lightGrayColor];
    
    [collectionV registerNib:[UINib nibWithNibName:@"XMGSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    self.tableView.tableFooterView = collectionV;
    
    collectionV.dataSource = self;
    collectionV.delegate = self;
    
    self.collectionV = collectionV;
    
    // 去掉collectionV点击回顶部
    collectionV.scrollsToTop = NO;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMGSquareItem *item = self.squareItemArray[indexPath.item];
    if (![item.url containsString:@"http"]) {
        return;
    }
    
    XMGWebViewController *webVC = [[XMGWebViewController alloc] init];
    NSURL *url = [NSURL URLWithString:item.url];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - collectionViewDataDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.squareItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMGSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    XMGSquareItem *item = self.squareItemArray[indexPath.item];
    cell.item = item;
    
    return cell;
}

- (void)setting {
    XMGSettingViewController *settingVC = [[XMGSettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)night:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
