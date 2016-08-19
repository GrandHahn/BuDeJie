//
//  UIImageView+Download.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/16.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

#import "YYWebImage.h"
@interface YYAnimatedImageView (Download)
// 根据网络状态下载图片
- (void)downloadImageWithOriginalImageName:(NSString *)originalImageName thumbnailImageName:(NSString *)thumbnailImageName placeholderImage:(UIImage *)placeholderImage completed:(YYWebImageCompletionBlock)completedBlock;
@end
