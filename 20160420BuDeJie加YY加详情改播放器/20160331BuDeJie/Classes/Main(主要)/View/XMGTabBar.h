//
//  XMGTabBar.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class XMGTabBar;
//@protocol XMGTabBarDelegate <NSObject>
//
//- (void)tabBarDidClickMiddleBtn:(XMGTabBar *)tabBar;
//
//@end

@interface XMGTabBar : UITabBar
//@property (nonatomic, weak) id<XMGTabBarDelegate> delegate;

@property (nonatomic, strong) void(^middleBtnBlock)();
@end
