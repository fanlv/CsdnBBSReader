//
//  constParameter.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "ConstParameterAndMethod.h"
#import "ASIHTTPRequest.h"

@implementation ConstParameterAndMethod

//https://passport.csdn.net/ajax/accounthandler.ashxt=log&u=f800051235&p=fan1234560&remember=0&f=h&rand=0.5


//f800051235&p=fan1234560&remember=0&f=http%3A%2F%2Fbbs.csdn.net%2F&rand=0.57829708292186

+ (void)loginCsdnBbsWithUserName:(NSString *)userName andPassWord:(NSString *)passWord andSetDelegate:(id)delegate
{
    NSString *getCookieUrl = [NSString stringWithFormat:
                              @"https://passport.csdn.net/ajax/accounthandler.ashx?t=log&u=%@&p=%@&remember=1&f=h&rand=0.6"
                              ,userName,passWord];
    NSURL *url2 = [NSURL URLWithString:getCookieUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url2];
    [request setDelegate:delegate];
    [request setUseCookiePersistence:YES];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Referer" value:@"https://passport.csdn.net/account/loginbox"];
    [request startAsynchronous];
}

+ (void)setDataSourceWithGetWebSiteHtmlWithOutCookie:(NSString *)webSite andSetDelegate:(id)delegate
{
    NSURL *url2 = [NSURL URLWithString:webSite];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url2];
    [request setShowAccurateProgress:YES];
    [request setDelegate:delegate];
    [request startAsynchronous];
}



//zHqspPpOZvQ1oMXDZJPXb2Z6CENYMdp3FW2kw8GJxkQmszJyoAS3s6pLikmKaj0xEboVlgwiHNWIKtJ3fWhuwrSn352uVfiKyDhHWYmdmzo%2bcBIo9NvYYweRm0A2Toy1EgJ9sja2C2OzwgggFT4nPw%3d%3d
+ (void)setDataSourceWithWebSiteHtmlWithCookie:(NSString *)webSite andSetDelegate:(id)delegate
{
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userName = [ud objectForKey:@"UserName"];
    NSString *userInfo = [ud objectForKey:@"UserInfo"];

    if (userInfo == nil || userName == nil)
    {
        userName = @"";
        userInfo = @"";
    }
    
    
    
    NSDictionary *properties2 = [[NSMutableDictionary alloc] init];
    [properties2 setValue:@"UserName"  forKey:NSHTTPCookieName];
    [properties2 setValue:userName forKey:NSHTTPCookieValue];
    [properties2 setValue:@".csdn.net" forKey:NSHTTPCookieDomain];
    [properties2 setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie2 = [[NSHTTPCookie alloc] initWithProperties:properties2];
    
    
    
    NSDictionary *properties3 = [[NSMutableDictionary alloc] init];
    [properties3 setValue:@"UserInfo"  forKey:NSHTTPCookieName ];
    [properties3 setValue:userInfo forKey:NSHTTPCookieValue];
    [properties3 setValue:@".csdn.net" forKey:NSHTTPCookieDomain];
    [properties3 setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie3 = [[NSHTTPCookie alloc] initWithProperties:properties3];
    
    
    
    
    //This url will return the value of the 'ASIHTTPRequestTestCookie' cookie
    NSURL *url = [NSURL URLWithString:webSite];
    ASIHTTPRequest  *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:delegate];
    
    
    NSMutableArray *cookiesArray = [[NSMutableArray alloc] init];
    [cookiesArray addObject:cookie2];
    [cookiesArray addObject:cookie3];
    // [cookiesArray addObject:cookie4];
    
    [request setUseCookiePersistence:NO];
    [request setRequestCookies:cookiesArray];
    [request startAsynchronous];

}



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
