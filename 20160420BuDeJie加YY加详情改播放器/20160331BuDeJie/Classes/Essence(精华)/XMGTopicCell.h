//
//  XMGTopicCell.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGTopicItem;
@class XMGTopicCell;
@class XMGTopicVideoView;
@class XMGTopicVoiceView;
@protocol XMGTopicCellDelegate <NSObject>

- (void)topicCellDidClickRepost:(XMGTopicCell *)topicCell;
- (void)topicCellDidClickComment:(XMGTopicCell *)topicCell;
@end

@interface XMGTopicCell : UITableViewCell

@property (nonatomic, strong) XMGTopicItem *item;

@property (nonatomic, weak) id<XMGTopicCellDelegate> delegate;

@property (nonatomic, weak) XMGTopicVideoView *topicVideoView;
@property (nonatomic, weak) XMGTopicVoiceView *topicVoiceView;

@end
