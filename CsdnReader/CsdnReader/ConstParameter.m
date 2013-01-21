//
//  constParameter.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "constParameter.h"

@implementation ConstParameter

+ (float)getArticleTitleHeight:(NSString *)content withWidth:(CGFloat)contentWidth andFont:(UIFont*)font
{
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    //titleBrand.numberOfLines = ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
  //  NSLog(@"%f",size.height);
    // 這裏返回需要的高度
    return size.height + 25;
}

// ---------date = 07-28 12:05
+ (NSString *)showMinusTimeWithNoYearDateString:(NSString *)date
{
    //------显示发布时间和发布人
    //得到日历对象
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //选择获取的时间单元标识，这里可以根据年来对应时间组件获取的参数调整，可以看看下面的对应列表
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //根据标识和时间创建事件组件，NSDateComponents还有很多用途，可以查看官方文档
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    //获取相应的时间操作
    [comps year];     //对应 - NSMonthCalendarUnit
    NSMutableString *dateString = [[NSMutableString alloc] initWithString:date ];
    [dateString insertString:[NSString stringWithFormat:@"%d-", [comps year]] atIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm"];
    NSDate *sendDate = [dateFormatter dateFromString:dateString];
    
    NSString *showDateString = [[NSString alloc] init];
    NSInteger distance = fabs([sendDate timeIntervalSinceNow]);
    if (distance < 60)
    {
        showDateString = [NSString stringWithFormat:@"%d秒前",distance];
    }
    else if (distance < 3600)
    {
        showDateString = [NSString stringWithFormat:@"%d分前",distance/60];
    }
    else if (distance < 86400)
    {
        showDateString = [NSString stringWithFormat:@"%d小时前",distance/3600];
    }
    else if (distance < 86400 * 28)
    {
        showDateString = [NSString stringWithFormat:@"%d天前",distance/86400];
    }
    else
    {
        showDateString = date;
    }
    
    return showDateString;

}


@end
