//
//  FLAsyncImageView.h
//  Droponto
//
//  Created by Fan Lv on 14-5-6.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//


/*
 
 */





#import <UIKit/UIKit.h>

@class FLAsyncImageView;
@protocol FLAsyncImageViewDelegate <NSObject>

@optional
- (void)viewTouchesEnded:(FLAsyncImageView *)sender;
- (void)downloadProgress:(int)progress;

@end

@interface FLAsyncImageView : UIImageView

///设置图片默认显示的图像
@property (nonatomic, strong) UIImage  *defaultImage;
///是否要缓存该图片在内存中，下次设置想他的url会直接从缓存获取显示
@property (nonatomic, assign) BOOL     isCacheImage;
///是否要下载以后保存缓存文件夹，默认NO
@property (nonatomic, assign) BOOL     isSaveToCacheFolder;

///图片的web-url
@property (nonatomic, strong) NSString *imageUrl;
///是否是圆形显示
@property (nonatomic, assign) BOOL     isCircleShape;
///下载图片的时候是否显示spinner（默认显示）
@property (nonatomic, assign) BOOL     isShowSpinnerWhenDownLoad;



///如果需要同步几个FLAsyncImageView的图像设置syncImgaeTag为一样的值就可以了
@property (nonatomic, assign) int      syncImgaeTag;


///相应图片单机事件和下载进度的delegate
@property (nonatomic,weak) id <FLAsyncImageViewDelegate> delegate;


///上传图片以后更新所有页面显示的LOGO
- (void)updateLocalImage;

///清除本地保存的图片
- (void)clearCache;

///清除缓存的图片
- (void)clearCacheOnly;

///更新缓存图片
- (void)updateCache:(UIImage *)image;

@end
