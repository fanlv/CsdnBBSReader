//
//  JYTextField.h
//  meetingManager
//
//  Created by kinglate on 13-1-22.
//  Copyright (c) 2013年 joyame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYTextField : UITextField
{
	CGFloat _cornerRadio;
	UIColor *_borderColor;
	CGFloat _borderWidth;
	UIColor *_lightColor;
	CGFloat _lightSize;
	UIColor *_lightBorderColor;
}
- (id)initWithFrame:(CGRect)frame
		cornerRadio:(CGFloat)radio
		borderColor:(UIColor*)bColor
		borderWidth:(CGFloat)bWidth
		 lightColor:(UIColor*)lColor
		  lightSize:(CGFloat)lSize
   lightBorderColor:(UIColor*)lbColor;
@end
