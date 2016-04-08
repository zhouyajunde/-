//
//  BSSettingViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSSettingViewController.h"

#import "NSObject+FileManager.h"

#import <SDWebImage/SDImageCache.h>

#import <SVProgressHUD/SVProgressHUD.h>

@interface BSSettingViewController ()

/** 缓存尺寸*/
@property(nonatomic ,assign) NSInteger total;

@end

@implementation BSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸..."];
    
   
    
    
    // 获取cachePath文件缓存
    [self getFileCacheSizeWithPath:self.cachePath completion:^(NSInteger total) {
        
        _total = total;
        
        // 计算完成就会调用
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
}

- (void)jump
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    // pushViewController:不但可以跳转,还可以设置返回按钮
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    cell.textLabel.text = [self getSizeStr];

    return cell;
}

- (NSString *)getSizeStr
{
    NSString *cacheStr = @"清除缓存";
    if (_total) {
        CGFloat totalF = _total;
        NSString *unit = @"B";
        if (_total > 1000 * 1000) { // MB
            totalF = _total / 1000.0 / 1000.0;
            unit = @"MB";
        }else if (_total > 1000){ // KB
            unit = @"KB";
            totalF = _total / 1000.0 ;
        }
        
        cacheStr = [NSString stringWithFormat:@"%@(%.1f%@)",cacheStr,totalF,unit];
    }

    return cacheStr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"正在删除.."];
    // 清空缓存,就是把Cache文件夹直接删掉
    // 删除比较耗时
    [self removeCacheWithCompletion:^{
        _total = 0;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
    
    
}


@end