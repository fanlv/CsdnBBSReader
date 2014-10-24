//
//  Constants.h
//  TrafficInfoService
//
//  Created by Fan Lv on 14-1-8.
//  Copyright (c) 2014年 FiberHome. All rights reserved.
//

/******** For iOS 7 or less **********/
#define OS_VERSION                    [ [[UIDevice currentDevice] systemVersion] floatValue]
#define DEVICE_STATUS_BAR_HEIGHT      20
#define NAV_BAR_HEIGHT               44
#define STATUS_BAR_HEIGHT_D_VAULE     ((OS_VERSION < 7)?(20):(0))


#define SCREENBOUNDS        [[UIScreen mainScreen] bounds];
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define DEVICE_IS_IPHONE5   ([[UIScreen mainScreen] bounds].size.height == 568)
#define APP_VERSION         [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]


#define CSDN_BBS_URL          @"http://bbs.csdn.net"
#define CSDN_POST_URL         @"http://bbs.csdn.net/posts?"
#define K_CUSTOM_ROW_COUNT    7


#define COOKIE_USERNAME       @"UserName"
#define COOKIE_USERINFO       @"UserInfo"
#define COOKIE_USERNICK       @"UserNick"


#define USER_LOGIN_SUCCEED         @"USER_LOGIN_SUCCEED"
#define USER_LOGIN_FAILED          @"USER_LOGIN_FAILED"




#define RGB(r,g,b)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


#define COLOR_ARRAY    [NSArray arrayWithObjects:RGB(242,178,101),RGB(165,201,173),RGB(228,177,98),RGB(229,105,113),RGB(219,199,164),RGB(165,200,201),RGB(145,204,232),RGB(80,140,201),RGB(169,115,177), nil]

#define Light_White_Color              RGB(241,241,241)
#define Light_White_Color238           RGB(238,238,238)
#define Light_White_Color200           RGB(200, 200, 200)
#define Light_Black_Color              RGB(59,49,49)
#define Dark_Black_Color               RGB(96,87,87)
#define Dark_Red_Color                 RGB(219, 76, 76)
#define Orange_Color                   RGB(255, 139, 40)


#define MIN_FONT                       [UIFont systemFontOfSize:9]
#define MIN_FONT2                      [UIFont systemFontOfSize:12]
#define MID_FONT                       [UIFont systemFontOfSize:14]
#define MID_FONT2                      [UIFont systemFontOfSize:16]
#define MAX_FONT                       [UIFont systemFontOfSize:18]

#define Nav_Bar_BackImgWhite     [UIImage imageNamed:@"return_white_icon.png"]



#define DB_NAME    @"DB_NAME"
































