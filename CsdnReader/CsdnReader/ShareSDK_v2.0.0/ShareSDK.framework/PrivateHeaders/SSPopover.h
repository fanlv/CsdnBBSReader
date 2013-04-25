//
//  SSPopover.h
//  ShareSDK
//
//  Created by 冯 鸿杰 on 13-4-10.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSShareActionSheet.h"
#import "ISSContainer.h"

/**
 *	@brief	弹出窗口管理器
 */
@interface SSPopover : NSObject <ISSShareActionSheet,
                                 UIPopoverControllerDelegate>
{
@private
    UIPopoverController *_containerController;
    
    id<ISSContainer> _container;
    BOOL _hasItemClick;                 //如果已经点击列表项则为YES,用于判断是取消选择还是选择列表项。
    NSArray *_shareList;
    id _clickHandler;
    id _cancelHandler;
    BOOL _retainSelf;
}

/**
 *	@brief	初始化弹出窗口管理器
 *
 *	@param 	shareList 	分享列表
 *
 *	@return	弹出窗口管理器对象
 */
- (id)initWithShareList:(NSArray *)shareList
           clickHandler:(void(^)(id item))clickHandler
          cancelHandler:(void(^)())cancelHandler;


@end
