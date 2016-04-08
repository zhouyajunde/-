//
//  BSHtmlViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSHtmlViewController.h"

#import <WebKit/WebKit.h>


#import "BSSquareItem.h"

@interface BSHtmlViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic)  WKWebView *webView;
@property (weak, nonatomic)  UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;

@end

@implementation BSHtmlViewController
- (IBAction)back:(UIBarButtonItem *)sender {
    // 倒退
    [self.webView goBack];
}
- (IBAction)go:(id)sender {
    // 前进
    [self.webView goForward];
    
}
- (IBAction)refresh:(id)sender {
    // 刷新
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 展示网页:WKWebView -> #import <WebKit/WebKit.h>
    [self loadHtml];
    
    // 添加一个进度条
    [self setUpProgressView];
    
    // KVO
    // 监听是否允许倒退
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    
     // 监听是否允许前进
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听加载标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听网页URL
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    
}

// 添加一个进度条
- (void)setUpProgressView
{
    CGFloat y = self.navigationController?64:0;
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, y, BSScreenW, 1)];
    
    // 设置进度条颜色
    progressView.progressTintColor = [UIColor orangeColor];
    
    _progressView = progressView;
    
    [self.contentView addSubview:progressView];
    
    // 监听加载网页进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"URL"];
}

// 只要监听对象的属性一改变就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 控制器item是否允许点击
    _backItem.enabled = self.webView.canGoBack;
    _forwardItem.enabled = self.webView.canGoForward;
    
    // 设置进度条
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden =  self.progressView.progress == 1;
    
    self.title = self.webView.title;
    
    NSLog(@"\n%@ \n %@",self.webView.title,self.webView.URL);
}

- (void)loadHtml
{
    // 创建WKWebView
    WKWebView *webView = [[WKWebView alloc] init];
    
    _webView = webView;
    
    [self.contentView addSubview:webView];
    // 加载网页
    NSURL *url = [NSURL URLWithString:_item.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentView.bounds;
    
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
