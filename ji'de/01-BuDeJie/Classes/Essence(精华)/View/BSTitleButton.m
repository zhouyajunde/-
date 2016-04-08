//
//  BSTitleButton.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTitleButton.h"

@implementation BSTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        
//        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        
        /*
         按钮的状态
         UIControlStateNormal       = 0,  普通状态
         UIControlStateHighlighted  = 1 << 0, 高亮状态(按住按钮不松开)
         UIControlStateDisabled     = 1 << 1, enabled = NO, 不能点击(enabled = YES就会恢复到UIControlStateNormal状态)
         UIControlStateSelected     = 1 << 2, selected = YES, 能点击(selected = NO就会恢复到UIControlStateNormal状态)
         
         enabled和userInteractionEnabled的区别
         1.enabled = NO : 按钮不能点击, 进入UIControlStateDisabled状态
         2.userInteractionEnabled = NO : 按钮不能点击, 不会进入UIControlStateDisabled状态, 还是停留在当前状态(比如UIControlStateNormal状态)
         */
        
//        UIControlStateNormal : darkGrayColor enabled = YES
//        UIControlStateDisabled : redColor  enabled = NO
        
//        UIControlStateNormal : darkGrayColor selected = NO
//        UIControlStateSelected : redColor selected = YES
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
