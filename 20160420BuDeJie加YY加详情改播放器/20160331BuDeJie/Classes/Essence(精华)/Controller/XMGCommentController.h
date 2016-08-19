//
//  XMGCommentController.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/8/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMGTopicItem.h"
#import "XMGTopicCell.h"
@interface XMGCommentController : UITableViewController
@property (nonatomic, strong) XMGTopicItem *topicItem;
#warning - 处理cell的思路，步骤1
@property (nonatomic, strong) XMGTopicCell *topicCell;
//@property (nonatomic, strong) UIViewController *pushVC;
@end
