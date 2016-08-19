//
//  XMGTopicVideoView.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGTopicVideoView.h"
#import "XMGTopicItem.h"
#import <UIImageView+WebCache.h>
#import "XMGSeeBigPictureViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XMGTopicVideoView ()


@property (weak, nonatomic) IBOutlet YYAnimatedImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@end
@implementation XMGTopicVideoView

- (CGRect)videoImageViewFrame {
    return self.videoImageView.frame;
}

- (void)awakeFromNib {
//    self.autoresizingMask = UIViewAutoresizingNone;
    self.videoImageView.userInteractionEnabled = YES;
    [self.videoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}
- (IBAction)playBtnClick:(id)sender {
    [self seeBigPicture];
}

- (void)seeBigPicture {
////    XMGSeeBigPictureViewController *vc = [[XMGSeeBigPictureViewController alloc] init];
//    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:self.item.videouri]];
////    vc.item = self.item;
//    //    [UIApplication sharedApplication].keyWindow.rootViewController这种取法一定有值
//    //    self.window这种取法当view不在window上会出现无值
//    NSLog(@"%@", self.window.rootViewController);
//    [self.window.rootViewController presentViewController :vc animated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(topicVideoViewDidClickVideo:)]) {
        [self.delegate topicVideoViewDidClickVideo:self];
    }
}

- (void)setItem:(XMGTopicItem *)item {
    _item = item;
//    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:item.image0]];
//    self.playCountLabel.text = [NSString stringWithFormat:@"播放次数:%zd", item.playcount];
//    self.dingLabel.text = [NSString stringWithFormat:@"点赞:%@", item.ding];
    self.videoImageView.runloopMode = NSDefaultRunLoopMode;
    [self.videoImageView downloadImageWithOriginalImageName:item.image1 thumbnailImageName:item.image0 placeholderImage:nil completed:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    self.playCountLabel.text = [NSString stringWithFormat:@"播放次数:%zd", item.playcount];
//    self.videotimeLabel.text = [NSString stringWithFormat:@"%zds", item.videotime];
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", item.videotime / 60, item.videotime % 60];
}

@end
