//
//  XMGCommentCell.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/8/14.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGCommentCell.h"
#import "XMGCommentItem.h"
#import "KILabel.h"
@interface XMGCommentCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet KILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UILabel *dingCountLabel;


@end

@implementation XMGCommentCell

- (void)setItem:(XMGCommentItem *)item {
    _item = item;
    [self.iconBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:item.profile_image] forState:UIControlStateNormal placeholder:nil];
    if ([item.sex isEqualToString:@"f"]) {
        self.sexImageView.image = [UIImage imageNamed:@"Action_Female"];
    } else {
        self.sexImageView.image = [UIImage imageNamed:@"Action_Male"];
    }
    self.usernameLabel.text = item.username;
    
//    self.commentLabel.text = item.content;
    NSString *contentStr = nil;
    if (item.precmt) { // 有被评论用户
        contentStr = [NSString stringWithFormat:@"%@//@%@:%@", item.content, item.precmt.username, item.precmt.content];
    } else { // 无被评论用户
        contentStr = item.content;
    }
    
    self.commentLabel.text = contentStr;
    self.dingCountLabel.text = item.like_count;
}
- (IBAction)dingBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
