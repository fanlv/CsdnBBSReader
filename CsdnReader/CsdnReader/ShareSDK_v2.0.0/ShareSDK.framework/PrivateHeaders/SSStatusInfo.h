//
//  SSStatusInfo.h
//  ShareSDKInterface
//
//  Created by gzsj on 13-4-4.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareSDKTypeDef.h"
#import "ISSStatusInfo.h"

/**
 *	@brief	状态信息
 */
@interface SSStatusInfo : NSObject <ISSStatusInfo>
{
@private
    id _localStatus;
    NSDictionary *_sourceData;
    ShareType _type;
    NSMutableDictionary *_data;
}

/**
 *	@brief	平台相关用户信息
 */
@property (nonatomic,readonly) id localStatus;

/**
 *	@brief	平台类型
 */
@property (nonatomic,readonly) ShareType type;

/**
 *	@brief	状态ID
 */
@property (nonatomic,copy) NSString *sid;

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;


/**
 *	@brief	初始化用户
 *
 *	@param 	localUser 	本地状态信息
 *	@param 	shareType 	分享类型
 *
 *	@return	用户对象
 */
- (id)initWithLocalStatus:(id)localStatus shareType:(ShareType)shareType;


@end
