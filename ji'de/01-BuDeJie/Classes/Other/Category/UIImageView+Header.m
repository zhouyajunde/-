//
//  UIImageView+Header.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "UIImageView+Header.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Header)
- (void)bs_setHeader:(NSString *)url
{
    // 占位图片
    UIImage *placeholder = [UIImage bs_circleImageNamed:@"defaultUserIcon"];
    
    // 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        
        self.image = [image bs_circleImage];
    }];
    
//    // 占位图片
//    UIImage *placeholder = [UIImage imageNamed:@"defaultUserIcon"];
//    
//    // 下载图片
//    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}
@end
