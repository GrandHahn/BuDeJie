//
//  AVPlayerView.m
//  testForAVPlayer
//
//  Created by Hahn on 16/8/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

/**
 播放器全屏放大效果总结：
 1.不要在storyboard中用加约束来创建，要通过xib加载，设置frame来添加
 2.注意bounds，width，tranform的修改顺序，情况不一样，顺序也不一样，可借用animateWithDuration来推测
 3.修改AVPlayerLayer的尺寸时要与其他尺寸操作有时间间隔，原因不详（可能跟AVPlayerLayer的尺寸动画效果有关），可通过animateWithDuration来验证推测
 4.同时修改CGAffineTransformMakeScale和CGAffineTransformMakeRotation容易出问题
 例子：
     self.center = CGPointMake(w/2, h/2);
     [UIView animateWithDuration:0.01 animations:^{
         self.bounds = CGRectMake(0, 0, h, w);
     } completion:^(BOOL finished) {
         self.playerLayer.frame = self.playView.bounds;
         [UIView animateWithDuration:0.01 animations:^{
             self.transform = CGAffineTransformMakeRotation(M_PI_2);
         }];
     }];
 */

#import "AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerView ()
/** 播放view */
@property (weak, nonatomic) IBOutlet UIView *videoView;
/** 播放器 */
@property (strong, nonatomic) AVPlayer *player;
/** 播放图层 */
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

/** 播放器控制器 */
@property (weak, nonatomic) IBOutlet UIView *controlView;

/** 定时器 注：一定要用weak，否则有内存问题 */
@property (nonatomic, weak) NSTimer *timer;
/** 当前播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currenTimeLabel;
/** 总播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 滑动进度条 */
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;
/** 菊花 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
/** 上一个当前播放时间，用于对比来判断是否显示菊花 */
@property (nonatomic, assign) CMTimeValue preCurrentTimeValue;

/** 是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 全屏标志 */
@property (nonatomic, assign) BOOL isFullScreen;


/** 全屏时记录以前的bounds */
@property (nonatomic, assign) CGRect preBounds;
/** 全屏时记录以前的center */
@property (nonatomic, assign) CGPoint preCenter;

@property (nonatomic, weak) UIView *preSuperview;


@property (nonatomic, weak) UIButton *tempPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@end

@implementation AVPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPlayerViewAndVideoViewClearColor {
    self.backgroundColor = [UIColor clearColor];
    self.videoView.backgroundColor = [UIColor clearColor];
    self.fullScreenBtn.hidden = YES;
}

- (void)dealloc {
    NSLog(@"playerView-----dealloc");
}
+ (instancetype)playerView {
    return [[NSBundle mainBundle] loadNibNamed:@"AVPlayerView" owner:nil options:nil][0];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 方法1
    self.player = [[AVPlayer alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://p2.ycw.com/201606/24/a7d19fb4a2f4d1bee09f7977ac43efde.mp4"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    // 方法2
//    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://p2.ycw.com/201606/24/a7d19fb4a2f4d1bee09f7977ac43efde.mp4"]];
    
    //    http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8
    //    http://p2.ycw.com/201606/24/a7d19fb4a2f4d1bee09f7977ac43efde.mp4
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.videoView.layer addSublayer:self.playerLayer];
    
    [self.videoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    
    /**
     问题：改为全屏添加到window上时，点击xib中的播放按钮有问题
     原因：可能跟xib中的约束有关
     暂时解决方案：手动创建一个button覆盖原来的按钮
     */
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [btn setTitle:@"暂停" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView addSubview:btn];
    self.tempPlayBtn = btn;
}

- (void)pause {
    self.isPlaying = NO;
    [self.player pause];
    self.tempPlayBtn.selected = NO;
    [self removeTimerForOneSecond];
}

- (void)play {
    self.isPlaying = YES;
    [self.player play];
    self.tempPlayBtn.selected = YES;
    [self addTimerForOneSecond];
}

- (void)stopAndReleaseAll {
    [self.player pause];
    
//    NSURL *url = [NSURL URLWithString:nil];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    self.player = nil;
    self.playerLayer = nil;
    self.preSuperview = nil;
    
    [self removeTimerForOneSecond];
}
- (void)testBtn:(UIButton *)sender {
    self.isPlaying = !self.isPlaying;
    self.isPlaying ? [self.player play] : [self.player pause];
    if (self.isPlaying) {
        sender.selected = YES;
        [self addTimerForOneSecond];
    } else {
        sender.selected = NO;
        [self removeTimerForOneSecond];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.25 animations:^{
        self.controlView.alpha = !self.controlView.alpha;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 自行决定何时加尺寸
    self.playerLayer.frame = self.videoView.bounds;
    
    CGFloat h = self.controlView.bounds.size.height;
    self.tempPlayBtn.frame = CGRectMake(0, 0, h, h);
}
- (IBAction)playBtnClick:(UIButton *)sender {
    // 自行决定何时加尺寸
//    self.playerLayer.frame = self.playView.bounds;
    
//    self.isPlaying = !self.isPlaying;
//    self.isPlaying ? [self.player play] : [self.player pause];
//    if (self.isPlaying) {
//        sender.selected = YES;
//        [self addTimerForOneSecond];
//    } else {
//        sender.selected = NO;
//        [self removeTimerForOneSecond];
//    }
    
}

- (IBAction)fullScreen:(id)sender {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    if (self.isFullScreen) {
//        [UIView animateWithDuration:0.2 animations:^{
//            
//            self.transform = CGAffineTransformMakeRotation(0);
////            self.bounds = CGRectMake(0, 0, h/3, w/3);
////            self.center = CGPointMake(w/2-50, h/2+100);
//            self.bounds = self.preBounds;
//            self.center = self.preCenter;
//            // 此处不延时会有问题
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.playerLayer.frame = self.videoView.bounds;
//            });
//            self.isFullScreen = NO;
//        }];
        
        [self.preSuperview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{

            self.transform = CGAffineTransformMakeRotation(0);
//            self.bounds = CGRectMake(0, 0, h/3, w/3);
//            self.center = CGPointMake(w/2-50, h/2+100);
            self.bounds = self.preBounds;
            self.center = self.preCenter;
            // 此处不延时会有问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.playerLayer.frame = self.videoView.bounds;
            });
            self.isFullScreen = NO;
        }];

    } else {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.preBounds = self.bounds;
//            self.preCenter = self.center;
//            self.bounds = CGRectMake(0, 0, h, w);
//            self.center = CGPointMake(w/2, h/2);
//            self.transform = CGAffineTransformMakeRotation(M_PI_2);
//            // 此处不延时会有问题
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.playerLayer.frame = self.videoView.bounds;
//            });
//            self.isFullScreen = YES;
//        }];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            self.preSuperview = self.superview;
            self.preBounds = self.bounds;
            self.preCenter = self.center;
            self.bounds = CGRectMake(0, 0, h, w);
            self.center = CGPointMake(w/2, h/2);
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            // 此处不延时会有问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.playerLayer.frame = self.videoView.bounds;
//                self.playerLayer.frame = self.bounds;
            });
            self.isFullScreen = YES;
        } completion:^(BOOL finished) {
            [self.window addSubview:self];
        }];
    }
}

#pragma mark - 定时器相关
// 添加定时器
- (void)addTimerForOneSecond {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerOneSecond) userInfo:nil repeats:YES];
}
// 移除定时器
- (void)removeTimerForOneSecond {
    [self.timer invalidate];
    self.timer = nil;
}
// 定时器调用方法
- (void)timerOneSecond {
    /*
    NSLog(@"up-%zd-%zd-%zd-%zd-%zd",
          self.player.currentTime.value,
          self.player.currentTime.timescale,
          self.player.currentTime.flags,
          self.player.currentTime.epoch,
          self.player.currentTime.value / self.player.currentTime.timescale
          );
    
    NSLog(@"down-%zd-%zd-%zd-%zd",
          self.player.currentItem.currentTime.value,
          self.player.currentItem.currentTime.timescale,
          self.player.currentItem.duration.value,
          self.player.currentItem.duration.timescale
          );
    */
    int64_t currentTimeValue = self.player.currentItem.currentTime.value;
    int32_t currentTimeTimescale = self.player.currentItem.currentTime.timescale;
    int64_t durationValue = self.player.currentItem.duration.value;
    int32_t durationTimescale = self.player.currentItem.duration.timescale;
    CGFloat currentTimeSec = 0.0;
    CGFloat totalTimeSec = 0.0;
    if (durationTimescale != 0) {
        // 秒数 等于 value 除以 timescale
        currentTimeSec = currentTimeValue / currentTimeTimescale;
        totalTimeSec = durationValue / durationTimescale;
        /*
        NSLog(@"%zd", (int)currentTimeValue);
        NSLog(@"%zd", (int)currentTimeTimescale);
        NSLog(@"%zd", (int)currentTimeSec);
        NSLog(@"%zd", (int)totalTimeSec);
         */
    }
    
    
    self.musicSlider.value = currentTimeSec / totalTimeSec;
    
    self.currenTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)currentTimeSec / 60, (int)currentTimeSec % 60];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)totalTimeSec / 60, (int)totalTimeSec % 60];
    
    self.activityIndicator.hidden = self.preCurrentTimeValue == self.player.currentItem.currentTime.value ? NO : YES;
    self.preCurrentTimeValue = self.player.currentItem.currentTime.value;
}

#pragma mark - slider监听
// 按下slider
- (IBAction)sliderTouchDown:(UISlider *)sender {
    [self.player pause];
    
    [self removeTimerForOneSecond];
}
// 拖动slider
- (IBAction)sliderValueChanged:(UISlider *)sender {
    int64_t currentTimeValue = self.player.currentItem.duration.value * sender.value;
    int32_t currentTimeTimescale = self.player.currentItem.duration.timescale;
    CGFloat currentTimeSec = 0.0;
    if (currentTimeTimescale == 0) return;
    currentTimeSec = currentTimeValue / currentTimeTimescale;
    self.currenTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)currentTimeSec / 60, (int)currentTimeSec % 60];
    
}
// 松开slider
- (IBAction)sliderTouchUpInsideOrOutside:(UISlider *)sender {
    [self addTimerForOneSecond];
    
    int64_t value = self.player.currentItem.duration.value * sender.value;
    int32_t timescale = self.player.currentItem.duration.timescale;
    if (timescale == 0) return;
    
    
    CMTime time = CMTimeMake(value, timescale);
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        NSLog(@"finished");
        self.isPlaying ? [self.player play] : [self.player pause];
    }];
}
@end
