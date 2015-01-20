//
//  HttpTask.m
//  TrafficInfoService
//
//  Created by Fan Lv on 14-1-21.
//  Copyright (c) 2014年 FiberHome. All rights reserved.
//

#import "HttpTask.h"
#import "HttpExecutor.h"
#import "ASIFormDataRequest.h"


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation HttpTask

-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl body:(NSDictionary*)dataBody header:(NSDictionary*)head what:(int)what
{
    self = [super initWith:del];
    if(self)
    {
        taskUrl = strUrl;
        taskAction = HTTP_ACTION_POST;
        taskHeader = head;
        taskWhat = what;
        
        NSMutableDictionary *bodyDict = nil;
        if (dataBody) {
            bodyDict = [NSMutableDictionary dictionaryWithDictionary:dataBody];
        } else {
            bodyDict = [[NSMutableDictionary alloc] init];
        }
        taskData =bodyDict;
        bodyDict = nil;
    }
    return self;
}

-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl body:(NSDictionary*)dataBody header:(NSDictionary*)head action:(SEL)selector
{
    self = [self initWith:del url:strUrl body:dataBody header:head what:100];
    if (self) {
        doneAction = selector;
    }
    return self;
}



-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl what:(int)what{
    self = [super initWith:del];
    if(self)
    {
        taskUrl = strUrl;
        taskAction = HTTP_ACTION_GET;
        taskData = nil;
        taskHeader = nil;      
        taskWhat = what;
    }
    return self;
}

-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl action:(SEL)selector
{
    self = [self initWith:del url:strUrl what:101];
    if (self) {
        doneAction = selector;
    }
    return self;
}

-(id)initWith:(id<MyHandleDelegate>)del url:(NSString*)strUrl action:(SEL)selector cookies:(NSArray *)cookie
{
    self = [self initWith:del url:strUrl what:101];
    if (self) {
        doneAction = selector;
//        cookieArray = cookie;
    }
    return self;
}



// NSOperation 非并发多线程
-(void)main
{
	HttpExecutor* exe=[[HttpExecutor alloc] initWith:self url:taskUrl action:taskAction body:taskData header:taskHeader cookies:cookieArray];
    [exe start];
}

-(void)finish:(id)data
{
	HandleMsg* msg = [[HandleMsg alloc] init];
    msg.what=taskWhat;
    msg.status=EXCUTE_SUCCESSFUL;
    msg.progress=1;
    msg.data=data;
    msg.taskTag = self.taskTag;
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(process:)])
        {
            [self.delegate process:msg];
        }
        if ([self.delegate respondsToSelector:doneAction])
        {
            SuppressPerformSelectorLeakWarning([self.delegate performSelector:doneAction withObject:msg]);
        }
    }
}

-(void)fail:(int)err
{
	HandleMsg* msg = [[HandleMsg alloc] init];
    msg.what=taskWhat;
    msg.status=err;
    msg.progress=1;
    msg.data=nil;
    msg.taskTag = self.taskTag;

    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(process:)])
        {
            [self.delegate process:msg];
        }
        if ([self.delegate respondsToSelector:doneAction])
        {
            SuppressPerformSelectorLeakWarning([self.delegate performSelector:doneAction withObject:msg]);
        }
    }
}

-(void)progress:(float)p
{
	HandleMsg* msg = [[HandleMsg alloc] init];
    msg.what=taskWhat;
    msg.status=EXCUTE_SUCCESSFUL;
    msg.progress=p;
    msg.data=nil;
    msg.taskTag = self.taskTag;

    if ([self.delegate respondsToSelector:@selector(process:)])
    {
        [self.delegate process:msg];
    }
    if ([self.delegate respondsToSelector:doneAction])
    {
        SuppressPerformSelectorLeakWarning([self.delegate performSelector:doneAction withObject:msg]);
    }
}


+ (NSString *)getPostUrl:(NSString *)strUrl body:(NSDictionary *)dataBody header:(NSDictionary *)headers
{
    ASIFormDataRequest *requst = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if(requst==nil)
    {
        return @"";
    }
    
    [requst setRequestMethod:@"POST"];
    [requst setTimeOutSeconds:30];
    
    if(headers!=nil)
    {
        for (NSString* key in [headers keyEnumerator])
        {
            [requst addRequestHeader:key value:[headers valueForKey:key]];
        }
    }
    
    NSMutableDictionary *bodyDict = nil;

    
    if (dataBody) {
        bodyDict = [NSMutableDictionary dictionaryWithDictionary:dataBody];
    } else {
        bodyDict = [[NSMutableDictionary alloc]init];
    }
    if(dataBody!=nil)
    {
        for (NSString* key in [dataBody keyEnumerator])
        {
            [requst addPostValue:[dataBody valueForKey:key] forKey:key];
        }
    }
    [requst startSynchronous];
    
    NSError *error = [requst error];
    NSString *response;
    if (!error)
    {
        response = [requst responseString];
    }
    return response;
}


+ (NSString *)getUrl:(NSString *)url
{
    NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urltmp = [NSURL URLWithString:requestURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urltmp];
    [request setRequestMethod:@"GET"];
    
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = [request responseString];
    }
    return response;
}

@end
