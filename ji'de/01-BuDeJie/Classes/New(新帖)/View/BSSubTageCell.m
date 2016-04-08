//
//  BSSubTageCell.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSSubTageCell.h"

#import <UIImageView+WebCache.h>

#import "BSSubTagItem.h"
#import "UIImage+Antialias.h"

@interface BSSubTageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numberView;

@end

@implementation BSSubTageCell

+ (instancetype)subTageCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setItem:(BSSubTagItem *)item
{
    _item = item;
    
    // 给图片view设置
    [_iconView bs_setHeader:item.image_list];
    
    // 名称
    _nameView.text = item.theme_name;
    
    // 订阅数
    // 20000 2.0万
    // 判断下是否>10000
    CGFloat sub_num = [item.sub_number integerValue];
    NSString *numStr = [NSString stringWithFormat:@"%@,人订阅",item.sub_number] ;
    if (sub_num > 10000) {
        sub_num = sub_num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",sub_num];
    }
    _numberView.text = numStr;
}
@end
