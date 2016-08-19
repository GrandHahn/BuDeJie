//
//  XMGTabBar.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGTabBar.h"

@interface XMGTabBar ()

@property (nonatomic, weak) UIButton *middleBtn;
@property (nonatomic, weak) UIControl *previousClickedButton;

@end

@implementation XMGTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIButton *)middleBtn {
    if (_middleBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleBtn = btn;
        [_middleBtn setImage:[self originalImageWithImageName:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [_middleBtn setImage:[self originalImageWithImageName:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [_middleBtn sizeToFit];
        [self addSubview:self.middleBtn];
        
        [_middleBtn addTarget:self action:@selector(middleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleBtn;
}

- (void)middleBtnClick:(UIButton *)middleBtn {
//    if ([self.delegate respondsToSelector:@selector(tabBarDidClickMiddleBtn:)]) {
//        [self.delegate tabBarDidClickMiddleBtn:self];
//    }
    self.middleBtnBlock();
}

// 返回原色图片
- (UIImage *)originalImageWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"%@", self.items);
//    NSLog(@"%@", self.subviews);
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / (self.items.count + 1);
    CGFloat btnH = self.bounds.size.height;
    for (int i = 0; i < self.subviews.count; i++) {
        // 系统私有UITabBarButton
        UIView *tabBarButton = self.subviews[i];
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 程序启动赋值previousClickedButton
            if (btnX == 0 && self.previousClickedButton == nil) {
                self.previousClickedButton = (UIControl *)tabBarButton;
            }
            
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btnX += btnW;
            // 中间留位置
            if (btnX == 2 * btnW) {
                btnX += btnW;
            }
            // 监听点击
            [(UIControl *)tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // 设置中间按钮位置
    self.middleBtn.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    // 判断重复点击
    if (self.previousClickedButton == tabBarButton) {
//        XMGFunc
        [[NSNotificationCenter defaultCenter] postNotificationName:XMGTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.previousClickedButton = tabBarButton;
}

@end
