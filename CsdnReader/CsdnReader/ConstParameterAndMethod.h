//
//  constParameter.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CSDN_BBS_URL          @"http://bbs.csdn.net"
#define CSDN_POST_URL         @"http://bbs.csdn.net/posts?"
#define ARTICLE_TITIE_SIZE    15
#define K_CUSTOM_ROW_COUNT    7

#define COOKIE_USERNAME       @"UserName"
#define COOKIE_USERINFO       @"UserInfo"
#define COOKIE_USERNICK       @"UserNick"

#define FIRST_BBS_BOARD       @"FirstBBSBoard"
#define SECOND_BBS_BOARD      @"SecondBBSBoard"
#define THRID_BBS_BOARD       @"ThridBBSBoard"



#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


@interface ConstParameterAndMethod : NSObject


+ (NSDictionary *)BBSUrlList;

+ (NSString *)FirstBBSBoard;

+ (NSString *)SecondBBSBoard;

+ (NSString *)ThridBBSBoard;

+ (NSString *)GetAppVersion;


+ (BOOL)isUserLogin;

+ (NSString *)isErrorPageWithHtml:(NSString *)htmlContent;

+ (void)RefreshTabBarController:(UITabBarController *)tabBarController;

//+ (void)setDataSourceWithGetWebSiteHtmlWithOutCookie:(NSString *)webSite andSetDelegate:(id)delegate;

+ (void)loginCsdnBbsWithUserName:(NSString *)userName andPassWord:(NSString *)passWord andSetDelegate:(id)delegate;

+ (void)setDataSourceWithWebSiteHtmlWithCookie:(NSString *)webSite andSetDelegate:(id)delegate;

+ (float)getArticleTitleHeight:(NSString *)content withWidth:(CGFloat)contentWidth andFont:(UIFont*)font;

+ (NSString *)showMinusTimeWithNoYearDateString:(NSString *)date;


@end
