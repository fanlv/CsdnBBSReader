//
//  BaseExecutor.m
//  SmartWuhan
//
//  Created by 帆 高 on 13-4-27.
//  Copyright (c) 2013年 haoqi. All rights reserved.
//


#import "BaseExecutor.h"
#import "Reachability.h"

@implementation BaseExecutor
@synthesize delegate;

-(id)initWith:(id<MyTaskDelegate>)del
{
	self=[super init];
    if(self!=nil){
    	delegate=del;
    }
    return self;
}


-(void)start;
{
	[self run];
}


-(void)run
{}



+(BOOL)connectToNetwork
{
    BOOL network = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    if (network) {
//        NSLog(@"有网络");
    }else{
        NSLog(@"无网络");
    }
	return network;
}


@end
