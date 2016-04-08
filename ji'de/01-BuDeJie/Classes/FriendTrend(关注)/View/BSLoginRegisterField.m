//
//  BSLoginRegisterField.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSLoginRegisterField.h"

#import "UITextField+Placeholder.h"

@implementation BSLoginRegisterField

// 1.修改光标
// 2.监听文本框开始编辑
// 3.开始编辑的文本框 占位文字颜色变成白色

- (void)awakeFromNib
{
    // 1.设置光标
    self.tintColor = [UIColor whiteColor];
    
    // 2.监听文本框开始编辑(代理,通知,绑定监听者),最好不要自己成为自己的代理
    [self addTarget:self action:@selector(textDidEdit) forControlEvents:UIControlEventEditingDidBegin];
    
    // 3.监听文本框结束编辑
    [self addTarget:self action:@selector(textDidEndEdit) forControlEvents:UIControlEventEditingDidEnd];
    
    
    // 快速修改占位文字 -> 占位文字(控件) -> 拿到这个控件(UILabel)就可以做事情 -> label.textColor
    // 想要拿到占位文字控件,找到对应属性名 KVC -> runtime
    // 以后想要查看一个类中有多少属性,1.runtime 2.断点

    // 获取占位文字的label
    self.placeholderColor =  [UIColor lightGrayColor];
    
   
    
//    self.placeholderColor = []


    // 想让所有的文本框快速设置文本框占位文字颜色
//    self.placeholderColor = 
    

    
}

// 文本框开始编辑就会调用
- (void)textDidEdit
{

    self.placeholderColor = [UIColor whiteColor];
}

// 文本框结束编辑就会调用
- (void)textDidEndEdit
{
    self.placeholderColor = [UIColor lightGrayColor];
  

}


@end
