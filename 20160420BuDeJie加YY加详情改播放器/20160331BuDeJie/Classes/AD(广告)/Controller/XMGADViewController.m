//
//  XMGADViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/5.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGADViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGADItem.h"
#import <UIImageView+WebCache.h>
#import "XMGTabBarController.h"

#define XMGCode2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
@interface XMGADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *ADView;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@property (nonatomic ,weak) UIImageView *imageV;

@property (nonatomic, strong) XMGADItem *adItem;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation XMGADViewController
- (BOOL)prefersStatusBarHidden {return YES;}
- (UIImageView *)imageV {
    if (!_imageV) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageV = imageV;
        
        [self.ADView addSubview:imageV];
        
        imageV.userInteractionEnabled = YES;
        // 点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageV addGestureRecognizer:tap];
    }
    return _imageV;
}

- (void)tap {
    // 跳转
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:[NSURL URLWithString:self.adItem.ori_curl]]) {
        [app openURL:[NSURL URLWithString:self.adItem.ori_curl]];
    }
}

- (IBAction)skipBtnClick:(id)sender {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[XMGTabBarController alloc] init];
    // 销毁定时器
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 启动图片
    [self setUpLaunchImageView];
    
    // 广告
    [self setUpADView];
    
    // 定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

- (void)timeChange {
    static int i = 3;
    if (i <= 0) {
        [self skipBtnClick:nil];
    }
    i--;
    
    NSString *str = [NSString stringWithFormat:@"跳过（%zd）", i];
    [self.skipBtn setTitle:str forState:UIControlStateNormal];
}

- (void)setUpADView {
    // 1.会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.请求参数
    NSDictionary *dict = @{
                           @"code2":XMGCode2
                           };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 3.发送请求你
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        // 取出字典
        NSArray *ad = responseObject[@"ad"];
        NSDictionary *adDict = ad[0];
        // 字典转模型
        XMGADItem *item = [XMGADItem mj_objectWithKeyValues:adDict];
        self.adItem = item;
        // 防止除以0
        if (item.w <= 0) {
            return;
        }
        // 设置frame
        self.imageV.frame = CGRectMake(0, 0, XMGScreenW, XMGScreenW / item.w * item.h);
        // 加载图片
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.w_picurl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)setUpLaunchImageView {
    UIImage *image;
    if (iphone6P) {
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if (iphone6) {
        image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (iphone5) {
        image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    } else if (iphone4) {
        image = [UIImage imageNamed:@"LaunchImage-700"];
    }
    
    self.launchImageView.image = image;
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
