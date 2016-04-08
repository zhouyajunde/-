//
//  BSTopicVideoView.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/27.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTopicVideoView.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import "BSSeeBigPictureViewController.h"

@interface BSTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@end

@implementation BSTopicVideoView

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
    
    // 大图片
    if (topic.isBigPicture) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    // 下载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1]];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    
    // 时间
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    // %02zd : 用2位字符的空间来显示数字, 多余的空间用0来填补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
