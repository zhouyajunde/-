//
//  BSTopicViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTopicViewController.h"
#import "BSTopic.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "BSHeader.h"
#import "BSFooter.h"
#import "BSHTTPSessionManager.h"
#import "BSTopicCell.h"
#import "BSNewController.h"

@interface BSTopicViewController ()
/** 请求管理者 */
@property (nonatomic, weak) BSHTTPSessionManager *mgr;
/** 全部的帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
// 写方法声明后才有点语法提示
- (NSString *)aParam;
@end

@implementation BSTopicViewController
static NSString * const BSTopicCellId = @"topic";

// 在这里实现这个方法仅仅是为了消除编译器的警告
- (BSTopicType)type {return 0;}

#pragma mark - 懒加载
- (BSHTTPSessionManager *)mgr
{
    if (!_mgr) {
        _mgr = [BSHTTPSessionManager manager];
    }
    return _mgr;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置表格
    [self setUpTable];
    
    // 集成刷新控件
    [self setUpRefresh];
}

/**
 * 集成刷新控件
 */
- (void)setUpRefresh
{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

/**
 * 设置表格
 */
- (void)setUpTable
{
    self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, BSTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell(当通过BSTopicCellId去缓存池找不到cell时, 就会自动创建BSTopicCell.xib中的cell, 并且给cell绑定BSTopicCellId标识)
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:BSTopicCellId];
}

#pragma mark - 数据处理
- (NSString *)aParam
{
//    if (self.parentViewController.class == NSClassFromString(@"BSNewController")) return @"newlist";
//    return @"list";
    
//    if (self.parentViewController.class == [BSNewController class]) return @"newlist";
//    return @"list";
    
//    if ([@"BSNewController" isEqualToString:NSStringFromClass(self.parentViewController.class)]) return @"newlist";
//    return @"list";
    
    if ([self.parentViewController isKindOfClass:[BSNewController class]]) return @"newlist";
    return @"list";

    // [a isKindOfClass:c] 判断a是否为c类型或者为c的子类类型
    // 错误写法
//    if ([self.parentViewController isKindOfClass:[BSEssenceViewController class]]) return @"list";
//    return @"newlist";
}

/**
 * 加载最新的帖子数据
 */
- (void)loadNewTopics
{
    // 取消之前的请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.aParam;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    // 发送请求
    [self.mgr GET:baseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数组
        self.topics = [BSTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == NSURLErrorCancelled) {
            BSLog(@"取消了任务");
        } else {
            BSLog(@"请求失败 - %@", error);
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 * 加载更多的帖子数据
 */
- (void)loadMoreTopics
{
    // 取消之前的请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.aParam;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    // 发送请求
    [self.mgr GET:baseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数组
        NSArray *moreTopics = [BSTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BSLog(@"请求失败 - %@", error);
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:BSTopicCellId];
    cell.topic = self.topics[indexPath.row];
    return cell;
}

#pragma mark - 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSFunc
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}
@end
