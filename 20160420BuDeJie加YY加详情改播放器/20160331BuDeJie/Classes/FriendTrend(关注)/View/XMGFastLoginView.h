//
//  XMGFastLoginView.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGFastLoginView;
@protocol XMGFastLoginViewDelegate <NSObject>

- (void)didClickSinaLogin:(XMGFastLoginView *)fastLoginView;

@end
@interface XMGFastLoginView : UIView
+ (instancetype)fastLoginView;
@property (nonatomic, weak) id<XMGFastLoginViewDelegate> delegate;
@end
