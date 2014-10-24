//
//  FLTextFieldView.m
//  AiLeGuang
//
//  Created by Fan Lv on 14-8-22.
//  Copyright (c) 2014年 oTech. All rights reserved.
//

#import "FLTextFieldView.h"

@interface FLTextFieldView ()<UITextFieldDelegate>




@end

@implementation FLTextFieldView

@synthesize content,placeholderLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    content.font = _font;
    placeholderLabel.font = _font;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    content.textAlignment = _textAlignment;
    placeholderLabel.textAlignment = _textAlignment;
    if (_textAlignment == NSTextAlignmentCenter)
    {
        content.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
}


- (void)initViews
{
    content = [[UITextField alloc] initWithFrame:self.bounds];
    content.delegate = self;
    placeholderLabel = [[UILabel alloc] initWithFrame:self.bounds];
    placeholderLabel.userInteractionEnabled = NO;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    
//    [content addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self addSubview:content];
    [self addSubview:placeholderLabel];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    placeholderLabel.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    placeholderLabel.hidden = ([textField.text length] >0);
}

//- (void)textFieldDidChange:(UITextField *)textField
//{
//    placeholderLabel.hidden = ([textField.text length] >0);
//}

@end
