//
//  BSSubTagItem.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSubTagItem : NSObject

/** 图片 */
@property (nonatomic ,strong) NSString *image_list;

/** 标签名称 */
@property (nonatomic ,strong) NSString *theme_name;

/** 订阅数 */
@property (nonatomic ,strong) NSString *sub_number;

@end
