//
//  XMGSquareCell.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGSquareCell.h"
#import "XMGSquareItem.h"
#import <UIImageView+WebCache.h>
@interface XMGSquareCell ()

@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *name;

@end

@implementation XMGSquareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setItem:(XMGSquareItem *)item {
    _item = item;
    
    self.name.text = item.name;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.icon]];
}

@end
