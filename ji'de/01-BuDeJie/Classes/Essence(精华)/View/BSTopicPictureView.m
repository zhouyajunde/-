//
//  BSTopicPictureView.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/27.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import "BSSeeBigPictureViewController.h"

@interface BSTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@end

@implementation BSTopicPictureView

- (void)awakeFromNib
{
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

- (void)seeBigPicture
{
    BSSeeBigPictureViewController *seeBigPictureVc = [[BSSeeBigPictureViewController alloc] init];
    seeBigPictureVc.topic = self.topic;
    [self.window.rootViewController presentViewController:seeBigPictureVc animated:YES completion:nil];
}

- (void)setTopic:(BSTopic *)topic
{
    _topic = topic;

    // 下载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1]];
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    
    // 查看大图按钮
    if (topic.isBigPicture) {
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}

@end
