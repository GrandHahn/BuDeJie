//
//  UIView+Frame.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setXmg_centerX:(CGFloat)xmg_centerX {
    CGPoint tempCenter = self.center;
    tempCenter.x = xmg_centerX;
    self.center = tempCenter;
}

- (CGFloat)xmg_centerX {
    return self.center.x;
}

- (void)setXmg_centerY:(CGFloat)xmg_centerY {
    CGPoint tempCenter = self.center;
    tempCenter.y = xmg_centerY;
    self.center = tempCenter;
}

- (CGFloat)xmg_centerY {
    return self.center.y;
}

- (void)setXmg_height:(CGFloat)xmg_height {
    CGRect tempF = self.frame;
    tempF.size.height = xmg_height;
    self.frame = tempF;
}
- (CGFloat)xmg_height {
    return self.frame.size.height;
}

- (void)setXmg_width:(CGFloat)xmg_width {
    CGRect tempF = self.frame;
    tempF.size.width = xmg_width;
    self.frame = tempF;
}
- (CGFloat)xmg_width {
    return self.frame.size.width;
}

- (void)setXmg_y:(CGFloat)xmg_y {
    CGRect tempF = self.frame;
    tempF.origin.y = xmg_y;
    self.frame = tempF;
}
- (CGFloat)xmg_y {
    return self.frame.origin.y;
}

- (void)setXmg_x:(CGFloat)xmg_x {
    CGRect tempF = self.frame;
    tempF.origin.x = xmg_x;
    self.frame = tempF;
}
- (CGFloat)xmg_x {
    return self.frame.origin.x;
}
@end
