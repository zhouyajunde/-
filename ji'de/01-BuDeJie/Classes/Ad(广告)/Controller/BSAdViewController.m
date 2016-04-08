//
//  BSAdViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSAdViewController.h"

#import <AFNetworking/AFNetworking.h>

#import <MJExtension/MJExtension.h>

#import <UIImageView+WebCache.h>

#import "BSAdItem.h"

#import "BSTabBarController.h"

#define BSCode @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface BSAdViewController ()

/** 广告模型 */
@property (nonatomic ,strong) BSAdItem *adItem;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) UIImageView *adView;
@property (weak, nonatomic) IBOutlet UIButton *adButton;


@property (nonatomic ,weak) NSTimer *timer;

@property (nonatomic ,weak) AFHTTPSessionManager *mgr;

@end

@implementation BSAdViewController

/*
 
 ori_curl
 w
 h
 w_picurl
 
 完整URL = 基本URL?请求参数
 基本URL  http://mobads.baidu.com/cpro/ui/mads.php
 
 
 // json解析网页
 http://tool.oschina.net/codeformat/json
 */


// 懒加载广告view
- (UIImageView *)adView
{
    if (_adView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        // 允许用户交互
        imageV.userInteractionEnabled = YES;
        _adView = imageV;
        [self.view insertSubview:imageV belowSubview:self.adButton];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump)];
        [_adView addGestureRecognizer:tap];
        
    }
    
    return _adView;
}

// 点击跳过按钮销毁当前界面
- (IBAction)clickAdButton:(id)sender {
    // 销毁定时器
    [_timer invalidate];
    
    // 创建主框架界面
    BSTabBarController *tabBarVc = [[BSTabBarController alloc] init];
    
    // 销毁当前界面,进入主框架界面,modal,push,直接修改窗口的根控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    
}

// 点击广告界面使用safari打开网页
- (void)jump
{
    NSURL *url = [NSURL URLWithString:_adItem.ori_curl];
    
    // 判断下是否能打开
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        // 使用safari打开网页
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 1.设置背景图片屏幕适配
    [self setUpBgView];
    
    // 2.加载广告数据,服务器数据 -> 跟服务器打交道 -> 接口文档
    [self loadData];

    // 3.定时器
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

// 每隔一秒就会调用
- (void)timeChange
{
    static int time = 3;
    
    if (time == -1) {
        // 点击跳过的事情
        [self clickAdButton:nil];
        
//        // 销毁定时器
//        [_timer invalidate];
//        
//        // 创建主框架界面
//        BSTabBarController *tabBarVc = [[BSTabBarController alloc] init];
//        
//        // 销毁当前界面,进入主框架界面,modal,push,直接修改窗口的根控制器
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
//        [self presentViewController:tabBarVc animated:NO completion:nil];
        
        return;
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"跳过(%d)",time];
    
    [_adButton setTitle:timeStr forState:UIControlStateNormal];
    
    // 更新按钮文字
    time--;
}


// 请求广告数据
- (void)loadData
{
    // AFN -> cocodpods:管理第三方框架 -> podfile:加载指定的框架
    
    // 1.创建会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    self.mgr = mgr;
    // 2.创建请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = BSCode;
    
    // 3.发送请求Get
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        // 请求成功就会调用
        
        //        [responseObject writeToFile:@"/Users/a1/Desktop/课堂共享/10-项目/1218-项目/03-广告/ad.plist" atomically:YES];
        
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        
        // 字典转模型
        _adItem = [BSAdItem mj_objectWithKeyValues:adDict];
        
        // NaN: / 0
        
        // 确定广告界面尺寸,广告界面图片,点击广告界面跳转到的界面
        CGFloat w = BSScreenW;
        
        CGFloat h = BSScreenH;
        if (_adItem.h) {
            h = BSScreenW / _adItem.w * _adItem.h;
            if (h > BSScreenH) {
                h = BSScreenH;
            }
        }
        self.adView.frame = CGRectMake(0, 0, w, h);
        
        // 加载图片
        [self.adView sd_setImageWithURL:[NSURL URLWithString:_adItem.w_picurl]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // http过程:
        // AFN不支持 text/html,让解析响应的时候支持.
        
        // unacceptable content-type: text/html
        
        NSLog(@"%@",error);
        // 请求失败就会调用
    }];

}

// 设置背景view
- (void)setUpBgView
{
    if (iPhone6P) {
        _bgView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iPhone6){
        _bgView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (iPhone5){
        _bgView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    }else if (iPhone4){
        _bgView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }

}

// 当前对象即将销毁会调用
- (void)dealloc
{
    
    // 取消请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //  主动干掉这个会话管理者
    [self.mgr invalidateSessionCancelingTasks:NO];
    
    
}

@end
