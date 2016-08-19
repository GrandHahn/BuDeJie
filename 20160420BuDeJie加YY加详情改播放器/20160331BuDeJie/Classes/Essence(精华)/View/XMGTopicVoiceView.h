//
//  XMGTopicVoiceView.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/15.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopicItem;

@class XMGTopicVoiceView;
@protocol XMGTopicVoiceViewDelegate <NSObject>

- (void)topicVoiceViewDidClickVoice:(XMGTopicVoiceView *)topicVoiceView;

@end

@interface XMGTopicVoiceView : UIView
@property (nonatomic, strong) XMGTopicItem *item;


@property (nonatomic, weak) id<XMGTopicVoiceViewDelegate> delegate;
@end
