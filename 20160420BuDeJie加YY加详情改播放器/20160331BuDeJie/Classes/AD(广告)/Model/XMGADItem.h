//
//  XMGADItem.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/5.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGADItem : NSObject
/** 广告图片*/
@property (nonatomic ,strong) NSString *w_picurl;
/** 广告界面跳转地址*/
@property (nonatomic ,strong) NSString *ori_curl;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@end
