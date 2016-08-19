//
//  XMGFastLoginView.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGFastLoginView.h"

@implementation XMGFastLoginView

+ (instancetype)fastLoginView {
    return [[NSBundle mainBundle] loadNibNamed:@"XMGFastLoginView" owner:nil options:nil][0];
}

- (IBAction)sinaClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSinaLogin:)]) {
        [self.delegate didClickSinaLogin:self];
    }
}

@end
