//
//  BSLoginRegiserViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSLoginRegiserViewController.h"

#import "BSLoginRegisterView.h"

#import "BSFastLoginView.h"

@interface BSLoginRegiserViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leedingCons;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *fastLoginView;

@end

@implementation BSLoginRegiserViewController

/*
    比较复杂的界面:
    1.分析大致结构 顶部 中间输入view 下部快速登录
 */


// 点击关闭按钮调用
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击注册账号调用
- (IBAction)clickBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    // 修改x,修改约束
    _leedingCons.constant = _leedingCons.constant == 0? -BSScreenW: 0;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        // 为什么要拿到父控件去做约束布局
        [self.view layoutIfNeeded];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 添加登录view
    BSLoginRegisterView *loginView = [BSLoginRegisterView loginView];
  
    // 默认一个控件从xib加载,尺寸跟xib一样.
    [self.inputView addSubview:loginView];
    
    // 添加注册view
    BSLoginRegisterView *registerView = [BSLoginRegisterView registerView];
    [self.inputView addSubview:registerView];
    
    // 添加快速登录view
    BSFastLoginView *fastLoginView = [BSFastLoginView fastLoginView];
    [self.fastLoginView addSubview:fastLoginView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退下键盘
    [self.view endEditing:YES];
}

// 调整控制器view的子控件的位置
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 给登录子控件赋值
    BSLoginRegisterView *loginView = [self.inputView.subviews firstObject];
    
    // 最好设置frame
    loginView.frame = CGRectMake(0, 0, self.inputView.width * 0.5, self.inputView.height);
    
    // 如果添加的控件,也是从xib加载的,在这里设置尺寸.
    
    // 设置注册尺寸
     BSLoginRegisterView *registerView = [self.inputView.subviews lastObject];
    
    registerView.frame = CGRectMake( self.inputView.width * 0.5, 0, self.inputView.width * 0.5, self.inputView.height);
    
    // 设置注册界面尺寸
    BSFastLoginView *fastLoginView = [self.fastLoginView.subviews firstObject];
    fastLoginView.frame = self.fastLoginView.bounds;
}


@end
