//
//  RequestHelper.h
//  Droponto
//
//  Created by Fan Lv on 14-4-8.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CREATE_URL(host,url) [NSString stringWithFormat:@"%@/%@",host,url]

//#define SERVICE_ADDR                           @"http://54.186.165.243"
#define SERVICE_ADDR2                          @"http://m.droponto.com"
#define SERVICE_ADDR                           @"http://54.172.39.43"


#define USER_URL       CREATE_URL(SERVICE_ADDR,@"index.php/user")
#define GET_CONFIG_URL CREATE_URL(SERVICE_ADDR,@"index.php/config")
#define BUSNIESS_URL   CREATE_URL(SERVICE_ADDR,@"index.php/buzz")
#define POST_URL       CREATE_URL(SERVICE_ADDR,@"index.php/post")
#define MESSAGE_URL    CREATE_URL(SERVICE_ADDR,@"index.php/conversation")



@interface RequestHelper : NSObject

@end
