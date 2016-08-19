//
//  UIBarButtonItem+Item.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/3.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
+ (instancetype)barButtonItemWithImageName:(NSString *)image highImageName:(NSString *)highImage target:(nullable id)target action:(SEL)action;

+ (instancetype)barButtonItemWithImageName:(NSString *)image selImageName:(NSString *)selImage target:(id)target action:(SEL)action;
@end
