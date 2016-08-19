//
//  XMGTopicVoiceView.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGTopicVoiceView.h"
#import "XMGTopicItem.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
@interface XMGTopicVoiceView ()


@property (weak, nonatomic) IBOutlet YYAnimatedImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *voicetime_Label;

@end

@implementation XMGTopicVoiceView

- (void)awakeFromNib {
//    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.middleImageView.userInteractionEnabled = YES;
    [self.middleImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBtnClick:)]];
}

- (void)setItem:(XMGTopicItem *)item {
    _item = item;
    self.playCountLabel.text = [NSString stringWithFormat:@"播放次数:%zd", item.playcount];
//    self.voicetime_Label.text = [NSString stringWithFormat:@"%zds", item.voicetime];
    self.voicetime_Label.text = [NSString stringWithFormat:@"%02ld:%02ld", item.voicetime / 60, item.voicetime % 60];
    
//    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:item.image0]];
    
    /*
    // 根据网络状态下载图片
    // 判断内存和沙盒缓存中有没原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.image1];
    if (originalImage) { // 内存和沙盒缓存有原图
        // 取消正在下载(防止循环利用导致图片被上一个下载完成后设置)
        // 设置原图
        [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:item.image1]];
    } else {
#warning 一定要sharedManager
        // 判断网络
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        if (manager.isReachableViaWiFi) { // wifi
            // 取消正在下载
            // 下载原图
            [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:item.image1] placeholderImage:nil];
        } else if (manager.isReachableViaWWAN) { // 手机网络
            // 判断用户设置手机网络下是否下载原图
            BOOL alwaysDownloadOriginalImage = [[NSUserDefaults standardUserDefaults] boolForKey:@"alwaysDownloadOriginalImage"];
            if (alwaysDownloadOriginalImage) { // 设置为下载原图
                // 取消正在下载
                // 下载原图
                [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:item.image1] placeholderImage:nil];
            } else { // 设置为下载缩略图
                // 取消正在下载
                // 下载缩略图
                [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:item.image0] placeholderImage:nil];
            }
        } else { // 无网络
            // 判断内存和沙盒缓存中有没有缩略图
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.image0];
            if (thumbnailImage) { // 有缩略图
                // 取消正在下载
                // 设置缩略图
                [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:item.image0]];
            } else { // 没缩略图
                // 取消正在下载
                // 设置占位图
                [self.middleImageView sd_setImageWithURL:nil placeholderImage:nil];
            }
        }
    }*/
    self.middleImageView.runloopMode = NSDefaultRunLoopMode;
    [self.middleImageView downloadImageWithOriginalImageName:item.image1 thumbnailImageName:item.image0 placeholderImage:nil completed:^(UIImage * _Nullable image,NSURL *url,YYWebImageFromType from,YYWebImageStage stage,NSError * _Nullable error) {
        
    }];
    
}

- (IBAction)playBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(topicVoiceViewDidClickVoice:)]) {
        [self.delegate topicVoiceViewDidClickVoice:self];
    }
}

@end
