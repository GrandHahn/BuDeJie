//
//  XMGTabBarController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGTabBarController.h"

#import "XMGEssenceViewController.h"
#import "XMGNewViewController.h"
#import "XMGPublishViewController.h"
#import "XMGFriendViewController.h"
#import "XMGMeViewController.h"

#import "XMGNavigationController.h"

#import "XMGTabBar.h"

@interface XMGTabBarController ()

@end

@implementation XMGTabBarController

+ (void)load {
    // 设置字体
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    NSDictionary *dictSelected = @{@"NSColor":[UIColor blackColor]};
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
    NSDictionary *dictNormal = @{@"NSFont":[UIFont systemFontOfSize:15]};
//    NSMutableDictionary *dictFont = [NSMutableDictionary dictionary];
//    dictFont[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    // normal才能设置字体大小
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    
#warning 打印字典可看见真实key，NSFontAttributeName -》NSFont
    //    NSLog(@"%@", dictFont);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加所有子控制器
    [self setUpAllChildVC];
    
    // 设置所有tabbar内容
    [self setUpAllTabBarTitle];
    
    // 自定义tabBar
    [self setUpTabBar];
}

- (void)setUpTabBar {
    XMGTabBar *tabBar = [[XMGTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
//    tabBar.delegate = self;
    tabBar.middleBtnBlock = ^(){
        XMGPublishViewController *publishVC = [[XMGPublishViewController alloc] init];
    
        [self presentViewController:publishVC animated:NO completion:^{
    
        }];
    };
}

// 设置所有tabbar内容
- (void)setUpAllTabBarTitle {
    // 数组记录数据
    NSArray *arrayTitle = @[@"精华", @"新帖", @"关注", @"我"];
    NSArray *arrayImageName = @[@"essence", @"new", @"friendTrends", @"me"];
    // 遍历子控制器设置tabbar内容
    for (int i = 0; i < arrayTitle.count; i++) {
        [self setUpOneTabBarTitleWithIndex:i title:arrayTitle[i] imageName:arrayImageName[i] selectedImageName:arrayImageName[i]];
    }
}

// 设置一个tabbar内容
- (void)setUpOneTabBarTitleWithIndex:(NSInteger)num title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 取出子控制器
    UINavigationController *nav = self.childViewControllers[num];
    // 设置tabBarItem
    nav.tabBarItem.title = title;
    imageName = [NSString stringWithFormat:@"tabBar_%@_icon", imageName];
    nav.tabBarItem.image = [self originalImageWithImageName:imageName];
    selectedImageName = [NSString stringWithFormat:@"tabBar_%@_click_icon", selectedImageName];
    nav.tabBarItem.selectedImage = [self originalImageWithImageName:selectedImageName];
}

// 返回原色图片
- (UIImage *)originalImageWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// 添加所有子控制器
- (void)setUpAllChildVC {
    // 精华
    XMGEssenceViewController *essenceVC = [[XMGEssenceViewController alloc] init];
    [self setUpOneChildVC:essenceVC];
    // 新帖
    XMGNewViewController *newVC = [[XMGNewViewController alloc] init];
    [self setUpOneChildVC:newVC];
//    // 发布
//    XMGPublishViewController *publishVC = [[XMGPublishViewController alloc] init];
//    [self setUpOneChildVC:publishVC];
    // 关注
    XMGFriendViewController *friendTrendVC = [[XMGFriendViewController alloc] init];
    [self setUpOneChildVC:friendTrendVC];
    // 我
//    XMGMeViewController *meVC = [[XMGMeViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XMGMeViewController" bundle:nil];
    XMGMeViewController *meVC = [storyboard instantiateInitialViewController];
    [self setUpOneChildVC:meVC];
}

// 添加一个子控制器
- (void)setUpOneChildVC:(UIViewController *)vc {
    XMGNavigationController *navC = [[XMGNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - XMGTabBarDelegate
//- (void)tabBarDidClickMiddleBtn:(XMGTabBar *)tabBar {
//    XMGPublishViewController *publishVC = [[XMGPublishViewController alloc] init];
//    
//    [self presentViewController:publishVC animated:YES completion:^{
//        
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
