//
//  BSMeViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/17.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSMeViewController.h"

#import "BSSquareCell.h"

#import <MJExtension/MJExtension.h>

#import "BSSquareItem.h"

#import "BSHtmlViewController.h"

#import <SafariServices/SafariServices.h>

/*
    1.tableView 分组样式 ,底部方块就是footView
    2.界面固定死的,静态单元格 -> storyboard
 */

#import "BSSettingViewController.h"

#import <AFNetworking/AFNetworking.h>

@interface BSMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 所有方块 */
@property (nonatomic ,strong) NSMutableArray *squareList;


@property (nonatomic ,weak) UICollectionView *collectionView;

@end

@implementation BSMeViewController

static NSString *const ID = @"cell";


static NSInteger const cols = 4;
static CGFloat const margin = 1;

#define  cellWH  ((BSScreenW - (cols - 1) * margin) / cols)

/*
    设置导航条标题字体 -> 由导航条setTitleTextAttributes
 */

// tableView和collectionView滚动范围由自己计算,不需要关心
// 自己根据自己的内容计算

- (void)viewDidLoad {
    [super viewDidLoad];
   // 1.设置导航条
    [self setUpNavBar];
    
    // 2.添加底部footView -> UICollectionView
    [self setUpFootView];
    
    // 3.设置tableView背景色
    self.tableView.backgroundColor = BSCommonBgColor;
    
    // 4.加载数据 -> 跟服务器打交道 -> 接口文档
    [self loadData];
    
    // 5.调整每一组间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = BSMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(BSMargin - 35, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
//     NSLog(@"%f:head--%f:foot",self.tableView.sectionHeaderHeight,self.tableView.sectionFooterHeight);
}

// 加载数据
- (void)loadData
{
    // 加载数据 -> 解析数据(plist) -> 设计模型 -> 字典转模型
    // 4.1 创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 4.2 拼接请求参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"a"] = @"square";
    param[@"c"] = @"topic";
    
    // 4.3 发送请求get
    [mgr GET:baseUrl parameters:param success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        //        [responseObject writeToFile:@"/Users/a1/Desktop/课堂共享/10-项目/1221-项目/06-我的界面/square.plist" atomically:YES];
        //        NSLog(@"%@",responseObject);
        // 获取字典数组
        NSArray *dictArr = responseObject[@"square_list"];
        
        // 字典数组转模型数组
        _squareList =  [BSSquareItem mj_objectArrayWithKeyValuesArray:dictArr];

        // 处理缺口数据
        [self resolveData];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 计算整个collectionView高度
        // 总数 => 总行数
        // 总行数 = (count - 1) / cols + 1 // 9 => 3
        NSInteger count = _squareList.count;
        NSInteger rows = (count - 1) / cols + 1;
        CGFloat collectionH = rows * cellWH;
        self.collectionView.height = collectionH;

        // 刷新tableView滚动范围
        // 直接重修设置tableView的footView,tableView计算下直接滚动范围
        self.tableView.tableFooterView = self.collectionView;
        // 调用这个方法的目的:刷新表格,重新计算contentSize
        [self.tableView reloadData];
        
//        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

// 计算缺多少个 -> 怎么去补方块
- (void)resolveData
{
    NSInteger count = _squareList.count;
    NSInteger extre = count % cols;
    if (extre) {
        extre = cols - extre;
        // 0
        for (int i = 0; i < extre; i++) {
            BSSquareItem *item = [[BSSquareItem alloc] init];
            [_squareList addObject:item];
        }
        
    }
}

/*
    UICollectionView使用步骤
    1.UICollectionView初始化的时候必须要有布局
    2.注册cell
    3.自定义cell,系统的cell没有任何子控件
*/

- (void)setUpFootView
{
   // 1.创建流水布局
    UICollectionViewFlowLayout *layout = ({
        
        // 1.创建流水布局
       UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
        
        // 2.设置流水布局属性
        
        // 2.1设置cell尺寸
        layout.itemSize = CGSizeMake(cellWH, cellWH);
        
        // 2.2 设置cell之间间距
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        
        layout;
    });
    
    // 2.创建UICollectionView
    UICollectionView *collectionView = ({
    
        // 1.创建UICollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, BSScreenW, 0) collectionViewLayout:layout];
        
        // 2.设置数据源 -> 要UICollectionView展示数据
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        // 3. 注册cell
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BSSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
        
         // 4.不允许collectionView滚动
        // 取消弹簧效果
//        collectionView.bounces = NO;
        collectionView.scrollEnabled = NO;
        
        collectionView.backgroundColor = self.tableView.backgroundColor;
        
        
        collectionView;
    
    });
    
    _collectionView = collectionView;
   
    // 3.设置collectionView为tableView的footView
    // 设置tableView的footView,高度由我们自己决定,宽度,位置都是控制不了
    self.tableView.tableFooterView = collectionView;

    
}

// 设置导航条
- (void)setUpNavBar
{
    
    // UINavigationItem:描述导航条内容
    // UIBarButtonItem:描述导航条按钮内容
    // left
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settting)];
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    // 按钮达到选中状态,必须通过代码
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    // titleView
    self.navigationItem.title = @"我的";
    
 }

// 点击设置调用,进入设置界面
- (void)settting
{
    // 进入设置界面
    BSSettingViewController *settingVc = [[BSSettingViewController alloc] init];
    // 隐藏底部条:条件:在跳转之前设置
    settingVc.hidesBottomBarWhenPushed = YES;

    
    [self.navigationController pushViewController:settingVc animated:YES];
    
    /*
        1.跳转,返回按钮
        2.底部条没有隐藏
     */
}

// cmd + option + 左边箭头
- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squareList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 获取模型
    BSSquareItem *item = self.squareList[indexPath.row];
    
    cell.item = item;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
// 监听collectionView点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.item);
    // 跳转到网页界面
    // 展示网页:safari:openURl -> 跳转到其他应用,当前应用会进入后台
    // safari:地址,加载进度条,有很多功能,刷新,前进和倒退
    
    // UIWebView:不能监听网页加载进度
    // 好处在当前界面展示网页,不足:没有功能,功能必须全部自己写
    
    // iOS9 SFSafariViewContoller.专门用来展示网页,而且已经有很多功能,相当于safari
    // #import <SafariServices/SafariServices.h>
    
    // iOS8 WKWebView:外观跟UIWebView,没有具体功能,仅仅是帮你展示网页,需要功能,需要直接写
    // WKWebView和UIWebView:1.WKWebView网页缓存 2.监听网页加载进度
    
    // 获取模型
    BSSquareItem *item = self.squareList[indexPath.row];
//    item.url
    if ([item.url hasPrefix:@"http"]) {
        // 需要跳转到网页
        BSHtmlViewController *html = [[BSHtmlViewController alloc] init];
        html.item = item;
        [self.navigationController pushViewController:html animated:YES];
        
    }
  
}

// 选中cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    
}



@end