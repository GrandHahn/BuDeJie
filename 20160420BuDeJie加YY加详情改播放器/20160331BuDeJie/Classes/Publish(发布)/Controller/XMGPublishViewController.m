//
//  XMGPublishViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGPublishViewController.h"
#define fallAnimOffsetY 1000
#define fallAnimDuration 1.0
@interface XMGPublishViewController ()
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSMutableArray *labelArr;

@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation XMGPublishViewController

- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
- (NSMutableArray *)labelArr {
    if (!_labelArr) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}


-(void)loadView {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareBottomBackground"]];
    imageV.frame = [UIScreen mainScreen].bounds;
    //如果一个控件它的父控件不能够接收事件,那么它里面的子控件都不能够接收事件.
    imageV.userInteractionEnabled = YES;
    self.view = imageV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor greenColor];
    [self setupUI];
}

- (void)setupUI {
    CGFloat screenW = XMGScreenW;
    CGFloat screenH = XMGScreenH;
    CGFloat w = screenW;
    CGFloat h = 44;
    CGFloat x = 0;
    CGFloat y = screenH - h;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(x, y, w, h);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    //    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"shareButtonCancel"] forState:UIControlStateNormal];
    //    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"shareButtonCancelClick"] forState:UIControlStateHighlighted];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat btnOffsetY = 300;
    int cols = 3;
    CGFloat btnW = 72;
    CGFloat btnH = 72;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat marginH = (XMGScreenW - cols * btnW) / (cols + 1);
    CGFloat marginV = marginH;
    NSArray *imgArr = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *labelArr = @[@"发视频",@"发图片",@"发段子",@"发声音",@"发审帖",@"发链接",];
    for (int i = 0; i < imgArr.count; i++) {
        
        btnX = marginH + (marginH + btnW) * (i % cols);
        btnY = (marginV + btnH) * (i / cols) + btnOffsetY;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.xmg_y -= fallAnimOffsetY;
        [btn setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [self.btnArr addObject:btn];
        
#warning 如果在btnY里有减去fallAnimOffsetY，通过btnY来设定label的y时就不需要再减去fallAnimOffsetY
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnX, btnY + btnH , btnW, marginV)];
        label.xmg_y -= fallAnimOffsetY;
        label.text = labelArr[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [self.labelArr addObject:label];
        
        NSArray *timeScale = @[@6, @4, @5, @3, @1, @2];
//        CGFloat time = fallAnimDuration * (imgArr.count - i) / imgArr.count;
        CGFloat time = fallAnimDuration * [timeScale[i] floatValue] / 6.0 * 0.25;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:fallAnimDuration animations:^{
//                
//            }];
            [UIView animateWithDuration:fallAnimDuration * 0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                btn.xmg_y += fallAnimOffsetY;
                label.xmg_y += fallAnimOffsetY;
            } completion:^(BOOL finished) {
//                NSLog(@"%f,", label.xmg_y);
            }];
        });
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"app_slogan"];
    [imageView sizeToFit];
    imageView.xmg_x = (XMGScreenW - imageView.xmg_width) * 0.5;
    imageView.xmg_y = 150 - fallAnimOffsetY;
    [self.view addSubview:imageView];
    self.imageV = imageView;
    
    CGFloat imgViewTime = (fallAnimDuration / imgArr.count + fallAnimDuration) * 0.25;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(imgViewTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:fallAnimDuration animations:^{
//            imageView.xmg_y += fallAnimOffsetY;
//        }];
        [UIView animateWithDuration:fallAnimDuration * 0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.xmg_y += fallAnimOffsetY;
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)cancelBtnClick {
    
    
    for (int i = 0; i<self.btnArr.count; i++) {
        UIButton *btn = (UIButton *)self.btnArr[i];
        UILabel *label = (UILabel *)self.labelArr[i];
        NSArray *timeScale = @[@6, @4, @5, @3, @1, @2];

        CGFloat time = fallAnimDuration * [timeScale[i] floatValue] / 6.0 * 0.25;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:fallAnimDuration * 0.7 animations:^{
                btn.xmg_y += fallAnimOffsetY;
                label.xmg_y += fallAnimOffsetY;

            }];

        });
        
        
        
        CGFloat imgViewTime = (fallAnimDuration / self.btnArr.count + fallAnimDuration) * 0.25;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(imgViewTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:fallAnimDuration * 0.3 animations:^{
                self.imageV.xmg_y += fallAnimOffsetY;
            } completion:^(BOOL finished) {
                
                [self dismissViewControllerAnimated:NO completion:^{
                }];
            }];
        });
    }
    
    
        
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
