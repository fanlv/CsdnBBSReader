//
//  FLNavigationBar.m
//  Droponto
//
//  Created by Fan Lv on 14-4-29.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "FLNavigationBar.h"
#import "GlobalData.h"




#define BUTTON_WIDTH  31
#define BUTTON_HEIGHT 31



#define NavgationBarDefaultStyle_BGColor            Light_White_Color
#define NavgationBarDefaultStyle_TextColor          RGB(255,255,255)
#define NavgationBarDefaultStyle_BackImg            [UIImage imageNamed:@"nav_bar_back"]
#define NavgationBarDefaultStyle_BgImg              [UIImage imageNamed:@"nav_bg"]

#define NavgationBarBlackStyle_BGColor              Light_Black_Color
#define NavgationBarBlackStyle_TextColor            [UIColor whiteColor]
#define NavgationBarBlackStyle_BackImg              Nav_Bar_BackImgWhite
#define NavgationBarBlackStyle_BgImg                nil



@interface FLNavigationBar()
{
    UIImageView *bgImgView;
    float totalHeight;
    UIView *statusBarView;
}

@end



@implementation FLNavigationBar

@synthesize leftBtn,rightBtn;



- (void)setBackBtnTitle:(NSString *)backBtnTitle
{
    _backBtnTitle = backBtnTitle;
    [self setLeftButtonWithTitle:backBtnTitle btnBG:nil action:self selector:@selector(gotoback)];
}

- (void)gotoback
{
//    UIViewController *vc= [[UIViewController alloc] init];
//    [vc.navigationController popViewControllerAnimated:YES];
//    id navigationController = [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoBack)])
    {
        [self.delegate gotoBack];
    }
    
    UIViewController *vc = (UIViewController *)[self.superview nextResponder];
    [vc.navigationController popViewControllerAnimated:YES];

 
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleBtn.title = title;
}

- (void)setBarStyle:(FLNavigationBarStyle)barStyle
{
    if (barStyle == FLNavigationBarBlack)
    {
        self.backgroundColor =  NavgationBarBlackStyle_BGColor;
        leftBtn.image = NavgationBarBlackStyle_BackImg;
        statusBarView.backgroundColor = NavgationBarBlackStyle_BGColor;
        self.titleBtn.textColor = NavgationBarBlackStyle_TextColor;
        bgImgView.image = NavgationBarBlackStyle_BgImg;

    }
    else
    {
        self.backgroundColor =  NavgationBarDefaultStyle_BGColor;
        leftBtn.image = NavgationBarDefaultStyle_BackImg;
        statusBarView.backgroundColor = [UIColor blackColor];
        self.titleBtn.textColor = NavgationBarDefaultStyle_TextColor;
        bgImgView.image = NavgationBarDefaultStyle_BgImg;

    }
    _barStyle = barStyle;
    
}




-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        totalHeight = frame.size.height;
        self.backgroundColor =  NavgationBarDefaultStyle_BGColor;
        bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width, totalHeight)];
        bgImgView.userInteractionEnabled=YES;
        bgImgView.exclusiveTouch=YES;
        bgImgView.image = NavgationBarDefaultStyle_BgImg;

        [self addSubview:bgImgView];
        
        self.titleBtn = [[FLImageTitleButton alloc] initWithFrame:CGRectMake(80, 0,frame.size.width-160, totalHeight)];
        self.titleBtn.txtLabel.font = MAX_FONT;
        self.titleBtn.txtLabel.shadowColor = [GlobalData getColor:@"b36900"];
        self.titleBtn.txtLabel.shadowOffset = CGSizeMake(1, 0);
        self.titleBtn.txtLabel.textAlignment = NSTextAlignmentCenter;
        self.titleBtn.backgroundColor = [UIColor clearColor];
        self.titleBtn.textColor = NavgationBarDefaultStyle_TextColor;
        self.titleBtn.isTextAlignCenter = YES;
        self.titleBtn.btnType = FLButtonTypeTitleLeftImageRight;
        [self.titleBtn addTarget:self action:@selector(midButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.titleBtn];
        
        
        
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.frame.size.width, 20)];
        statusBarView.backgroundColor = [UIColor blackColor];
        [self addSubview:statusBarView];
        
        self.barStyle = FLNavigationBarWhite;
    }
    return self;
}

//添加并设置左侧按钮，默认显示的图片是“返回图片”
-(FLImageTitleButton *)setLeftButtonWithTitle:(NSString*)title btnBG:(UIImage *)bgImg action:(id)target selector:(SEL)sel
{
    leftBtn = [[FLImageTitleButton alloc] initWithFrame:CGRectMake(5,5, BUTTON_WIDTH+25,BUTTON_HEIGHT)];
    if ([title length]==0) title = @"返回";
    leftBtn.title = title;
    leftBtn.txtLabel.font = [UIFont systemFontOfSize:16];
    UIImage *defultimg ;
    if(self.barStyle == FLNavigationBarBlack)
    {
        defultimg = NavgationBarBlackStyle_BackImg;
    }
    else
    {
        defultimg = NavgationBarDefaultStyle_BackImg ;
    }
    
    UIImage *img = bgImg ? bgImg:defultimg;
    leftBtn.image = img;
    leftBtn.btnType = FLButtonTypeTitleRightImageLeft;
    [leftBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    return leftBtn;
}

//添加并设置右侧按钮
-(FLImageTitleButton *)setRightButtonWithTitle:(NSString*)title btnBG:(UIImage *)bgImg action:(id)target selector:(SEL)sel
{
    [rightBtn removeFromSuperview];
    rightBtn = nil;
    rightBtn = [FLImageTitleButton buttonWithType:UIButtonTypeCustom];


    CGSize size = [GlobalData getTextSizeWithText:title rect:CGSizeMake(SCREEN_WIDTH, 20) font:MID_FONT2];

    if (size.width < BUTTON_WIDTH) size.width= BUTTON_WIDTH;
    if (size.width > 60) size.width= 60;

    rightBtn.frame = CGRectMake(self.frame.size.width-size.width-5,5, size.width,BUTTON_HEIGHT);
    rightBtn.txtLabel.font = MID_FONT;

    
    if (title)
        rightBtn.title = title;
    UIImage *img = bgImg; //? bgImg:[UIImage imageNamed:@"nav_btn_bg.png"];
    if (img)
    {
        rightBtn.image = img;
    }
    [rightBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];

    
//    if (title)
//        [rightBtn setTitle:title forState:UIControlStateNormal];
//    UIImage *img = bgImg; //? bgImg:[UIImage imageNamed:@"nav_btn_bg.png"];
//    [rightBtn setBackgroundImage:img forState:UIControlStateNormal];
//    [rightBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:rightBtn];
    
    return rightBtn;
}

//设置导航条的背景图片
-(void)setBackgroundImageView:(UIImage*)img
{
    bgImgView.image = img;
    if (img)
    {
        statusBarView.backgroundColor = [self colorAtPixel:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }

    
}


- (void)midButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
//    [self upDateImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleBarCilck:)])
    {
        [self.delegate titleBarCilck:sender];
    }
}



- (UIColor *)colorAtPixel:(CGPoint)point {
    UIImage *img = bgImgView.image;
    
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, img.size.width, img.size.height), point)) {
        return nil;
    }
    
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = img.CGImage;
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, -pointY);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
