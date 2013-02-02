//
//  JYTextField.m
//  meetingManager
//
//  Created by kinglate on 13-1-22.
//  Copyright (c) 2013年 joyame. All rights reserved.
//

#import "JYTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation JYTextField

- (id)initWithFrame:(CGRect)frame
		cornerRadio:(CGFloat)radio
		borderColor:(UIColor*)bColor
		borderWidth:(CGFloat)bWidth
		 lightColor:(UIColor*)lColor
		  lightSize:(CGFloat)lSize
   lightBorderColor:(UIColor*)lbColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _borderColor = bColor;
		_cornerRadio = radio;
		_borderWidth = bWidth;
		_lightColor = lColor;
		_lightSize = lSize;
		_lightBorderColor = lbColor;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
		[self.layer setCornerRadius:_cornerRadio];
		[self.layer setBorderColor:_borderColor.CGColor];
		[self.layer setBorderWidth:_borderWidth];
		[self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[self setBackgroundColor:[UIColor whiteColor]];
		[self.layer setMasksToBounds:NO];
    }
    return self;
}

- (void)beginEditing:(NSNotification*) notification
{
	[[self layer] setShadowOffset:CGSizeMake(0, 0)];
    [[self layer] setShadowRadius:_lightSize];
    [[self layer] setShadowOpacity:1];
    [[self layer] setShadowColor:_lightColor.CGColor];
	[self.layer setBorderColor:_lightBorderColor.CGColor];
}

- (void)endEditing:(NSNotification*) notification
{
	[[self layer] setShadowOffset:CGSizeZero];
    [[self layer] setShadowRadius:0];
    [[self layer] setShadowOpacity:0];
    [[self layer] setShadowColor:nil];
	[self.layer setBorderColor:_borderColor.CGColor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	CGRect inset = CGRectMake(bounds.origin.x + _cornerRadio*2,
							  bounds.origin.y,
							  bounds.size.width - _cornerRadio*2,
							  bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	CGRect inset = CGRectMake(bounds.origin.x + _cornerRadio*2,
							  bounds.origin.y,
							  bounds.size.width - _cornerRadio*2,
							  bounds.size.height);
    return inset;
}
@end
