//
//  BSSubTageCell.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSSubTagItem;
@interface BSSubTageCell : UITableViewCell


/** item */
@property (nonatomic ,strong) BSSubTagItem *item;
+ (instancetype)subTageCell;

@end
