//
//  SSBaseAppProxy.h
//  ShareSDKInterface
//
//  Created by 冯 鸿杰 on 13/3/31.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <AGCommon/CMErrorInfo.h>
#import "ISSAuthController.h"
#import "ISSViewDelegate.h"
#import "SSBaseUserProxy.h"
#import "SSPage.h"
#import "ISSContent.h"
#import "SSContentUnit.h"

/**
 *	@brief	应用代理，各平台应用的基类代理
 */
@interface SSBaseAppProxy : NSObject
{
@protected
    id<ISSCOpenApp> _app;
}

/**
 *	@brief	应用对象
 */
@property (nonatomic,readonly) id<ISSCOpenApp> app;

/**
 *	@brief	授权用户
 */
@property (nonatomic,readonly) id<ISSCAccount> account;

/**
 *	@brief	应用Key
 */
@property (nonatomic,readonly) NSString *appKey;

/**
 *	@brief	平台类型
 */
@property (nonatomic,readonly) ShareType shareType;

/**
 *	@brief	默认授权用户
 */
@property (nonatomic,retain) SSBaseUserProxy *defaultUser;

/**
 *	@brief	应用名称
 */
@property (nonatomic,readonly) NSString *name;

/**
 *	@brief	是否授权
 */
@property (nonatomic,readonly) BOOL hasAuthorized;

/**
 *	@brief	初始化应用代理
 *
 *	@param 	app 	应用
 *
 *	@return	应用代理
 */
- (id)initWithApp:(id<ISSCOpenApp>)app;

/**
 *	@brief	是否支持授权
 *
 *	@return	YES 支持授权，NO 不支持授权
 */
- (BOOL)isSupportAuth;

/**
 *	@brief	授权,子类需要覆写该方法
 *
 *	@return	授权控制器
 */
- (id<ISSAuthController>)authorize;

/**
 *	@brief	注册用户信息
 *
 *	@param 	userProxy 	用户信息代理
 *
 *	@return	YES 表示注册成功， NO 表示注册失败
 */
- (BOOL)registerUser:(SSBaseUserProxy *)userProxy;

/**
 *	@brief	注销用户信息
 *
 *	@param 	userProxy 	用户信息代理
 *
 *	@return	YES 表示注销成功， NO 表示注销失败
 */
- (BOOL)unregisterUser:(SSBaseUserProxy *)userProxy;

/**
 *	@brief	检测用户是否已授权
 *
 *	@param 	error 	错误信息
 *
 *	@return	YES 表示没有授权，NO 表示已授权
 */
- (BOOL)checkUnauthWithError:(id<ICMErrorInfo>)error;

/**
 *	@brief	设置凭证
 *
 *	@param 	credential 	授权凭证信息
 */
- (void)setCredential:(SSBaseCredentialProxy *)credential;

/**
 *	@brief	获取需要显示的错误提示
 *
 *	@param 	error 	错误信息对象
 *
 *	@return	错误提示，为nil则表示不需要提示
 */
- (NSString *)getDisplayErrorTips:(id<ICMErrorInfo>)error;

/**
 *	@brief	显示默认授权用户信息
 *
 *  @param  result  回调方法
 */
- (void)showMe:(void(^)(BOOL result, SSBaseUserProxy *userProxy, CMErrorInfo *error))result;

/**
 *	@brief	获取用户信息
 *
 *	@param 	field 	标识字段值
 *	@param 	fieldType 	标识字段类型
 *  @param  result  回调方法
 */
- (void)getUserInfo:(NSString *)field
          fieldType:(SSUserFieldType)fieldType
             result:(void(^)(BOOL result, SSBaseUserProxy *userProxy, CMErrorInfo *error))result;

/**
 *	@brief	关注用户
 *
 *	@param 	field 	标识字段值
 *	@param 	fieldType 	标识字段类型 
 *  @param  viewDelegate    视图委托
 *  @param  result  回调方法
 */
- (void)followUser:(NSString *)field
         fieldType:(SSUserFieldType)fieldType
      viewDelegate:(id<ISSViewDelegate>)viewDelegate
            result:(void(^)(SSResponseState state, SSBaseUserProxy *userProxy, CMErrorInfo *error))result;

/**
 *	@brief	获取我的好友列表
 *
 *	@param 	page 	分页信息
 *	@param 	result 	回调方法
 */
- (void)getMyFriendsWithPage:(SSPage *)page
                      result:(SSGetFriendsEventHandler)result;

/**
 *	@brief	分享内容
 *
 *	@param 	content 	内容单元
 *  @param  container   容器视图控制器
 *  @param  result      返回回调
 */
- (void)shareContent:(SSContentUnit *)content
           container:(UIViewController *)container
              result:(void(^)(SSPublishContentState state, id status, CMErrorInfo *error))result;


@end
