//
//  BSVoiceViewController.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSVoiceViewController.h"

@implementation BSVoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[[UISwitch alloc] init]];
}

- (BSTopicType)type
{
    return BSTopicTypeVoice;
}

@end