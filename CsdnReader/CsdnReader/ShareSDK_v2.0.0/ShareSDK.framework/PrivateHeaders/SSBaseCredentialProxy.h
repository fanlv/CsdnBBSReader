//
//  SSBaseCredential.h
//  ShareSDKInterface
//
//  Created by 冯 鸿杰 on 13/3/31.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSCredential.h"

/**
 *	@brief	授权凭证代理，各平台用户信息的基类代理
 */
@interface SSBaseCredentialProxy : NSObject <ISSCredential>
{
@protected
    id _credential;
}

/**
 *	@brief	授权凭证
 */
@property (nonatomic,readonly) id localCredential;

/**
 *	@brief	判断授权数据是否有效
 */
@property (nonatomic,readonly) BOOL available;

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	初始化授权代理
 *
 *	@param 	credential 	授权代理
 *
 *	@return	授权代理对象
 */
- (id)initWithCredential:(id)credential;


@end
