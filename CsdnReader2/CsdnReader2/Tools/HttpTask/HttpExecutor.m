//
//  HttpExecutor.m
//  SmartWuhan
//
//  Created by 帆 高 on 13-4-27.
//  Copyright (c) 2013年 haoqi. All rights reserved.
//

#import "HttpExecutor.h"
#import "Log.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"


#define HTTP_EXECUTOR_TEST 0

@implementation HttpExecutor

@synthesize url;
@synthesize action;
@synthesize body;
@synthesize headers;
@synthesize cookieArray;

-(id)initWith:(id<MyTaskDelegate>)del url:(NSString*)strUrl action:(NSString*)strAction body:(NSDictionary*)dataBody header:(NSDictionary*)head cookies:(NSArray *)cookie
{
	self = [super initWith:del];
    if(self){
    	self.url = [strUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        self.action=strAction;
        self.body=dataBody;
        self.headers=head;
        self.cookieArray = [cookie mutableCopy];

#if HTTP_EXECUTOR_TEST
        [Log print:TAG msg:@"---[HTTP_EXECUTOR_TEST]--\n url=%@\n action=%@\n head:\n%@ body:\n %@",
         strUrl==nil ? @"null" : strUrl,
         strAction==nil ? @"null" : strAction,
         head==nil ? @"null" : head,
         body==nil ? @"null" : [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]];
#endif        
    }
    
    return self;
}

-(void)setProgress:(float)newProgress
{
	[delegate progress:newProgress];
}


-(id) analysisData:(NSData*)data
{
	return data;
}

-(void)run
{   
    if(![BaseExecutor connectToNetwork]){
        [Log print:TAG msg:@"[%@]--net is invaliad",FUNCTION_NAME];
    	[delegate fail:EXCUTE_NETWORK_ERROR];
        return;
    }
    
    ASIFormDataRequest *requst = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if(requst==nil){
    	[delegate fail:EXCUTE_FAILED];
        return;
    }
    
    [requst setRequestMethod:action];
    [requst setTimeOutSeconds:30];
    
    if(headers!=nil){
        for (NSString* key in [headers keyEnumerator]) {
            [requst addRequestHeader:key value:[headers valueForKey:key]];
        }
    }    
    
    if(body!=nil){
        for (NSString* key in [body keyEnumerator]) {
            [requst addPostValue:[self.body valueForKey:key] forKey:key];
        }
    }
    
    
    if ([self.cookieArray count]>0) {
        [requst setUseCookiePersistence:NO];
        [requst setRequestCookies:self.cookieArray];
    }

    [requst startSynchronous];
/*
 ASIConnectionFailureErrorType = 1,
 ASIRequestTimedOutErrorType = 2,
 ASIAuthenticationErrorType = 3,
 ASIRequestCancelledErrorType = 4,
 ASIUnableToCreateRequestErrorType = 5,
 ASIInternalErrorWhileBuildingRequestType  = 6,
 ASIInternalErrorWhileApplyingCredentialsType  = 7,
 ASIFileManagementError = 8,
 ASITooMuchRedirectionErrorType = 9,
 ASIUnhandledExceptionError = 10,
 ASICompressionError = 11 
*/    
    NSError* err=[requst error];
    if(err){
    	[Log print:TAG msg:@"[%@]--err:%@",FUNCTION_NAME,[err.userInfo valueForKey:NSLocalizedDescriptionKey]];
    }
    
    int statusCode = [requst responseStatusCode];
    //NSData* data=[requst responseData];
    NSString *string = [requst responseString];
    
    if((statusCode/100)!=2)
    {
        if(delegate)
        {
        	if(statusCode == 401){
            	[delegate fail:EXCUTE_AUTH_ERROR];//鉴权失败
            }
            else
            {
                if(err && err.code==ASIRequestTimedOutErrorType)
                    [delegate fail:EXCUTE_TIME_OUT];//超时
                else 
                    [delegate fail:EXCUTE_NETWORK_ERROR];
            }
        }
        
        requst=nil;
        [Log print:TAG msg:@" %@ \n error code : %d",string,statusCode];
//        return;
    }
    
    
    if(delegate)
    	[delegate finish:string];
    
    requst=nil;
}

@end
