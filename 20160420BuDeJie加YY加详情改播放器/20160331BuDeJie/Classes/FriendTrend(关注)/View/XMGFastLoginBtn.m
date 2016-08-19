//
//  XMGFastLoginBtn.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGFastLoginBtn.h"

@implementation XMGFastLoginBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect tempFI = self.imageView.frame;
    tempFI.origin.y = 0;
    self.imageView.frame = tempFI;
    self.imageView.xmg_centerX = self.frame.size.width * 0.5;
    
    [self.titleLabel sizeToFit];
    CGRect tempFT = self.titleLabel.frame;
    tempFT.origin.y = self.frame.size.height - tempFT.size.height;
//    tempFT.origin.x = tempFI.origin.x;
    self.titleLabel.frame = tempFT;
    self.titleLabel.xmg_centerX = self.frame.size.width * 0.5;
}

@end
