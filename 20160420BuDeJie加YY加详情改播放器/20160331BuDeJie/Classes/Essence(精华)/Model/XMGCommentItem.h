//
//  XMGCommentItem.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/8/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGCommentItem : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *profile_image;
@property (nonatomic, strong) NSString *is_vip;
@property (nonatomic, strong) NSString *like_count;

@property (nonatomic, strong) XMGCommentItem *precmt;

+ (XMGCommentItem *)commentItemWithDict:(NSDictionary *)dict;

// 非网络数据
@property (nonatomic, assign) CGFloat cellHeight;

@end
