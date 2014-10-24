//
//  BaseTask.h
//  SmartWuhan
//
//  Created by 帆 高 on 13-4-27.
//  Copyright (c) 2013年 haoqi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Json.h"



//-------------------------------------------------------------------
//http action
#define HTTP_ACTION_GET     @"GET"
#define HTTP_ACTION_POST    @"POST"
#define FUNCTION_NAME NSStringFromSelector(_cmd)

#define TAG @"DropOnto"

enum StatusCode {
    // 执行结果，成功
    EXCUTE_SUCCESSFUL = 0,
    //执行结果，失败
    EXCUTE_FAILED,
    //执行结果，无数据
    EXCUTE_NO_DATA,
    // 执行结果，网络错误
    EXCUTE_NETWORK_ERROR,
    // 认证错误
    EXCUTE_AUTH_ERROR,
    // 执行结果，超时
    EXCUTE_TIME_OUT,
    //执行结果，数据错误
    EXCUTE_DATA_ERROR,
    //服务器错误
    EXCUTE_SERVER_ERROR,
    // 文件错误
    EXCUTE_FILE_ERROR,
    // 内存溢出
    EXCUTE_OUT_OF_MEMORY,
    
    EXCUTE_STATUS_MAX
};

//-------------------------------------------------------------------


@interface HandleMsg : NSObject

@property(nonatomic)int what;
@property(nonatomic)int status;
@property(nonatomic)float progress;
@property(nonatomic,assign)id data; 
@property (nonatomic,assign) int taskTag;

@end

//task实现
@protocol MyTaskDelegate <NSObject>
@optional
-(void)fail:(int)err ;
-(void)finish:(id)data ;
-(void)progress:(float)progress;
@end


//ui或task实现
@protocol MyHandleDelegate <NSObject>

@optional
-(void)process:(HandleMsg*)msg;
@end

/*
 逻辑task都需要继承 BaseTask，实现main方法和MyTaskDelegate
 */

@interface BaseTask : NSOperation

@property(nonatomic,strong)NSString* tag;
@property(nonatomic,strong)NSString* subTag;
@property(nonatomic,strong)id<MyHandleDelegate> delegate;

-(id)initWith:(id<MyHandleDelegate>)del;
-(void)cancel;

+(void)addToQueue:(NSOperation*)task;


@end
