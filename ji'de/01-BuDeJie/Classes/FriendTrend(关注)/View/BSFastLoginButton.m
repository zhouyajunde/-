//
//  BSFastLoginButton.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSFastLoginButton.h"

@implementation BSFastLoginButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    // 会根据xib描述的,计算内部子控件的位置
    [super layoutSubviews];
  
    // 设置图片
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置文字
    // 从xib计算的标题尺寸不对,自己在计算一下
    // 自动计算控件尺寸,根据内容
    [self.titleLabel sizeToFit];
    self.titleLabel.y = self.height - self.titleLabel.height;
    self.titleLabel.centerX = self.width * 0.5;
}

@end
