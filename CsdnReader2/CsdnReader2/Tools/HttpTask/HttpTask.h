//
//  HttpTask.h
//  TrafficInfoService
//
//  Created by Fan Lv on 14-1-21.
//  Copyright (c) 2014年 FiberHome. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "BaseTask.h"

@interface HttpTask : BaseTask<MyTaskDelegate>
{
    NSString *taskUrl;
    NSString *taskAction;
    NSDictionary *taskData;
    NSDictionary *taskHeader; 
    int taskWhat;
    SEL doneAction;
    
    NSArray *cookieArray;
}


@property (nonatomic,assign) int taskTag;

///post方式调用1
-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl body:(NSDictionary*)dataBody header:(NSDictionary*)head what:(int)what;
///post方式调用2
-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl body:(NSDictionary*)dataBody header:(NSDictionary*)head action:(SEL)selector;

///get方式调用1
-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl what:(int)what;
///get方式调用2
-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl action:(SEL)selector;
///get方式调用3
-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl action:(SEL)selector cookies:(NSArray *)cookie;



//同步调用
+ (NSString *)getPostUrl:(NSString *)strUrl body:(NSDictionary *)dataBody header:(NSDictionary *)headers;
+ (NSString *)getUrl:(NSString *)url;


@end
