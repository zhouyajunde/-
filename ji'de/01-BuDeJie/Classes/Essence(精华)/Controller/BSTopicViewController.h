//
//  BSTopicViewController.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/29.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTopic.h"

@interface BSTopicViewController : UITableViewController
/** 帖子类型 */
//@property (nonatomic, assign, readonly) BSTopicType type;

- (BSTopicType)type;
@end
