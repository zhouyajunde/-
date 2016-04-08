//
//  BSNavigationController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSNavigationController.h"

@interface BSNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BSNavigationController

/*
    1.设置导航条内容 -> 2.处理导航条细节(标题字体,背景图片) -> 3.导航控制器业务逻辑(导航控制器跳转功能)
 */

+ (void)load
{
    // 谁的事情谁管理,方便以后需求改变的时候,能快速定位到对应的类做事情.
    // message:发信息的人 显示不出来 iOS7,8
    
    // 获取全局导航条
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 设置导航条标题字体
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    // 字体
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    
    [navBar setTitleTextAttributes:attr];
    
    // 设置导航条背景图片
    // iOS9之前,如果使用了UIBarMetricsDefault,默认导航控制器的根控制器的尺寸,会少64的高度.
    // UIBarMetricsDefault:必须设置默认
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 不是根控制器才需要设置
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 覆盖掉了系统的返回按钮,滑动返回功能失效
        // 为什么失效? 1.排除手势就没有了 2.手势代理做了事情
        
        // 不是根控制器
        // 设置返回按钮
        // 设置返回按钮,左边按钮
        UIBarButtonItem *backItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) norColor:[UIColor blackColor] highColor:[UIColor redColor] title:@"返回"];
        
        viewController.navigationItem.leftBarButtonItem = backItem;
        
       
//        NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
    }
    
    // 这个方法才是真正跳转
    [super pushViewController:viewController animated:animated];
}

// 点击返回按钮,回到上一个界面
- (void)back
{
    // self -> 导航控制器
    [self popViewControllerAnimated:YES];
    
}
/*
    <UIScreenEdgePanGestureRecognizer: 0x7fe260640220; view = <UILayoutContainerView 0x7fe26062bba0>;
        target= <(action=handleNavigationTransition:,
        target=<_UINavigationInteractiveTransition 0x7fe26063f1a0>)>>
 
    1.UIScreenEdgePanGestureRecognizer加在导航控制器的view上
 
    2.target:_UINavigationInteractiveTransition
 
    3.action: handleNavigationTransition:
 
    触发UIScreenEdgePanGestureRecognizer就会调用target的handleNavigationTransition:方法
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIScreenEdgePanGestureRecognizer
    // Do any additional setup after loading the view.
    // 只要触发这个Pan手势,就会调用self对象pan方法
    // 1.创建全屏手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    // 控制手势什么时候触发
    pan.delegate = self;
    
    // 全屏滑动返回
    [self.view addGestureRecognizer:pan];
    
    // 2.禁止边缘手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 实现滑动返回功能
//     self.interactivePopGestureRecognizer.delegate = self;
    
    // bug:假死:程序一直运行,但是界面动不了.
    // 在根控制器的view,不需要滑动返回,
    
    // 全屏滑动返回
    // 研究下系统自带的返回手势
//    NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
}

#pragma mark - UIGestureRecognizerDelegate
// 控制手势是否触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    // 根控制器的时候
    return self.childViewControllers.count != 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
