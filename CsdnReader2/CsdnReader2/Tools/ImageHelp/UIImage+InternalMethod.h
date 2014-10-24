//
//  UIImage+InternalMethod.h
//  TrafficInfoService
//
//  Created by Fan Lv on 14-1-16.
//  Copyright (c) 2014年 FiberHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (InternalMethod)
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;


//将根据所定frame来截取图片
- (UIImage*)MLImageCrop_imageByCropForRect:(CGRect)targetRect;
- (UIImage *)MLImageCrop_fixOrientation;
@end
