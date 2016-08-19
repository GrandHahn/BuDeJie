//
//  XMGLoginRegisterViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/6.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGLoginRegisterViewController.h"
#import "XMGLoginRegisterView.h"
#import "XMGFastLoginView.h"
#import "UMSocial.h"
@interface XMGLoginRegisterViewController () <XMGFastLoginViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleVLeadingCons;
@property (nonatomic, weak) IBOutlet UIView *loginMiddleView;
@property (weak, nonatomic) IBOutlet UIView *loginBottomView;
@end

@implementation XMGLoginRegisterViewController
- (IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.middleVLeadingCons.constant = self.middleVLeadingCons.constant == 0 ? -XMGScreenW : 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 登陆view
    XMGLoginRegisterView *loginView = [XMGLoginRegisterView loginRegisterView];
    [self.loginMiddleView addSubview:loginView];
    
    // 注册view
    XMGLoginRegisterView *registerView = [XMGLoginRegisterView registerView];
//    CGRect tempF = registerView.frame;
    /*
     2016-04-06 20:08:08.253 20160331BuDeJie[3616:127097] 414.000000
     2016-04-06 20:08:08.253 20160331BuDeJie[3616:127097] 375.000000
     */
//    NSLog(@"%f", XMGScreenW);
//    NSLog(@"%f", self.loginMiddleView.frame.size.width * 0.5);
//    tempF.origin.x = self.loginMiddleView.frame.size.width * 0.5;
//    registerView.frame = tempF;
//    NSLog(@"%f", tempF.size.width);
    [self.loginMiddleView addSubview:registerView];
    
//    XMGLoginRegisterView *loginV = self.loginMiddleView.subviews[0];
//    loginV.frame = CGRectMake(0, 0, self.loginMiddleView.frame.size.width * 0.5, self.loginMiddleView.frame.size.height);
//    XMGLoginRegisterView *regiV = self.loginMiddleView.subviews[1];
//    regiV.frame = CGRectMake(self.loginMiddleView.frame.size.width * 0.5, 0, self.loginMiddleView.frame.size.width * 0.5, self.loginMiddleView.frame.size.height);
    
    
    XMGFastLoginView *fastV = [XMGFastLoginView fastLoginView];
    fastV.delegate = self;
    [self.loginBottomView addSubview:fastV];
}

- (void)didClickSinaLogin:(XMGFastLoginView *)fastLoginView {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
}

// 这里设尺寸才最准确
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLog(@"%f", XMGScreenW);
//    NSLog(@"%f", self.loginMiddleView.frame.size.width * 0.5);
    XMGLoginRegisterView *loginV = self.loginMiddleView.subviews[0];
    loginV.frame = CGRectMake(0, 0, self.loginMiddleView.frame.size.width * 0.5, self.loginMiddleView.frame.size.height);
    XMGLoginRegisterView *regiV = self.loginMiddleView.subviews[1];
    regiV.frame = CGRectMake(self.loginMiddleView.frame.size.width * 0.5, 0, self.loginMiddleView.frame.size.width * 0.5, self.loginMiddleView.frame.size.height);
    
    XMGFastLoginView *fastV = self.loginBottomView.subviews[0];
    fastV.frame = self.loginBottomView.bounds;
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
