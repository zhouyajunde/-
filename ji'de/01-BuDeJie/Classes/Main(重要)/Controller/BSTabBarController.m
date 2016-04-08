//
//  BSTabBarController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/17.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTabBarController.h"

#import "BSEssenceViewController.h"
#import "BSNewController.h"
#import "BSPublishViewController.h"
#import "BSFriendTrendViewController.h"
#import "BSMeViewController.h"

#import "BSNavigationController.h"



#import "BSTabBar.h"

#define BSColor(r,g,b) [UIColor colorWithRed: (r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1];

#define BSTabButtonTitleFont [UIFont systemFontOfSize:12]

@interface BSTabBarController ()

@end

@implementation BSTabBarController

+ (void)load
{
   
    // 获取整个app中tabBarItem
    
    // appearanceWhenContainedIn:获取某个类下的UITabBarItem
   UITabBarItem *item =  [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 1.UITabBarItem 可以使用appearance,只要遵守<UIAppearance>
    
    // 2.不是任何属性都可以使用appearance,只有标识了UI_APPEARANCE_SELECTOR这个宏的属性,才可以使用appearance修改
//    item.title = @"我";
    
    // 3.通过appearance设置,是有条件,必须在控件显示之前设置
    
    
    // 选中
    // 设置选中标题文字颜色
    // 富文本字符串:颜色,字体,空心,阴影,图文混排
    // NSDictionary:描述字符串属性
    NSMutableDictionary *attrSel = [NSMutableDictionary dictionary];
    // 颜色
    attrSel[NSFontAttributeName] = BSTabButtonTitleFont;
    attrSel[NSForegroundColorAttributeName] = BSColor(64, 64, 64);
    [item setTitleTextAttributes:attrSel forState:UIControlStateSelected];
    
    // 设置tabBarButtin字体大小: 必须设置正常状态下,如果不设置,就会不好使.
    NSMutableDictionary *attrNor = [NSMutableDictionary dictionary];
    // 颜色
    attrNor[NSFontAttributeName] = BSTabButtonTitleFont;
    attrNor[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:attrNor forState:UIControlStateNormal];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 1 添加子控制器(导航控制器):必须要有跟控制器
    [self setUpAllChildViewController];
    
    // 2 设置所有子控制器对应按钮的内容
    [self setUpAllTabButton];
    
    // 3.创建tabBar
    BSTabBar *tabBar = [[BSTabBar alloc] init];
    
#warning 为什么不需要设置tabBar的尺寸,UITabBarController会自动计算self.tabBar的尺寸
    
    // readonly:不会生成set方法,生成get方法还要下划线的成员属性
//    self.tabBar = tabBar;
    [self setValue:tabBar forKeyPath:@"tabBar"];

}


//- (void)setUpOneChildViewController:(UIViewController *)vc
//{
//    BSNavigationController *navVc = [[BSNavigationController alloc] initWithRootViewController:vc];
//    // initWithRootViewController:传入的控制器给push
//    [self addChildViewController:navVc];
//
//}

// 重写addChildViewController,把传入的控制器,包装成导航控制器
- (void)addChildViewController:(UIViewController *)childController
{
     BSNavigationController *navVc = [[BSNavigationController alloc] initWithRootViewController:childController];
    
    [super addChildViewController:navVc];
}

// 添加所有子控制器
- (void)setUpAllChildViewController
{
    // 添加5个子控制器
    // 精华
    BSEssenceViewController *essence = [[BSEssenceViewController alloc] init];
    [self addChildViewController:essence];
    
    // 新帖
    BSNewController *new = [[BSNewController alloc] init];
    [self addChildViewController:new];

  
    
    // 关注
    BSFriendTrendViewController *freind = [[BSFriendTrendViewController alloc] init];
    [self addChildViewController:freind];
 
    
    // 我
    // 1.加载storyboard
    UIStoryboard *stroryboard = [UIStoryboard storyboardWithName:NSStringFromClass([BSMeViewController class]) bundle:nil];
    
    BSMeViewController *me = [stroryboard instantiateInitialViewController];
    
    [self addChildViewController:me];

}

/*
    设置UITabBar上按钮选中标题 -> UITabBar上按钮 由对应子控制器的tabBarItem
 */

// 设置所有子控制器对应按钮的内容
- (void)setUpAllTabButton
{
    // 精华 -> 第0个按钮 -> 对应子控制器 -> self.childViewControllers[0]
    UIViewController *vc0 = self.childViewControllers[0];
    vc0.tabBarItem.title = @"精华";
    vc0.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    vc0.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_essence_click_icon"];
    
    // 新帖
    UIViewController *vc1 = self.childViewControllers[1];
    vc1.tabBarItem.title = @"新帖";
    vc1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    vc1.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_new_click_icon"];
    
    
    // 关注
    UIViewController *vc2 = self.childViewControllers[2];
    vc2.tabBarItem.title = @"关注";
    vc2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    vc2.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_friendTrends_click_icon"];
    
    // 我
    UIViewController *vc3 = self.childViewControllers[3];
    vc3.tabBarItem.title = @"我";
    vc3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    vc3.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_me_click_icon"];
}


@end
