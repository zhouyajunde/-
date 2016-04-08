//
//  BSTopic.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/23.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSTopic.h"

@implementation BSTopic

- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    
    // 头像
    _cellHeight = 45 + BSMargin;
    
    // 文字
    CGFloat textMaxW = BSScreenW - 2 * BSMargin;
    _cellHeight += [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + BSMargin;
    
    // 中间
    if (self.type != BSTopicTypeWord) { // 中间至少要显示1张图片
        // 中间内容(比如图片)显示出来的宽度
        CGFloat centerW = textMaxW;
        // 中间内容(比如图片)显示出来的高度
        CGFloat centerH = self.height * centerW / self.width;
        if (centerH >= BSScreenH) { // 中间内容 >= 一个屏幕
            centerH = 200;
            self.bigPicture = YES;
        }
        
        // 中间内容的frame
        self.centerF = CGRectMake(BSMargin, _cellHeight, centerW, centerH);
        
        _cellHeight += centerH + BSMargin;
    }
    
    // 最热评论
    if (self.top_cmt.count) {
        // 标题
        _cellHeight += 20;
        
        // 评论文字
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *username = cmt[@"user"][@"username"];
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtText boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height + BSMargin;
    }
    
    // 底部工具条
    _cellHeight += 35 + BSMargin;
    
    return _cellHeight;
}

- (NSString *)created_at
{
    // 帖子的审核通过时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:_created_at];
    
    if (createdAtDate.bs_isThisYear) { // 今年
        if (createdAtDate.bs_isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } else if (createdAtDate.bs_isToday) { // 今天
            NSCalendar *calendar = [NSCalendar bs_calendar];
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
            
            if (cmps.hour >= 1) { // 时间间隔 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间间隔 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 时间间隔 < 1分钟
                return @"刚刚";
            }
        } else {
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
    } else { // 不是今年
        return _created_at;
    }
}

- (NSString *)buttonTitle:(NSString *)numberStr placeholder:(NSString *)placeholder
{
    NSInteger number = numberStr.integerValue;
    if (number >= 10000) {
        return [NSString stringWithFormat:@"%.1f万", number / 10000.0];
    } else if (number == 0) {
        return placeholder;
    } else {
        return numberStr;
    }
}

- (void)setDing:(NSString *)ding
{
    _ding = [self buttonTitle:ding placeholder:@"顶"];
}

- (void)setCai:(NSString *)cai
{
    _cai = [self buttonTitle:cai placeholder:@"踩"];
}

- (void)setRepost:(NSString *)repost
{
    _repost = [self buttonTitle:repost placeholder:@"分享"];
}

- (void)setComment:(NSString *)comment
{
    _comment = [self buttonTitle:comment placeholder:@"评论"];
}
@end
