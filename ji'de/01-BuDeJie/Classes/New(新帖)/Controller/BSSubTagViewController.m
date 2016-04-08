//
//  BSSubTagViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSSubTagViewController.h"

#import <AFNetworking/AFNetworking.h>

#import <MJExtension/MJExtension.h>

#import "BSSubTagItem.h"

#import "BSSubTageCell.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface BSSubTagViewController ()


@property (nonatomic ,weak)  AFHTTPSessionManager *mgr;

/** 模型数组 */
@property (nonatomic ,strong) NSMutableArray *tags;

@end

@implementation BSSubTagViewController
/*
    加载数据(AFN) -> 分析请求数据结果-> 设计模型 -> 字典转模型 -> 展示界面
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐标签";
    
    // 1.加载数据
    [self loadData];
  
    // 1.加载xib,使用NSBundle加载,一定要记得绑定标示符
    // 2.注册xib
    
    // NIB:xib
    [self.tableView registerNib:[UINib nibWithNibName:@"BSSubTageCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    // 分割线全屏:1.自定义分割线 2.系统提供一些方法,默认会给cell分割线添加额外间距
    // 3.setFrame,
    // 取消系统分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    // 4.添加请求指示器 SVProgressHud
    // 正在请求
    [SVProgressHUD showWithStatus:@"正在请求..."];
    
}

// 界面消失的时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 隐藏指示器
    [SVProgressHUD dismiss];
    
    // 取消之前的请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 销毁会话管理者
    [_mgr invalidateSessionCancelingTasks:NO];
}

// 加载数据
- (void)loadData
{
    // 1.1 创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    _mgr = mgr;
    
    // 1.2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    // 1.3 发送请求
    
    [mgr GET:baseUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        // 字典数组直接转换成模型数组
      _tags = [BSSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
//        [responseObject writeToFile:@"/Users/a1/Desktop/课堂共享/10-项目/1218-项目/04-订阅标签/tag.plist" atomically:YES];
//        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tags.count;
}

// 返回每个cell的外观
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    BSSubTageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    BSFunc;
//    NSLog(@"%@",NSStringFromUIEdgeInsets(cell.layoutMargins));
    
//    if (cell == nil) {
//        cell = [BSSubTageCell subTageCell];
//    }
    
//    BSFunc;
    
    BSSubTagItem *item = _tags[indexPath.row];
    
    cell.item = item;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BSFunc;
//    BSLog(@"%s---%ld",__func__,indexPath.row);
    return 80;
}


@end