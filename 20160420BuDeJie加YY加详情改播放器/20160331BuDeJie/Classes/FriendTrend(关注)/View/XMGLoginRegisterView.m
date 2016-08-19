//
//  XMGLoginRegisterView.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/6.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGLoginRegisterView.h"

@interface XMGLoginRegisterView ()

@property (nonatomic, weak) IBOutlet UIButton *loginBtn;

@end


@implementation XMGLoginRegisterView

+ (instancetype)loginRegisterView {
    return [[NSBundle mainBundle] loadNibNamed:@"XMGLoginRegisterView" owner:nil options:nil][0];
}

+ (instancetype)registerView {
    return [[NSBundle mainBundle] loadNibNamed:@"XMGLoginRegisterView" owner:nil options:nil][1];
}

- (void)awakeFromNib {
    UIImage *image = self.loginBtn.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.width * 0.5];
    [self.loginBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end
