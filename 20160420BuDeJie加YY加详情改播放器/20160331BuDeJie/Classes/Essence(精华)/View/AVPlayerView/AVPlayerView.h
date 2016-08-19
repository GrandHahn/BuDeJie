//
//  AVPlayerView.h
//  testForAVPlayer
//
//  Created by Hahn on 16/8/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPlayerView : UIView
@property (nonatomic, strong) NSString *urlStr;
+ (instancetype)playerView;
- (void)pause;
- (void)play;
/** 不使用了或离开屏幕，要记得调用此方法，否则无法释放 */
- (void)stopAndReleaseAll;

/** 清除背景色，给XMGTopicVoiceView使用 */
- (void)setPlayerViewAndVideoViewClearColor;
@end
