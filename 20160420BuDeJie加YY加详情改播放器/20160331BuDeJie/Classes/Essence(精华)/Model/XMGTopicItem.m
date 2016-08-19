//
//  XMGTopicItem.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/12.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGTopicItem.h"

@implementation XMGTopicItem

- (CGFloat)cellHeight {
    // 防止重复计算
    if (_cellHeight) {
        return _cellHeight;
    }
    
    _cellHeight += 70;
    
    CGSize maxSize = CGSizeMake(XMGScreenW - 2 * 10, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height + 10;
    
    // 计算中间view的高度
    if (self.type != XMGTopicTypeWord) {
        if (self.width != 0) {
            CGFloat height = self.height * maxSize.width / self.width;
            CGFloat width = maxSize.width;
            
            if (height >= XMGScreenH) {
                height = XMGScreenH * 0.3;
                self.bigPicture = YES;
            }
            
            CGFloat x = 10;
            CGFloat y = _cellHeight;
            self.middleFrame = CGRectMake(x, y, width, height);
            _cellHeight += height + 10;
        }
    }
    
    
    // 有热评
    if (self.top_cmt.count) {
        _cellHeight += 21;
        
        NSDictionary *dict = self.top_cmt[0];
        NSString *username = dict[@"user"][@"username"];
        NSString *content = self.top_cmt[0][@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *topComtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [topComtText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height + 10;
    }
    
    _cellHeight += 50 + 10;
    
    return _cellHeight;
}

@end
