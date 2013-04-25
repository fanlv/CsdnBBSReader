//
//  SSFacade.h
//  ShareSDKInterface
//
//  Created by 冯 鸿杰 on 13-3-29.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <AGCommon/CMImageCacheManager.h>
#import "ShareSDKTypeDef.h"
#import "ISSAuthController.h"
#import "SSBaseAppProxy.h"
#import "SSStatusInfo.h"
#import "SSStatusBar.h"
#import "SSContainer.h"
#import "SSPopover.h"

/**
 *	@brief	前置器
 */
@interface SSFacade : NSObject
{
@private
    id<ISSCAccount> _account;
    NSMutableDictionary *_openAppDict;
    NSMutableArray *_updataContentQueue;
    SSStatusBar *_statusBar;
    CMImageCacheManager *_imageCacheManager;
    SSPopover *_popover;
    
    BOOL _ssoEnabled;
    BOOL _convertUrlEnabled;
    SSInterfaceOrientationMask _interfaceOrientationMask;   //屏幕方向掩码
}

/**
 *	@brief	图片缓存管理器
 */
@property (nonatomic,readonly) CMImageCacheManager *imageCacheManager;

/**
 *	@brief	授权账号
 */
@property (nonatomic,readonly) id<ISSCAccount> account;

/**
 *	@brief	SSO登录使能
 */
@property (nonatomic) BOOL ssoEnabled;

/**
 *	@brief	转换短链使能
 */
@property (nonatomic) BOOL convertUrlEnabled;


/**
 *	@brief	屏幕方向掩码
 */
@property (nonatomic) SSInterfaceOrientationMask interfaceOrientationMask;

/**
 *	@brief	获取前置器共享实例
 *
 *	@return	前置器对象
 */
+ (SSFacade *)sharedInstance;

/**
 *	@brief	添加更新内容信息缓存
 *
 *	@param 	content 	内容信息
 *  @param  shareTarget 分享目标
 *	@param 	account 	登录账户
 *	@param 	shareType 	分享类型
 *	@param 	contentKey 	内容本地标识
 */
- (void)addUpdateContentCache:(id<ISSContent>)content
                  shareTarget:(NSArray *)shareTarget
                      account:(id<ISSCAccount>)account
                    shareType:(ShareType)shareType
                   contentKey:(NSString *)contentKey;
/**
 *	@brief	删除更新内容信息缓存
 *
 *	@param 	account 	登陆账户
 *	@param 	contentKey 	内容本地标识
 */
- (void)removeUpdateContentCache:(id<ISSCAccount>)account
                      contentKey:(NSString *)contentKey;

/**
 *	@brief	添加统计分享缓存
 *
 *	@param 	shareTargets 	分享目标
 *	@param 	account 	登陆账号
 *	@param 	key 	标识
 */
- (void)addStatShareCache:(NSArray *)shareTargets
                  account:(id<ISSCAccount>)account
                      key:(NSString *)key;

/**
 *	@brief	移除统计分享缓存
 *
 *	@param 	account 	登录账号
 *	@param 	key 	标识
 */
- (void)removeStatShareCache:(id<ISSCAccount>)account
                         key:(NSString *)key;


#pragma mark 内部接口

/**
 *	@brief	更新用户信息
 *
 *	@param 	userInfo 	用户信息
 *	@param 	account 	授权帐户
 *  @param  shareType   平台类型
 *  @param  userKey     本地用户标识
 */
- (void)updateUserInfo:(id<ISSUserInfo>)userInfo
               account:(id<ISSCAccount>)account
             shareType:(ShareType)shareType
               userKey:(NSString *)userKey;

/**
 *	@brief	更新内容信息
 *
 *	@param 	account 	授权账户
 *  @param  contentKey  本地内容标识
 */
- (void)updateContent:(id<ISSCAccount>)account
           contentKey:(NSString *)contentKey;

/**
 *	@brief	触发事件日志
 *
 *	@param 	eventId 	事件ID
 *	@param 	attributes 	属性
 *  @param  account     授权账户
 */
- (void)eventLog:(NSString *)eventId
      attributes:(NSDictionary *)attributes
         account:(id<ISSCAccount>)account;

/**
 *	@brief	添加分享次数
 *
 *	@param 	shareTargets 	分享目标
 *	@param 	account 	授权账户
 *	@param 	key 	标识
 */
- (void)addShareTimes:(NSArray *)shareTargets
              account:(id<ISSCAccount>)account
                  key:(NSString *)key;

/**
 *	@brief	准备发送
 *
 *	@param 	contents 	内容集合
 *  @param  account     授权帐户
 *  @param  result  返回事件
 *
 *	@return	YES 正在转换链接，NO 无法转换链接
 */
- (BOOL)prepare:(NSArray *)contents
        account:(id<ISSCAccount>)account
         result:(void (^)(BOOL result, id<ICMErrorInfo> error))result;
        

#pragma mark 辅助

/**
 *	@brief	获取开放应用代理
 *
 *	@param 	shareType 	分享类型
 *
 *	@return	开放应用代理
 */
- (SSBaseAppProxy *)getOpenAppProxyWithType:(ShareType)shareType;

/**
 *	@brief	根据分享类型获取开放平台应用
 *
 *	@param 	shareType 	分享类型
 *
 *	@return	开放平台应用对象，此对象为各个连接器对象，可根据每个Connection框架中的定义来进行操作
 */
- (id<ISSCOpenApp>)getOpenAppWithType:(ShareType)shareType;

/**
 *	@brief	获取客户端名称
 *
 *	@param 	shareType 	平台类型
 *
 *	@return	名称
 */
- (NSString *)getOpenAppNameWithType:(ShareType)shareType;

/**
 *	@brief	获取统计时的客户端名称
 *
 *	@param 	shareType 	平台类型
 *
 *	@return	名称
 */
- (NSString *)getStatOpenAppNameWithType:(ShareType)shareType;


/**
 *	@brief	获取客户端图标
 *
 *  @since  ver1.2.4
 *
 *	@param 	shareType 	分享类型
 *
 *	@return	图标
 */
- (UIImage *)getOpenAppIconWithType:(ShareType)shareType;

/**
 *	@brief	允许旋转屏幕方向
 *
 *	@param 	toInterfaceOrientation 	目标屏幕方向
 *
 *	@return	YES 表示允许旋转, NO 不允许。
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

/**
 *	@brief	获取容器视图控制器
 *
 *	@return	视图控制器
 */
- (UIViewController *)getContainerViewController;

/**
 *	@brief	添加立即显示状态栏消息
 *
 *	@param 	message 	消息内容
 *	@param 	icon 	图标
 *	@param 	loading 	是否显示等待提示
 */
- (void)addStatusBarImmediMessage:(NSString *)message
                             icon:(UIImage *)icon
                          loading:(BOOL)loading;

/**
 *	@brief	显示永久状态栏消息
 *
 *	@param 	message 	消息内容
 *	@param 	icon 	图标
 *	@param 	loading 	是否显示等待提示
 */
- (void)showStatusBarAlwaysMessage:(NSString *)message
                              icon:(UIImage *)icon
                           loading:(BOOL)loading;

/**
 *	@brief	隐藏永久状态栏消息
 */
- (void)hideStatusBarAlwaysMessage;

/**
 *	@brief	获取错误提示
 *
 *	@param 	error 	错误对象
 *  @param  shareType   平台类型
 *
 *	@return	错误提示
 */
- (NSString *)getErrorTips:(id<ICMErrorInfo>)error shareType:(ShareType)shareType;

/**
 *	@brief	获取默认用户信息
 *
 *	@param 	shareType 	平台类型
 *
 *	@return	默认用户信息
 */
- (id<ISSUserInfo>)defaultUserInfoWithType:(ShareType)shareType;

/**
 *	@brief	创建弹出窗口管理器
 *
 *	@param 	container 	容器
 *	@param 	shareList 	分享列表
 *  @param  clickHandler    点击菜单项事件
 *  @param  cancelHandler   取消事件
 */
- (SSPopover *)popoverWithContainer:(SSContainer *)container
                          ShareList:(NSArray *)shareList
                       clickHandler:(void(^)(id item))clickHandler
                      cancelHandler:(void(^)())cancelHandler;

/**
 *	@brief	创建授权凭证
 *
 *	@param 	sourceData 	授权源数据
 *	@param 	type 	类型
 *
 *	@return	授权凭证
 */
- (id<ISSCredential>)credential:(NSDictionary *)sourceData type:(ShareType)type;

#pragma mark 授权

/**
 *	@brief	获取授权凭证
 *
 *	@param 	type 	类型
 *
 *	@return	授权凭证
 */
- (id<ISSCredential>)getCredentialType:(ShareType)type;

/**
 *	@brief	设置授权凭证
 *
 *	@param 	credential 	凭证
 *	@param 	type 	类型
 */
- (void)setCredential:(id<ISSCredential>)credential type:(ShareType)type;

/**
 *	@brief	创建授权控制器，此方法用于自定义授权页面时使用,可以自由控制授权UI及过程。(注：微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。)
 *
 *	@param 	type 	平台类型
 *
 *	@return	授权会话
 */
- (id<ISSAuthController>)authorizeController:(ShareType)type;

/**
 *	@brief	判断支持授权
 *
 *	@return	YES 支持授权，NO 不支持授权
 */
- (BOOL)isSupportAuth:(ShareType)type;


/**
 *	@brief	判断是否授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *	@param 	type 	社会化平台类型
 *
 *	@return	YES 已授权； NO 未授权
 */
- (BOOL)hasAuthorizedWithType:(ShareType)type;

/**
 *	@brief	取消授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *	@param 	type 	社会化平台类型
 */
- (void)cancelAuthWithType:(ShareType)type;

/**
 *	@brief	检查应用是否尚未授权
 *
 *	@param 	type 	平台类型
 *	@param 	error 	错误信息
 *
 *	@return	YES 尚未授权，NO 已经授权
 */
- (BOOL)checkUnauthWithType:(ShareType)type error:(id<ICMErrorInfo>)error;

#pragma mark 用户信息

/**
 *	@brief	获取默认用户信息
 *
 *	@param 	type 	平台类型
 *	@param 	result 	返回事件
 */
- (void)getDefaultUserInfo:(ShareType)type result:(SSGetUserInfoEventHandler)result;

/**
 *	@brief	获取用户信息
 *
 *  @param  type    平台类型
 *	@param 	field 	用户标识字段值
 *	@param 	fieldType 	用户标识类型
 *	@param 	result 	返回事件
 */
- (void)getUserInfo:(ShareType)type
              field:(NSString *)field
          fieldType:(SSUserFieldType)fieldType
             result:(SSGetUserInfoEventHandler)result;

#pragma mark 关系

/**
 *	@brief	关注用户
 *
 *	@param 	type 	平台类型
 *	@param 	field 	用户标识字段值
 *	@param 	fieldType 	用户标识字段类型
 *  @param  viewDelegate    视图委托
 *	@param 	result 	返回事件
 */
- (void)followUser:(ShareType)type
             field:(NSString *)field
         fieldType:(SSUserFieldType)fieldType
      viewDelegate:(id<ISSViewDelegate>)viewDelegate
            result:(SSFollowUserEventHandler)result;

/**
 *	@brief	获取好友列表
 *
 *	@param 	type 	平台类型
 *	@param 	page 	分页信息
 *	@param 	result 	返回事件
 */
- (void)getMyFriends:(ShareType)type
                page:(SSPage *)page
              result:(SSGetFriendsEventHandler)result;

#pragma mark 分享

/**
 *	@brief	分享内容
 *
 *	@param 	content 	内容单元
 *	@param 	shareType   平台类型
 *	@param 	result 	返回时间
 */
- (void)shareContent:(id<ISSContent>)content
           shareType:(ShareType)shareType
              resutl:(void(^)(SSPublishContentState state, SSStatusInfo *status, CMErrorInfo *error))result;



@end
