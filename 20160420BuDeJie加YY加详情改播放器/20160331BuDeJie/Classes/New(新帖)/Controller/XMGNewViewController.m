//
//  XMGNewViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGNewViewController.h"
#import "XMGSubTagViewController.h"

#import "XMGTopicViewController.h"
@interface XMGNewViewController ()

@end

@implementation XMGNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor blueColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highImageName:@"MainTagSubIconClick" target:self action:@selector(subTag)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    
    
    // 去掉nav右边按钮
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)subTag {
    XMGSubTagViewController *subTagVC = [[XMGSubTagViewController alloc] init];
    [self.navigationController pushViewController:subTagVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 重写成新帖,来请求新帖数据
- (void)setupAllChildVCs {
    [super setupAllChildVCs];
    
    for (XMGTopicViewController *vc in self.childViewControllers) {
        vc.requestParaA = @"newlist";
    }
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
