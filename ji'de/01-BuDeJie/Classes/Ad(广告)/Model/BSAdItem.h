//
//  BSAdItem.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSAdItem : NSObject

/** 广告图片 */
@property (nonatomic ,strong) NSString *w_picurl;

// 点击广告跳转的界面
@property (nonatomic ,strong) NSString *ori_curl;


@property(nonatomic ,assign)CGFloat w;

@property(nonatomic ,assign)CGFloat h;

@end
