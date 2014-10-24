//
//  BaseExecutor.h
//  SmartWuhan
//
//  Created by 帆 高 on 13-4-27.
//  Copyright (c) 2013年 haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTask.h"

@interface BaseExecutor : NSObject
{
	__weak id<MyTaskDelegate> delegate;
}

@property(nonatomic,weak)id<MyTaskDelegate> delegate;


+(BOOL)connectToNetwork;


-(id)initWith:(id<MyTaskDelegate>)del;
-(void)start;
//子类须覆盖run方法
-(void)run;

@end
