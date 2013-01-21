//
//  constParameter.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CSDN_BBS_URL          @"http://bbs.csdn.net"
#define CSDN_BBS_DOTNET_URL   @"http://bbs.csdn.net/forums/DotNET"
#define CSDN_BBS_CPP_URL      @"http://bbs.csdn.net/forums/cpp"
#define CSDN_BBS_MOBILE_URL   @"http://bbs.csdn.net/forums/mobile"
#define CSDN_BBS_JAVA_URL     @"http://bbs.csdn.net/forums/Java"
#define CSDN_BBS_OTHER_URL    @"http://bbs.csdn.net/forums/Other"

#define ARTICLE_TITIE_SIZE    15
#define K_CUSTOM_ROW_COUNT    7

//#define ARTICLE_TITIE         @"title"
//#define ARTICLE_POINT         @"point"
//#define ARTICLE_LINK          @"link"
//#define ARTICLE_DATE          @"date"
//#define ARTICLE_AUTHOR        @"author"
//#define ARTICLE_REPLY_COUNT   @"replycount"
//#define ARTICLE_LAST_UPDATE   @"lastUpDate"
//#define ARTICLE_CATEGORY      @"category"

@interface ConstParameter : NSObject

+ (float)getArticleTitleHeight:(NSString *)content withWidth:(CGFloat)contentWidth andFont:(UIFont*)font;

+ (NSString *)showMinusTimeWithNoYearDateString:(NSString *)date;


@end
