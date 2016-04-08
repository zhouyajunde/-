//
//  BSLoginRegisterView.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSLoginRegisterView.h"

@interface BSLoginRegisterView ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation BSLoginRegisterView


//- (void)setIsLoginView:(BOOL)isLoginView
//{
//    _isLoginView = isLoginView;
//    
//    if (!_isLoginView) { // 注册界面
//        // 隐藏底部按钮
//        
//        // 改变两个文本框的占位文字
//        
//    }
//}

+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib
{
    
    // 拉伸图片
    // 获取按钮图片:currentBackgroundImage,获取普通状态下
    // 获取按钮图片:_loginButton backgroundImageForState:<#(UIControlState)#>
    
    // 正常
    UIImage *norImage = [_loginButton backgroundImageForState:UIControlStateNormal];
    [_loginButton setBackgroundImage:norImage.stretchableImage forState:UIControlStateNormal];
    
    // 高亮
    UIImage *highImage = [_loginButton backgroundImageForState:UIControlStateHighlighted];
    [_loginButton setBackgroundImage:highImage.stretchableImage forState:UIControlStateHighlighted];
    
}


@end
