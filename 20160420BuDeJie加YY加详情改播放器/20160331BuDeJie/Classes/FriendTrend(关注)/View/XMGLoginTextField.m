//
//  XMGLoginTextField.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGLoginTextField.h"

@implementation XMGLoginTextField

- (void)awakeFromNib {
    // 光标颜色
    self.tintColor = [UIColor whiteColor];
    // 监听文本开始编辑：代理，target，通知
    // 不要成为自己的代理
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    [self textEnd];
}

- (void)textBegin {
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
    
    // 通过断点查看私有属性
    UILabel *placeHolderLabel = [self valueForKey:@"_placeholderLabel"];
    placeHolderLabel.textColor = [UIColor whiteColor];
    UITextFieldLabel *saf;
}
- (void)textEnd {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
}

@end
