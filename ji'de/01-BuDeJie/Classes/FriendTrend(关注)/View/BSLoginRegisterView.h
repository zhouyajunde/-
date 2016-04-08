//
//  BSLoginRegisterView.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSLoginRegisterView : UIView

/*
    搭建注册界面,
    1.提供一个属性,判断下当前是什么界面,如果是注册界面,隐藏忘记密码,改变输入的文本框
 */
+ (instancetype)loginView;

+ (instancetype)registerView;

//@property (nonatomic, assign) BOOL isLoginView;

@end
