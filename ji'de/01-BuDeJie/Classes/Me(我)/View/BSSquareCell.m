//
//  BSSquareCell.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSSquareCell.h"
#import "BSSquareItem.h"

#import <UIImageView+WebCache.h>

@interface BSSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;


@end

@implementation BSSquareCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setItem:(BSSquareItem *)item
{
    _item = item;
    
    // 给子控件赋值
    _nameView.text = item.name;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    
}
@end
