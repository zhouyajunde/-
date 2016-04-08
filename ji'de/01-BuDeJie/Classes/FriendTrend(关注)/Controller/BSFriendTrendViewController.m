//
//  BSFriendTrendViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/17.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSFriendTrendViewController.h"

#import "BSLoginRegiserViewController.h"

#import "UITextField+Placeholder.h"

@interface BSFriendTrendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BSFriendTrendViewController

// 点击按钮就会调用,进入立即登录注册界面
- (IBAction)loginRegiser:(id)sender {
//    BSFunc;
    BSLoginRegiserViewController *vc = [[BSLoginRegiserViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}
// OC中大部分控件里面的子控件都是懒加载,cell
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置占位文字颜色
    _textField.placeholderColor = [UIColor redColor];
    // 1.保存占位文字颜色
    // 设置失败,应该保存占位颜色
    
    // 设置占位文字
    [_textField setPlaceholder:@"asdsadsad"];
    
    [self setUpNavBar];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(100, 100, 100, 100);
    [imageView bs_setHeader:@"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=3657724459,3412427536&fm=58"];
    [self.view addSubview:imageView];
}

// 设置导航条
- (void)setUpNavBar
{
    // UINavigationItem:描述导航条内容
    // UIBarButtonItem:描述导航条按钮内容
    // left
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // titleView
    self.navigationItem.title = @"我的关注";
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
