//
//  XMGTopicCell.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//

/*
 @property (nonatomic, strong) NSString *text;
 @property (nonatomic, strong) NSString *passtime;
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, strong) NSString *profile_image;
 @property (nonatomic, assign) NSInteger ding;
 @property (nonatomic, assign) NSInteger cai;
 @property (nonatomic, assign) NSInteger repost;
 @property (nonatomic, assign) NSInteger commet;
 */

#import "XMGTopicCell.h"
#import "XMGTopicItem.h"
#import <UIImageView+WebCache.h>

#import "XMGTopicVoiceView.h"
#import "XMGTopicVideoView.h"
#import "XMGTopicPictureView.h"

@interface XMGTopicCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *text_Label;
@property (nonatomic, weak) IBOutlet UILabel *passtimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UIButton *dingButton;
@property (nonatomic, weak) IBOutlet UIButton *caiButton;
@property (nonatomic, weak) IBOutlet UIButton *repostButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;

@property (nonatomic, weak) IBOutlet UIView *topCmtView;
@property (nonatomic, weak) IBOutlet UILabel *topCmtLabel;

//@property (nonatomic, weak) XMGTopicVoiceView *topicVoiceView;
//@property (nonatomic, weak) XMGTopicVideoView *topicVideoView;
@property (nonatomic, weak) XMGTopicPictureView *topicPictureView;


@end

@implementation XMGTopicCell
- (IBAction)moreButtonClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController addAction:action2];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)dingButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
}
- (IBAction)caiButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)repostButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(topicCellDidClickRepost:)]) {
        [self.delegate topicCellDidClickRepost:self];
    }
}
- (IBAction)commentButtonClick:(id)sender {
    UIViewController *vc = [self nearestVc];
#warning 如果当前处在详情页，则不响应
    if ([vc isKindOfClass:NSClassFromString(@"XMGCommentController")]) return;
    
    if ([self.delegate respondsToSelector:@selector(topicCellDidClickComment:)]) {
        [self.delegate topicCellDidClickComment:self];
    }
}
// 取得最近的控制器
- (UIViewController *)nearestVc
{
    for (UIView *view = self.superview; view.superview != nil; view = view.superview)
    {
        UIResponder *res = view.nextResponder;
        if ([res isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)res;
        }
    }
    return nil;
}

#pragma mark - 懒加载
- (XMGTopicVoiceView *)topicVoiceView {
    if (!_topicVoiceView) {
        XMGTopicVoiceView *topicVoiceView = [[NSBundle mainBundle] loadNibNamed:@"XMGTopicVoiceView" owner:nil options:nil].firstObject;
#warning 此处因为xib里的view类型不对，所以不是self.contentView addSubview:,可能有bug，待修改
        [self addSubview:topicVoiceView];
        _topicVoiceView = topicVoiceView;
    }
    return _topicVoiceView;
}
- (XMGTopicVideoView *)topicVideoView {
    if (!_topicVideoView) {
        XMGTopicVideoView *topicVideoView = [[NSBundle mainBundle] loadNibNamed:@"XMGTopicVideoView" owner:nil options:nil].firstObject;
        [self addSubview:topicVideoView];
        _topicVideoView = topicVideoView;
    }
    return _topicVideoView;
}
- (XMGTopicPictureView *)topicPictureView {
    if (!_topicPictureView) {
        XMGTopicPictureView *topicPictureView = [[NSBundle mainBundle] loadNibNamed:@"XMGTopicPictureView" owner:nil options:nil].firstObject;
        [self addSubview:topicPictureView];
        _topicPictureView = topicPictureView;
    }
    return _topicPictureView;
}

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setItem:(XMGTopicItem *)item {
#warning 注意要赋值！！否则下面layoutsubviews时item没数据
    _item = item;
    self.nameLabel.text = item.name;
    self.text_Label.text = item.text;
    self.passtimeLabel.text = item.passtime;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:item.profile_image]];
    
    [self.dingButton setTitle:item.ding forState:UIControlStateNormal];
    [self.caiButton setTitle:item.cai forState:UIControlStateNormal];
    [self.repostButton setTitle:item.repost forState:UIControlStateNormal];
    [self.commentButton setTitle:item.comment forState:UIControlStateNormal];
    
    // 添加中间的view
    if (item.type == XMGTopicTypeVoice) {
        // 创建声音view
        self.topicVoiceView.hidden = NO;
        self.topicVoiceView.item = item;
        self.topicVideoView.hidden = YES;
        self.topicPictureView.hidden = YES;
    } else if (item.type == XMGTopicTypePicture) {
        // 图片view
        self.topicVoiceView.hidden = YES;
        self.topicVideoView.hidden = YES;
        self.topicPictureView.hidden = NO;
        self.topicPictureView.item = item;
    } else if (item.type == XMGTopicTypeVideo) {
        // 视频view
        self.topicVoiceView.hidden = YES;
        self.topicVideoView.hidden = NO;
        self.topicVideoView.item = item;
        self.topicPictureView.hidden = YES;
    } else {
        // 段子
        self.topicVoiceView.hidden = YES;
        self.topicVideoView.hidden = YES;
        self.topicPictureView.hidden = YES;
    }
    
    // 有热评
    if (item.top_cmt.count) {
        self.topCmtView.hidden = NO;
        
        NSDictionary *dict = item.top_cmt[0];
        NSString *username = dict[@"user"][@"username"];
        NSString *content = item.top_cmt[0][@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else {
        self.topCmtView.hidden = YES;
    }
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.item.type == XMGTopicTypeVoice) {
        self.topicVoiceView.frame = self.item.middleFrame;
    } else if (self.item.type == XMGTopicTypePicture) {
        self.topicPictureView.frame = self.item.middleFrame;
    } else if (self.item.type == XMGTopicTypeVideo) {
        self.topicVideoView.frame = self.item.middleFrame;
    } else {
        
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
