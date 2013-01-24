//
//  Article.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "Article.h"
#import "ConstParameterAndMethod.h"

@implementation Article

@synthesize title,point,link,date,author,replycount,lastUpDate,category,titleColor;

@synthesize completeLink = _completeLink;

- (NSString *)completeLink
{
    if (_completeLink == nil || [_completeLink isEqualToString:@""])
    {
        NSMutableString *mutaleString = [[NSMutableString alloc] init];
        [mutaleString appendString:CSDN_BBS_URL];
        [mutaleString appendString:link];
        _completeLink =[mutaleString copy];
    }

    return _completeLink;
}

@end
