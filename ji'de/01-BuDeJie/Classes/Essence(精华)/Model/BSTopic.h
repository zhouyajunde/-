//
//  BSTopic.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/23.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BSTopicType) {
    /** 全部 */
    BSTopicTypeAll = 1,
    /** 图片 */
    BSTopicTypePicture = 10,
    /** 段子 */
    BSTopicTypeWord = 29,
    /** 声音 */
    BSTopicTypeVoice = 31,
    /** 视频 */
    BSTopicTypeVideo = 41
};

@interface BSTopic : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, copy) NSString *ding;
/** 踩数量 */
@property (nonatomic, copy) NSString *cai;
/** 转发\分享数量 */
@property (nonatomic, copy) NSString *repost;
/** 评论数量 */
@property (nonatomic, copy) NSString *comment;
/** 帖子类型 */
@property (nonatomic, assign) BSTopicType type;
/** 最热评论(数组里面存放着最热评论数据) */
@property (nonatomic, strong) NSArray *top_cmt;
/** 中间图片宽度 */
@property (nonatomic, assign) NSInteger width;
/** 中间图片高度 */
@property (nonatomic, assign) NSInteger height;
/** 视频的时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 播放数量 */
@property (nonatomic, assign) NSInteger playcount;
/** 小图片 */
@property (nonatomic, copy) NSString *image0;
/** 大图片 */
@property (nonatomic, copy) NSString *image1;
/** 中图片 */
@property (nonatomic, copy) NSString *image2;
/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;


/**** 辅助属性 ****/
/** 是否被点过赞 */
@property (nonatomic, assign) BOOL is_ding;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect centerF;
/** 是否为动态图 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
@end


