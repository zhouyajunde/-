//
//  BSTabBar.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/17.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTabBar.h"



@interface BSTabBar ()

/** 加号按钮*/
@property (nonatomic ,weak) UIButton *plusButton;

@end

@implementation BSTabBar

- (UIButton *)plusButton
{
    if (_plusButton == nil) {
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [plusButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        // 自适应尺寸,根据图片或者文字计算
        [plusButton sizeToFit];
        
        _plusButton = plusButton;
        
        [self addSubview:plusButton];
    }
    return _plusButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 跳转子控件布局
    NSInteger count = self.items.count + 1;

    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    int i = 0;
    for (UIView *tabButton in self.subviews) {
        if ([tabButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (i == 2) {
                i += 1;
            }
            
            btnX = i * btnW;
            
            tabButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            i++;

        }
    }
    
    // 设置按钮居中
    self.plusButton.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    // 一个控件不显示原因:隐藏,没有尺寸,被挡住.
}

@end
