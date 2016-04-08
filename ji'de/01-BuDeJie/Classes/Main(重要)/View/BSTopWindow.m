//
//  BSTopWindow.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/29.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTopWindow.h"

@implementation BSTopWindow

static UIWindow *topWindow_;

//static UIWindow *otherWindow_;

/**
 * 显示顶部窗口
 */
+ (void)show
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        topWindow_ = [[UIWindow alloc] init];
        topWindow_.windowLevel = UIWindowLevelAlert;
        topWindow_.frame = [UIApplication sharedApplication].statusBarFrame;
        topWindow_.backgroundColor = [UIColor clearColor];
        topWindow_.hidden = NO;
        [topWindow_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowClick)]];
        
        /*
         1.窗口级别越高，就越显示在顶部
         2.如果窗口级别一样，那么后面出来的窗口会显示在顶部
         UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
         */
//        otherWindow_ = [[UIWindow alloc] init];
//        otherWindow_.windowLevel = UIWindowLevelAlert;
//        otherWindow_.frame = CGRectMake(300, 500, 70, 70);
//        [otherWindow_ addSubview:[[UISwitch alloc] init]];
//        otherWindow_.backgroundColor = [UIColor clearColor];
//        otherWindow_.hidden = NO;
    });
}

/**
 * 监听顶部窗口点击
 */
+ (void)topWindowClick
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self searchAllScrollViewsInView:keyWindow];
}

/**
 * 找到参数view中所有的UIScrollView
 */
+ (void)searchAllScrollViewsInView:(UIView *)view
{
    // 递归遍历所有的子控件
    for (UIView *subview in view.subviews) {
        [self searchAllScrollViewsInView:subview];
    }
    
    // 判断子控件类型
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    // 找到了UIScrollView
    UIScrollView *scrollView = (UIScrollView *)view;
    
    // 让UIScrollView滚动到最前面
    // 让CGRectMake(0, 0, 1, 1)这个矩形框完全显示在scrollView的frame框中
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
//    CGPoint offset = scrollView.contentOffset;
//    offset.y = - scrollView.contentInset.top;
//    [scrollView setContentOffset:offset animated:YES];
}

@end
