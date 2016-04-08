//
//  BSTopicCell.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTopic;

@interface BSTopicCell : UITableViewCell
/** 帖子模型 */
@property (nonatomic, strong) BSTopic *topic;
@end
