//
//  FLTextFieldView.h
//  AiLeGuang
//
//  Created by Fan Lv on 14-8-22.
//  Copyright (c) 2014年 oTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTextFieldView : UIView


@property (nonatomic,strong) UITextField     *content;
@property (nonatomic,strong) UILabel         *placeholderLabel;

@property (nonatomic,retain) UIFont          *font;// default is nil. use system font 12 pt
@property (nonatomic       ) NSTextAlignment textAlignment;// default is NSLeftTextAlignment

@end
