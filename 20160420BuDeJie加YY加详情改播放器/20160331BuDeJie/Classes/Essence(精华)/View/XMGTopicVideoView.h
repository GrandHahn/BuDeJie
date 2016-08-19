//
//  XMGTopicVideoView.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopicItem;
@class XMGTopicVideoView;
@protocol XMGTopicVideoViewDelegate <NSObject>

- (void)topicVideoViewDidClickVideo:(XMGTopicVideoView *)topicVideoView;

@end
@interface XMGTopicVideoView : UIView
@property (nonatomic, strong) XMGTopicItem *item;

@property (nonatomic, weak) id<XMGTopicVideoViewDelegate> delegate;

- (CGRect)videoImageViewFrame;

@end
