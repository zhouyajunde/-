//
//  UIView+Init.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/27.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "UIView+Init.h"

@implementation UIView (Init)

+ (instancetype)bs_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end
