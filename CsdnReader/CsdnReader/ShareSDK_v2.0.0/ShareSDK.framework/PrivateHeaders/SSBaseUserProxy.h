//
//  SSBaseUserProxy.h
//  ShareSDKInterface
//
//  Created by 冯 鸿杰 on 13/3/31.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSBaseCredentialProxy.h"
#import "ShareSDKTypeDef.h"

/**
 *	@brief	用户代理，各平台用户信息的基类代理
 */
@interface SSBaseUserProxy : NSObject
{
@protected
    id _user;
}

/**
 *	@brief	用户信息
 */
@property (nonatomic,readonly) id user;

/**
 *	@brief	授权凭证
 */
@property (nonatomic,retain) SSBaseCredentialProxy *credential;

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	初始化用户代理
 *
 *	@param 	user 	用户信息
 *
 *	@return	用户代理
 */
- (id)initWithUser:(id)user;

/**
 *	@brief	创建用户代理
 *
 *	@param 	user 	用户对象
 *	@param 	shareType 	平台类型
 *
 *	@return	用户代理
 */
+ (SSBaseUserProxy *)userProxyWithUser:(id)user shareType:(ShareType)shareType;


@end
