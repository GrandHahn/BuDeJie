//
//  XMGCommentItem.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/8/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGCommentItem.h"

@implementation XMGCommentItem

+ (XMGCommentItem *)commentItemWithDict:(NSDictionary *)dict {
    XMGCommentItem *item = [[self alloc] init];
    item.ID = dict[@"id"];
    item.content = dict[@"content"];
    item.username = dict[@"user"][@"username"];
    item.sex = dict[@"user"][@"sex"];
    item.profile_image = dict[@"user"][@"profile_image"];
    item.is_vip = dict[@"user"][@"is_vip"];
    item.like_count = dict[@"like_count"];
    
    NSDictionary *precmtDict = dict[@"precmt"];
    if (precmtDict.count != 0) {
        XMGCommentItem *precmtItem = [XMGCommentItem commentItemWithDict:precmtDict];
        item.precmt = precmtItem;
    }
    
    return item;
}

- (CGFloat)cellHeight {
    // 防止重复计算
    if (_cellHeight) {
        return _cellHeight;
    }
    
    _cellHeight += 32;
    
    NSString *contentStr = nil;
    if (self.precmt) { // 有被评论用户
        contentStr = [NSString stringWithFormat:@"%@//@%@:%@", self.content, self.precmt.username, self.precmt.content];
    } else { // 无被评论用户
        contentStr = self.content;
    }
    CGSize maxSize = CGSizeMake(XMGScreenW - 40 - 60, MAXFLOAT);
    _cellHeight += [contentStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height + 10;
    
//    _cellHeight += 50 + 10;
    
    return _cellHeight;
}

@end
