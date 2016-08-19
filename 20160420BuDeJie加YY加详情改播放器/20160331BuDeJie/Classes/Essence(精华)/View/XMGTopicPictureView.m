//
//  XMGTopicPictureView.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "XMGTopicItem.h"
#import <UIImageView+WebCache.h>
#import "XMGSeeBigPictureViewController.h"

@interface XMGTopicPictureView ()


@property (weak, nonatomic) IBOutlet YYAnimatedImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;


@end
@implementation XMGTopicPictureView

- (void)awakeFromNib {
//    self.autoresizingMask = UIViewAutoresizingNone;
    self.pictureImageView.userInteractionEnabled = YES;
    [self.pictureImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

- (IBAction)seeBigPictureBtnClick:(id)sender {
    [self seeBigPicture];
}

- (void)seeBigPicture {
    XMGSeeBigPictureViewController *vc = [[XMGSeeBigPictureViewController alloc] init];
    
    vc.item = self.item;
//    [UIApplication sharedApplication].keyWindow.rootViewController这种取法一定有值
//    self.window这种取法当view不在window上会出现无值
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setItem:(XMGTopicItem *)item {
    _item = item;
    //    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:item.image0]];
    self.pictureImageView.runloopMode = NSDefaultRunLoopMode;
    [self.pictureImageView downloadImageWithOriginalImageName:item.image1 thumbnailImageName:item.image0 placeholderImage:nil completed:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image == nil) return; // 下载失败
//        NSLog(@"%f-%f", image.size.width, image.size.height);
        if (!item.isBigPicture) return; // 非大图
        
        CGFloat imageW = item.middleFrame.size.width;
        CGFloat imageH = item.middleFrame.size.height;
//        UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), YES, 2);
        [image drawInRect:CGRectMake(0, 0, imageW, imageW / item.width * item.height)];
        
        self.pictureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"%f-%fbig", UIGraphicsGetImageFromCurrentImageContext().size.width, UIGraphicsGetImageFromCurrentImageContext().size.height);
        UIGraphicsEndImageContext();
    }];
    
    self.gifView.hidden = !item.is_gif;
    
    self.seeBigPictureButton.hidden = !item.isBigPicture;
}

@end
