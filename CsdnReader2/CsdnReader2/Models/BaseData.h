//
//  BaseData.h
//  Droponto
//
//  Created by Fan Lv on 14-4-8.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "GlobalData.h"
#import "FMDatabase.h"

///Model和Data占时写在一起
@interface BaseData : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *rMsg;

@property (nonatomic,assign) BOOL isStatusOK;



- (void)setUpNilString;

///获取returnCode和returnInfo
- (id)initWithJsonString:(NSString *)jsonString;

- (id)initWithDictionary:(NSDictionary *)dic;

- (void)setUpBaseInfoWithDic:(NSDictionary *)dict;

@end
