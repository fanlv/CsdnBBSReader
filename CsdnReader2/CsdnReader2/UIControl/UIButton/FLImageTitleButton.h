//
//  FLImageTitleButton.h
//  Droponto
//
//  Created by Fan Lv on 14-5-6.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    FLButtonTypeTitleDownImageUp = 0,
    FLButtonTypeTitleUpImageDown = 1,
    FLButtonTypeTitleLeftImageRight = 2,
    FLButtonTypeTitleRightImageLeft = 3
} FLButtonType;

@interface FLImageTitleButton : UIButton

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *txtLabel;



@property (nonatomic,assign) FLButtonType btnType;
@property (nonatomic,assign) float        imageWidth;
@property (nonatomic,assign) float        imageHeight;
@property (nonatomic,assign) int          edge;
@property (nonatomic,strong) NSString     *title;
@property (nonatomic,strong) UIImage      *image;
@property (nonatomic,strong) UIImage      *imageDown;
@property (nonatomic,assign) BOOL         isTextAlignCenter;
@property (nonatomic,strong) UIColor      *selectdTextColor;
@property (nonatomic,strong) UIColor      *textColor;

@end
