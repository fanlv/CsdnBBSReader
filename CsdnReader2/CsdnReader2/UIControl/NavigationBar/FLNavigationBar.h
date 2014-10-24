//
//  FLNavigationBar.h
//  Droponto
//
//  Created by Fan Lv on 14-4-29.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageTitleButton.h"

typedef enum {
    FLNavigationBarWhite = 0,
    FLNavigationBarBlack = 1,

} FLNavigationBarStyle;

@protocol FLNavigationBarDelegate <NSObject>

@optional
- (void)titleBarCilck:(UIButton *)sender;
- (void)gotoBack;
@end

@interface FLNavigationBar : UIView


@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *backBtnTitle;
@property (nonatomic,assign) FLNavigationBarStyle barStyle;

@property (nonatomic,strong) FLImageTitleButton *leftBtn;
@property (nonatomic,strong) FLImageTitleButton *rightBtn;
@property (nonatomic,strong) FLImageTitleButton *titleBtn;
@property (nonatomic,weak) id <FLNavigationBarDelegate> delegate;


//添加并设置左侧按钮，默认显示的图片是“返回图片”
-(UIButton*)setLeftButtonWithTitle:(NSString*)title btnBG:(UIImage *)bgImg action:(id)target selector:(SEL)sel;

//添加并设置右侧按钮，默认显示的图片是“蓝色背景图片”
-(UIButton*)setRightButtonWithTitle:(NSString*)title btnBG:(UIImage *)bgImg action:(id)target selector:(SEL)sel;

//初始化
-(id)initWithFrame:(CGRect)frame;

//设置导航栏的背景图片，默认是蓝色背景图片
-(void)setBackgroundImageView:(UIImage*)img;



@end
