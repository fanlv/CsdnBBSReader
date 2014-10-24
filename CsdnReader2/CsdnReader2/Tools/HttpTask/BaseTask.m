//
//  BaseTask.m
//  SmartWuhan
//
//  Created by 帆 高 on 13-4-27.
//  Copyright (c) 2013年 haoqi. All rights reserved.
//


#import "BaseTask.h"
#import "AppDelegate.h"
#import "HttpExecutor.h"

@implementation HandleMsg

@synthesize what; 
@synthesize status;
@synthesize progress;
@synthesize data;

@end


@implementation BaseTask

@synthesize tag;
@synthesize subTag;
@synthesize delegate;

-(id)initWith:(id<MyHandleDelegate>)del
{
	self = [super init];
    if(self!=nil){
    	self.delegate=del;
    }

	return self;
}

-(void)cancel
{
	[super cancel];
}

+(void)addToQueue:(NSOperation*)task
{
	AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.mainQueue addOperation:task];
}

@end
