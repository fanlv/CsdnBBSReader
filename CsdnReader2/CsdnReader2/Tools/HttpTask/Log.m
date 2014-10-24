//
//  Log.m
//  SmartCity
//
//  Created by wyfly on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Log.h"

#ifdef DEBUG
#define LOG_ON
#endif

@implementation Log

+ (void)print:(NSString *)tag msg:(NSString *)fmt, ...
{
#ifdef LOG_ON
    NSString *str;
    va_list args;
    va_start(args, fmt);
    str = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    NSLog(@"%@: %@\n",tag,str);
#endif
}

@end
