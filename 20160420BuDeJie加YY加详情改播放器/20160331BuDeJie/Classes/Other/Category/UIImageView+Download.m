//
//  UIImageView+Download.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/16.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "UIImageView+Download.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@implementation YYAnimatedImageView (Download)

//(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)

// 根据网络状态下载图片
- (void)downloadImageWithOriginalImageName:(NSString *)originalImageName thumbnailImageName:(NSString *)thumbnailImageName placeholderImage:(UIImage *)placeholderImage completed:(YYWebImageCompletionBlock)completedBlock {
//    UIImage *placeholderImage = [UIImage imageNamed:placeholderImageName];
    // 判断内存和沙盒缓存中有没原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalImageName];
    if (originalImage) { // 内存和沙盒缓存有原图
        // 取消正在下载(防止循环利用导致图片被上一个下载完成后设置)
        // 设置原图
//        [self sd_setImageWithURL:[NSURL URLWithString:originalImageName] completed:completedBlock];
        [self yy_setImageWithURL:[NSURL URLWithString:originalImageName] placeholder:nil options:0 completion:completedBlock];
    } else {
#warning 一定要sharedManager
        // 判断网络
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        if (manager.isReachableViaWiFi) { // wifi
            // 取消正在下载
            // 下载原图
//            [self sd_setImageWithURL:[NSURL URLWithString:originalImageName] placeholderImage:placeholderImage completed:completedBlock];
            [self yy_setImageWithURL:[NSURL URLWithString:originalImageName] placeholder:placeholderImage options:0 completion:completedBlock];
            
        } else if (manager.isReachableViaWWAN) { // 手机网络
            // 判断用户设置手机网络下是否下载原图
            BOOL alwaysDownloadOriginalImage = [[NSUserDefaults standardUserDefaults] boolForKey:@"alwaysDownloadOriginalImage"];
            if (alwaysDownloadOriginalImage) { // 设置为下载原图
                // 取消正在下载
                // 下载原图
//                [self sd_setImageWithURL:[NSURL URLWithString:originalImageName] placeholderImage:placeholderImage completed:completedBlock];
                [self yy_setImageWithURL:[NSURL URLWithString:originalImageName] placeholder:placeholderImage options:0 completion:completedBlock];
            } else { // 设置为下载缩略图
                // 取消正在下载
                // 下载缩略图
//                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageName] placeholderImage:placeholderImage completed:completedBlock];
                [self yy_setImageWithURL:[NSURL URLWithString:originalImageName] placeholder:placeholderImage options:0 completion:completedBlock];
            }
        } else { // 无网络
            // 判断内存和沙盒缓存中有没有缩略图
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageName];
            if (thumbnailImage) { // 有缩略图
                // 取消正在下载
                // 设置缩略图
//                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageName] completed:completedBlock];
                [self yy_setImageWithURL:[NSURL URLWithString:thumbnailImageName] placeholder:placeholderImage options:0 completion:completedBlock];
            } else { // 没缩略图
                // 取消正在下载
                // 设置占位图
//                [self sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];
                [self yy_setImageWithURL:nil placeholder:placeholderImage options:0 completion:completedBlock];
                
            }
        }
    }
}

@end
