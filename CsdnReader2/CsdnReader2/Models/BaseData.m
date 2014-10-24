//
//  BaseData.m
//  Droponto
//
//  Created by Fan Lv on 14-4-8.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "BaseData.h"
#import <objc/runtime.h>

@implementation BaseData

@synthesize status,rMsg;
@synthesize isStatusOK = _isStatusOK;


- (BOOL)isStatusOK
{
    _isStatusOK = [[status uppercaseString] isEqualToString:@"OK"];
    return _isStatusOK;
}

- (id)initWithJsonString:(NSString *)jsonString
{
    if (self = [super init])
    {
        @try {
            NSRange isRange = [jsonString rangeOfString:@"</div>" options:NSCaseInsensitiveSearch|NSBackwardsSearch];
            NSRange isRange1 = [jsonString rangeOfString:@"\n" options:NSCaseInsensitiveSearch|NSBackwardsSearch];
            if (isRange.location != NSNotFound)
                jsonString = [jsonString substringFromIndex:isRange.location+isRange.length];
            if (isRange1.location != NSNotFound)
                jsonString = [jsonString substringFromIndex:isRange1.location+isRange1.length];
        }
        @catch (NSException *exception) {
            NSLog(@"jsonString substringFromIndex exception :%@",[exception description]);
        }


        
        NSDictionary *dict = [jsonString JSONValue];
        if (dict) {
            [self setUpBaseInfoWithDic:dict];
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        if (dic) {
            [self setUpBaseInfoWithDic:dic];
        }
    }
    return self;
}

- (void)setUpBaseInfoWithDic:(NSDictionary *)dict
{
    @try
    {
        status = [dict objectForKey:@"status"];
        rMsg = [dict objectForKey:@"message"];

    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
    
}

- (void)setUpNilString
{
    
    @try {
        Class clazz = [self class];
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            NSRange isRange = [propertyAttributes rangeOfString:@"NSString" options:NSCaseInsensitiveSearch];
            if (isRange.location != NSNotFound)
            {
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                
                id tmpV= [self valueForKey:name];
                if (tmpV == nil || [tmpV isKindOfClass:[NSNull class]])
                {
                    [self setValue:@"" forKey:name];
                }
            }
        }
        free(properties);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    
    
}
@end
