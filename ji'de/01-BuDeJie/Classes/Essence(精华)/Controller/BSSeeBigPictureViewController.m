//
//  BSSeeBigPictureViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/28.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSSeeBigPictureViewController.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

#import <Photos/Photos.h>

@interface BSSeeBigPictureViewController () <UIScrollViewDelegate>
/** imageView */
@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation BSSeeBigPictureViewController
static NSString * const BSAssetCollectionName = @"7期百思不得姐";

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.view insertSubview:scrollView atIndex:0];
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = BSScreenW;
    imageView.height = self.topic.height * imageView.width / self.topic.width;
    imageView.x = 0;
    if (imageView.height > BSScreenH) { // 图片高度 > 屏幕高度
        imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.height);
    } else {
        imageView.centerY = BSScreenH * 0.5;
    }
    // 下载大图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.saveButton.enabled = YES;
    }];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 设置最大缩放比例
    CGFloat scale = self.topic.width / imageView.width;
    if (scale > 1.0) {
        scrollView.maximumZoomScale = scale;
        scrollView.delegate = self;
    }
}

#pragma mark - 监听
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 一.保存图片到【Camera Roll】(相机胶卷)
 1.使用函数UIImageWriteToSavedPhotosAlbum
 2.使用AssetsLibrary.framework(iOS9开始, 已经过期)
 3.使用Photos.framework(iOS8开始可以使用, 从iOS9开始完全取代AssetsLibrary.framework)
 
 二.创建新的【自定义Album】(相簿\相册)
 1.使用AssetsLibrary.framework(iOS9开始, 已经过期)
 2.使用Photos.framework(iOS8开始可以使用, 从iOS9开始完全取代AssetsLibrary.framework)
 
 三.将【Camera Roll】(相机胶卷)的图片 添加到 【自定义Album】(相簿\相册)中
 1.使用AssetsLibrary.framework(iOS9开始, 已经过期)
 2.使用Photos.framework(iOS8开始可以使用, 从iOS9开始完全取代AssetsLibrary.framework)
 
 四.Photos.framework须知
 1.PHAsset : 一个PHAsset对象就代表一张图片或者一段视频
 2.PHAssetCollection : 一个PHAssetCollection对象就代表一本相册
 
 五.PHAssetChangeRequest的基本认识
 1.可以对相册图片进行【增\删\改】的操作
 
 六.PHPhotoLibrary的基本认识
 1.对相册的任何修改都必须放在以下其中一个方法的block中
 [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:error:];
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:completionHandler:];
 */

- (IBAction)save {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) { // 用户已经允许当前app访问【Photos】应用
        [self saveImage];
    } else if (status == PHAuthorizationStatusDenied) { // 用户已经拒绝当前app访问【Photos】应用
        BSLog(@"提醒用户打开访问开关【设置】-【隐私】-【照片】-【百思不得姐】")
    } else if (status == PHAuthorizationStatusNotDetermined) { // 从未弹框让用户做出选择（用户还没有做出选择）
        
        // 弹框让用户做出选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { // 用户做出选择后会自动调用这个block
            if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前app访问【Photos】应用
                [self saveImage];
            } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前app访问【Photos】应用
                // 用户刚做出拒绝当前app的举动
            }
        }];
        
    } else if (status == PHAuthorizationStatusRestricted) { // 系统级别的限制（用户都无法给你授权）
        [SVProgressHUD showErrorWithStatus:@"由于系统原因，无法保存图片！"];
    }
}

/**
 * 保存图片到自定义Album
 */
- (void)saveImage
{
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    NSError *error = nil;
    // 用来抓取PHAsset的字符串标识
    __block NSString *assetId = nil;
    // 用来抓取PHAssetCollection的字符串标识
    __block NSString *assetCollectionId = nil;
    
    // 保存图片到【Camera Roll】(相机胶卷)
    [library performChangesAndWait:^{
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    // 获得曾经创建过的自定义相册
    PHAssetCollection *createdAssetCollection = nil;
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:BSAssetCollectionName]) {
            createdAssetCollection = assetCollection;
            break;
        }
    }
    
    // 如果这个自定义相册没有被创建过
    if (createdAssetCollection == nil) {
        // 创建新的【自定义Album】(相簿\相册)
        [library performChangesAndWait:^{
            assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:BSAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        
        // 抓取刚刚创建完的相册对象
        createdAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
    }
    
    // 将【Camera Roll】(相机胶卷)的图片 添加到 【自定义Album】(相簿\相册)中
    [library performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
        
        // 图片
        [request addAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil]];
    } error:&error];
    
    // 提示信息
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
    }
}

//- (void)saveImage
//{
//    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
//    NSError *error = nil;
//    // 用来抓取PHAsset的字符串标识
//    __block NSString *assetId = nil;
//    // 用来抓取PHAssetCollection的字符串标识
//    __block NSString *assetCollectionId = nil;
//    
//    // 保存图片到【Camera Roll】(相机胶卷)
//    [library performChangesAndWait:^{
//        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
//    } error:&error];
//    
//    // 创建新的【自定义Album】(相簿\相册)
//    [library performChangesAndWait:^{
//        assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"7期百思不得姐"].placeholderForCreatedAssetCollection.localIdentifier;
//    } error:&error];
//    
//    // 将【Camera Roll】(相机胶卷)的图片 添加到 【自定义Album】(相簿\相册)中
//    [library performChangesAndWait:^{
//        // 相册
//        PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
//        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//        
//        // 图片
//        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
//        [request addAssets:@[asset]];
//    } error:&error];
//    
//    // 提示信息
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
//    }
//}

- (void)getCameraRollAlbum
{
    // 获得Camera Roll【相机胶卷】
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        BSLog(@"%@", assetCollection.localizedTitle)
    }
}

- (void)getAllDIYAlbums
{
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        BSLog(@"%@", assetCollection.localizedTitle)
    }
}

- (void)asyncOperation
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 异步执行修改操作
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) { // 修改完毕后，会自动调用completionHandler这个block
        BSLog(@"1")
    }];
    
    BSLog(@"2")
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
