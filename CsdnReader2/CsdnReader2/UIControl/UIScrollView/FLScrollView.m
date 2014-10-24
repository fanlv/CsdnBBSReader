//
//  FLScrollView.m
//  Droponto
//
//  Created by Fan Lv on 14-5-31.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "FLScrollView.h"


@implementation FLScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];

    if (self.tag == 100)
    {
        CGPoint contentOffsetPoint = self.contentOffset;
        CGRect frame = self.frame;
        if (contentOffsetPoint.y == self.contentSize.height - frame.size.height || self.contentSize.height < frame.size.height)
        {

            UITableView *tableView = (UITableView *) [self viewWithTag:101];
            NSLog(@"return UITableView");
            return tableView;
        }
        else
        {
            return  self;
            NSLog(@"return FLScrollView");
            
        }
    }

    
    return result;
}

@end
