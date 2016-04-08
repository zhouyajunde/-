//
//  BSEssenceViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/17.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSTitleButton.h"
#import "BSAllViewController.h"
#import "BSVideoViewController.h"
#import "BSVoiceViewController.h"
#import "BSPictureViewController.h"
#import "BSWordViewController.h"
#import "BSSubTagViewController.h"

@interface BSEssenceViewController () <UIScrollViewDelegate>
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 用来显示所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 下划线 */
@property (nonatomic, weak) UIView *underlineView;
/** 当前被点中的按钮 */
@property (nonatomic, weak) BSTitleButton *clickedTitleButton;
@end

@implementation BSEssenceViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制器的尺寸根屏幕一样大
    self.view.backgroundColor = BSCommonBgColor;
    
    // 添加子控制器
    [self setUpChildVcs];
    
    // 设置导航条内容:由栈Top控制器
    [self setUpNavBar];
    
    // 添加scrollView
    [self setUpScrollView];
    
    // 添加标题栏
    [self setUpTitlesView];
    
    // 添加子控制器的view到scrollView中
    [self addChildVcViewIntoScrollView];
}

// 设置导航条
- (void)setUpNavBar
{
    // left
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}


// 点击标签按钮,进入标签界面
- (void)tagClick
{
    // 进入到推荐标签界面
    BSSubTagViewController *subTagVc = [[BSSubTagViewController alloc] init];
    
    [self.navigationController pushViewController:subTagVc animated:YES];
    
}

/**
 * 添加子控制器
 */
- (void)setUpChildVcs
{
    [self addChildViewController:[[BSVoiceViewController alloc] init]];
    [self addChildViewController:[[BSVideoViewController alloc] init]];
    [self addChildViewController:[[BSWordViewController alloc] init]];
    [self addChildViewController:[[BSAllViewController alloc] init]];
    [self addChildViewController:[[BSPictureViewController alloc] init]];
}

/**
 * 添加scrollView
 */
- (void)setUpScrollView
{
    // 不要自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 子控制器的个数
    NSUInteger count = self.childViewControllers.count;
    
    // 设置内容大小
    scrollView.contentSize = CGSizeMake(count * scrollView.width, 0);
}

/**
 * 添加标题栏
 */
- (void)setUpTitlesView
{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, BSNavMaxY, self.view.width, BSTitlesViewH);
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加所有的标题按钮
    [self setUpTitleButtons];
    
    // 添加底部的下划线
    [self setUpUnderline];
}

/**
 * 添加所有的标题按钮
 */
- (void)setUpTitleButtons
{
    // 按钮文字
    NSArray *titles = @[@"声音", @"视频", @"段子", @"全部", @"图片"];
    NSUInteger count = titles.count;
    
    // 按钮尺寸
    CGFloat titleButtonW = self.titlesView.width / count;
    CGFloat titleButtonH = self.titlesView.height;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 创建添加
        BSTitleButton *titleButton = [BSTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        
        // 设置属性
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
}

/**
 * 添加底部的下划线
 */
- (void)setUpUnderline
{
    // 取出第一个标题按钮
    BSTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    // 标题栏
    UIView *underlineView = [[UIView alloc] init];
    underlineView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    underlineView.height = 2;
    underlineView.y = self.titlesView.height - underlineView.height;
    [self.titlesView addSubview:underlineView];
    
    // 默认选中第一个按钮
    // 切换按钮状态
    firstTitleButton.selected = YES; // 新点击的按钮
    self.clickedTitleButton = firstTitleButton;
    // 下划线的宽度 == 按钮文字的宽度
    [firstTitleButton.titleLabel sizeToFit]; // 通过这句代码计算按钮内部label的宽度
    underlineView.width = firstTitleButton.titleLabel.width + BSMargin;
    // 下划线的位置
    underlineView.centerX = firstTitleButton.centerX;
    
    self.underlineView = underlineView;
}

#pragma mark - 监听
/**
 * 标题栏按钮点击
 */
- (void)titleClick:(BSTitleButton *)titleButton
{
    // 切换按钮状态
    self.clickedTitleButton.selected = NO; // 以前的按钮
    titleButton.selected = YES; // 新点击的按钮
    self.clickedTitleButton = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 移动下划线
        // 下划线的宽度 == 按钮文字的宽度
        self.underlineView.width = titleButton.titleLabel.width + BSMargin;
        // 下划线的位置
        self.underlineView.centerX = titleButton.centerX;
        
        // 让scrollView滚动到对应位置
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = titleButton.tag * self.scrollView.width; // 只修改x值,不要去修改y值
        self.scrollView.contentOffset = offset;
    } completion:^(BOOL finished) {
        // 添加子控制器的view到UIScrollView
        [self addChildVcViewIntoScrollView];
    }];
}

- (void)btnClick
{
    BSFunc;
}

#pragma mark - 其他
/**
 * 添加子控制器的view到UIScrollView
 */
- (void)addChildVcViewIntoScrollView
{
    // 取出对应位置的子控制器
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UIViewController *childVc = self.childViewControllers[index];
    
    // 设置子控制器view的frame
    childVc.view.frame = self.scrollView.bounds;
    // 添加子控制器view到scrollView
    [self.scrollView addSubview:childVc.view];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView滚动完毕\静止的时候调用这个代理方法
 * 前提:用户拖拽scrollView, 手松开以后继续滚动
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获得对应的按钮
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    BSTitleButton *titleButton = self.titlesView.subviews[index];
//    BSTitleButton *titleButton = [self.titlesView viewWithTag:index];
    
    // 点击按钮
    [self titleClick:titleButton];
}
@end
