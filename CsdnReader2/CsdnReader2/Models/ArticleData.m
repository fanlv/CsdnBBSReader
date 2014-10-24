//
//  Article.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "ArticleData.h"
#import "GlobalData.h"



// test github commit


@implementation ArticleData

@synthesize title,point,link,date,author,replycount,lastUpDate,category,titleColor;

@synthesize completeLink = _completeLink;
@synthesize titleHeight = _titleHeight;

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


- (float)titleHeight
{
    if (_titleHeight == 0)
    {
        NSString *articleTitle = [NSString stringWithFormat:@"%@   [%@]",title,category];
        CGSize size = [GlobalData getTextSizeWithText:articleTitle rect:CGSizeMake(SCREEN_WIDTH - 20, 20) font:MID_FONT];
        _titleHeight = size.height;
        
        if (_titleHeight < 25)
        {
            _titleHeight = 25;
        }
 
    }
    return _titleHeight;
}

@end
