//
//  BSTopicCell.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTopicCell.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>

#import "BSTopicPictureView.h"
#import "BSTopicVoiceView.h"
#import "BSTopicVideoView.h"

@interface BSTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 最热评论-整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论-文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/** 图片 */
@property (nonatomic, weak) BSTopicPictureView *pictureView;
/** 视频 */
@property (nonatomic, weak) BSTopicVideoView *videoView;
/** 声音 */
@property (nonatomic, weak) BSTopicVoiceView *voiceView;
@end

@implementation BSTopicCell
#pragma mark - 懒加载
- (BSTopicPictureView *)pictureView
{
    if (!_pictureView) {
        BSTopicPictureView *pictureView = [BSTopicPictureView bs_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (BSTopicVideoView *)videoView
{
    if (!_videoView) {
        BSTopicVideoView *videoView = [BSTopicVideoView bs_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (BSTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        BSTopicVoiceView *voiceView = [BSTopicVoiceView bs_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

#pragma mark - 初始化
- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(BSTopic *)topic
{
    _topic = topic;
    
    // 设置头像
    [self.profileImageView bs_setHeader:topic.profile_image];
    
    self.nameLabel.text = topic.name;
    self.createdAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    
    [self.dingButton setTitle:topic.ding forState:UIControlStateNormal];
    [self.caiButton setTitle:topic.cai forState:UIControlStateNormal];
    [self.repostButton setTitle:topic.repost forState:UIControlStateNormal];
    [self.commentButton setTitle:topic.comment forState:UIControlStateNormal];
    
    // 最热评论
    if (topic.top_cmt.count) { // 有最热评论
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *username = cmt[@"user"][@"username"];
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    
    // 中间内容
    if (topic.type == BSTopicTypePicture) { // 图片
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == BSTopicTypeVoice) { // 声音
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.videoView.hidden = YES;
    } else if (topic.type == BSTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
    } else if (topic.type == BSTopicTypeWord) { // 段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    // 点赞按钮
    [self.dingButton setImage:[UIImage imageNamed:topic.is_ding ? @"mainCellDingClick" : @"mainCellDing"] forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= BSMargin;
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.topic.type == BSTopicTypePicture) { // 图片
        self.pictureView.frame = self.topic.centerF;
    } else if (self.topic.type == BSTopicTypeVoice) { // 声音
        self.voiceView.frame = self.topic.centerF;
    } else if (self.topic.type == BSTopicTypeVideo) { // 视频
        self.videoView.frame = self.topic.centerF;
    }
}

#pragma mark - 监听
- (IBAction)dingClick:(UIButton *)button {
    if (self.topic.is_ding) { // 取消赞
        self.topic.ding = [NSString stringWithFormat:@"%zd", self.topic.ding.integerValue - 1];
        self.topic.is_ding = NO;
        [button setImage:[UIImage imageNamed:@"mainCellDing"] forState:UIControlStateNormal];
    } else { // 赞
        self.topic.ding = [NSString stringWithFormat:@"%zd", self.topic.ding.integerValue + 1];
        self.topic.is_ding = YES;
        [button setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateNormal];
    }
    [button setTitle:self.topic.ding forState:UIControlStateNormal];
    
    // 发请求给服务器
}
@end
