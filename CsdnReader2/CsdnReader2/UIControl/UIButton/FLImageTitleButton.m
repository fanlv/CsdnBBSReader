//
//  FLImageTitleButton.m
//  Droponto
//
//  Created by Fan Lv on 14-5-6.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "FLImageTitleButton.h"
#import "GlobalData.h"

@implementation FLImageTitleButton

@synthesize edge;
@synthesize title = _title;

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)txtLabel
{
    if (!_txtLabel)
    {
        _txtLabel = [[UILabel alloc] init];
        self.textColor = [UIColor whiteColor];
        _txtLabel.textColor = self.textColor;
        _txtLabel.font = [UIFont systemFontOfSize:16];
        _txtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_txtLabel];
        
    }
    return _txtLabel;
}

- (void)setBtnType:(FLButtonType)btnType
{
    _btnType = btnType;
    [self setUpViews];
}

- (void)setImageHeight:(float)imageHeight
{
    _imageHeight = imageHeight;
    [self setUpViews];
}

- (void)setImageWidth:(float)imageWidth
{
    _imageWidth = imageWidth;
    [self setUpViews];
}

- (void)setIsTextAlignCenter:(BOOL)isTextAlignCenter
{
    _isTextAlignCenter = isTextAlignCenter;
    [self setUpViews];
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    self.txtLabel.text = _title;
    [self setUpViews];
}

- (NSString *)title
{
    NSString *tt = self.txtLabel.text;
    return tt;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self upDateImage];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setUpViews];
    
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self upDateImage];
    [self setUpViews];
}

- (void)setImageDown:(UIImage *)imageDown
{
    _imageDown = imageDown;
    [self upDateImage];
    [self setUpViews];
}

- (void)upDateImage
{
    if (self.selected && self.imageDown)
    {
        self.imgView.image = self.imageDown;
    }
    else if(self.image)
    {
        self.imgView.image = self.image;
    }
    
    if (self.selected && self.selectdTextColor)
    {
        self.txtLabel.textColor = self.selectdTextColor;
    }
    else
    {
        self.txtLabel.textColor = self.textColor;
    }
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self upDateImage];
}

- (void)setUpViews
{
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    if (!_imageWidth) _imageWidth = self.imgView.image.size.width/2;
    if (!_imageHeight) _imageHeight = self.imgView.image.size.height/2;
    
    
    CGSize size = [GlobalData getTextSizeWithText:_title rect:CGSizeMake(320, 30) font:self.txtLabel.font];
    if (size.width > width) size.width = width;
    if (size.height > height) size.height = height;
    

    
    if (self.btnType == FLButtonTypeTitleDownImageUp)//文字下、图片上
    {
        if (_isTextAlignCenter)
        {
            self.txtLabel.textAlignment = NSTextAlignmentCenter;
            self.imgView.frame = CGRectMake((width -_imageWidth)/2, (height-_imageHeight-size.height)/2, _imageWidth, _imageHeight);
            self.txtLabel.frame = CGRectMake(0,(height+_imageHeight-size.height)/2+edge, width, size.height);
        }
        else
        {
            self.imgView.frame = CGRectMake((width -_imageWidth)/2, 0, _imageWidth, _imageHeight);
            self.txtLabel.frame = CGRectMake(0,self.imageHeight+edge, width, height-_imageHeight);
        }
    }
    else if (self.btnType == FLButtonTypeTitleLeftImageRight)//文字左、图片右
    {
        if (_isTextAlignCenter)
        {
            self.txtLabel.frame = CGRectMake((width - size.width)/2, 0, size.width, height);
            self.imgView.frame = CGRectMake((width+size.width)/2+ edge , (height-_imageHeight)/2, _imageWidth, _imageHeight);
        }
        else
        {
            self.txtLabel.frame = CGRectMake(0, 0, size.width, height);
            self.imgView.frame = CGRectMake(size.width+ edge , (height-_imageHeight)/2, _imageWidth, _imageHeight);
        }
    }
    else if (self.btnType == FLButtonTypeTitleRightImageLeft)//文字右、图片左
    {
        if (_isTextAlignCenter)
        {
            int offsetX = (width - self.imageWidth - size.width)/2.0;
            self.imgView.frame = CGRectMake(offsetX, (height- _imageHeight)/2, _imageWidth, _imageHeight);
            self.txtLabel.frame = CGRectMake(offsetX + self.imageWidth+edge, 0, width-self.imageWidth-edge, height);
            self.txtLabel.textAlignment = NSTextAlignmentLeft;
            
        }
        else
        {
            self.imgView.frame = CGRectMake(0, (height- _imageHeight)/2, _imageWidth, _imageHeight);
            self.txtLabel.frame = CGRectMake(self.imageWidth+edge, 0, width-self.imageWidth-edge, height);
        }
        
    }
    else if (self.btnType == FLButtonTypeTitleUpImageDown)//文字上、图片下
    {
        self.imgView.frame = CGRectMake((width -_imageWidth)/2, height-_imageHeight +edge, _imageWidth, _imageHeight);
        self.txtLabel.frame = CGRectMake(0, 0, width, height-_imageHeight);
    }
    
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
	return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpOutside];
    
}

- (void)touchDown
{
    self.alpha = 0.8;
}

- (void)touchUp
{
    self.alpha = 1;
}
@end

















