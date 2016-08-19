//
//  XMGSubTagCell.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/5.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGSubTagCell.h"
#import "XMGSubTagItem.h"
#import <UIImageView+WebCache.h>
@interface XMGSubTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;


@end

@implementation XMGSubTagCell

- (void)setItem:(XMGSubTagItem *)item {
    _item = item;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            return;
        }
        // 1.开启图形上下文
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        // 2.描述路径
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        // 3.设置裁剪
        [path addClip];
        // 4.画图
        [image drawAtPoint:CGPointZero];
        // 5.取图
        image = UIGraphicsGetImageFromCurrentImageContext();
        // 6.关闭上下文
        UIGraphicsEndImageContext();
        
        self.iconView.image = image;
    }];
    self.nameView.text = item.theme_name;
//    self.numView.text = item.sub_number;
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅", item.sub_number];
    NSInteger num = numStr.intValue;
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅", numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.numView.text = numStr;
}

//- (void)awakeFromNib {
//    // Initialization code
//    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
//    self.iconView.layer.masksToBounds = YES;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    
//    CGRect f = frame;
//    f.size.height -= 1;
//    frame = f;
    
    [super setFrame:frame];
}

@end
