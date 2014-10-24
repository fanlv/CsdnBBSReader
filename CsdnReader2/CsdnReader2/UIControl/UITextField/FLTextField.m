//
//  FLTextField.m
//  Droponto
//
//  Created by Fan Lv on 14-4-29.
//  Copyright (c) 2014年 fanlv. All rights reserved.
//

#import "FLTextField.h"

@interface FLTextField ()

@end

@implementation FLTextField
@synthesize placeholderLabel;


- (id)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    placeholderLabel.frame =CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
}


- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeholderLabel.font = font;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    
    [super setTextAlignment:textAlignment];
    placeholderLabel.textAlignment = textAlignment;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    placeholderLabel.hidden = ([text length] >0);

}


- (void)initViews
{
    [self addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];

    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height)];
    placeholderLabel.userInteractionEnabled = NO;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    
    
    [self addSubview:placeholderLabel];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

}

//- (void)textFieldDidChange:(UITextField *)textField
//{
//    placeholderLabel.hidden = ([textField.text length] >0);
//
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    placeholderLabel.hidden = YES;

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    placeholderLabel.hidden = ([textField.text length] >0);
}



////////控制清除按钮的位置
//////-(CGRect)clearButtonRectForBounds:(CGRect)bounds
//////{
//////    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
//////}
//////
////控制placeHolder的位置，左右缩20
//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
////    if (OS_VERSION <7)return bounds;
//    int x = 0;
//    CGFloat y = (bounds.size.height - self.font.pointSize)/2+2;
//    CGRect inset;
//    if (self.textAlignment == NSTextAlignmentCenter)
//    {
//        CGSize size1 = [GlobalData getTextSizeWithText:self.placeholder rect:CGSizeMake(300, 20) font:self.font];
//        inset = CGRectMake((bounds.size.width-size1.width)/2, y, bounds.size.width, bounds.size.height);//更好理解些
//    }
//    else
//    {
//        inset = CGRectMake(x, y, bounds.size.width, bounds.size.height);//更好理解些
//    }
//    return inset;
//}
////控制显示文本的位置
//-(CGRect)textRectForBounds:(CGRect)bounds
//{
//    //return CGRectInset(bounds, 50, 0);
//    CGRect inset = CGRectMake(bounds.origin.x+190, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
//    
//    return inset;
//    
//}
////////控制编辑文本的位置
//////-(CGRect)editingRectForBounds:(CGRect)bounds
//////{
//////    //return CGRectInset( bounds, 10 , 0 );
//////    
//////    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
//////    return inset;
//////}
////////控制左视图位置
//////- (CGRect)leftViewRectForBounds:(CGRect)bounds
//////{
//////    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
//////    return inset;
//////    //return CGRectInset(bounds,50,0);
//////}
//
//////控制placeHolder的颜色、字体
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    [[UIColor whiteColor] setFill];
//    [[self placeholder] drawInRect:rect withFont:self.font];
//}





@end
