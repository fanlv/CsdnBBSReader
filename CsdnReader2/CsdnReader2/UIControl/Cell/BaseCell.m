//
//  BaseCell.m
//  Droponto
//
//  Created by Fan Lv on 14-4-16.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}



- (void)initView
{
    
}

-(void)setUpCellWithData:(id)data
{
    NSLog(@"do nothing");
}

@end
