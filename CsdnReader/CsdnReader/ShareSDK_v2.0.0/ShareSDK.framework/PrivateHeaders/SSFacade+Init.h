//
//  SSFacade+Init.h
//  ShareSDKInterface
//
//  Created by 冯 鸿杰 on 13/3/30.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import "SSFacade.h"
#import "ShareSDKDef.h"

@interface SSFacade (Init)

/**
 *	@brief	注册应用
 *
 *	@param 	appKey 	应用Key
 */
- (void)registerApp:(NSString *)appKey;


/**
 *	@brief	注册应用
 *
 *	@param 	appKey 	应用Key
 *  @param  statDeviceEnabled   统计设备使能
 *  @param  statUserEnabled     统计用户使能
 *  @param  statShareEnabled    统计分享使能
 */
- (void)registerApp:(NSString *)appKey
  statDeviceEnabled:(BOOL)statDeviceEnabled
    statUserEnabled:(BOOL)statUserEnabled
   statShareEnabled:(BOOL)statShareEnabled;

/**
 *	@brief	处理请求打开链接
 *
 *	@param 	url 	链接
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *	@return	YES 表示接受请求 NO 表示不接受
 */
- (BOOL)handleOpenURL:(NSURL *)url wxDelegate:(id)wxDelegate;


/**
 *	@brief	处理请求打开链接
 *
 *	@param 	url 	链接
 *	@param 	sourceApplication 	源应用
 *	@param 	annotation 	源应用提供的信息
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *	@return	YES 表示接受请求，NO 表示不接受请求
 */
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate;

/**
 *	@brief	连接新浪微博应用，此应用需要引用SinaWeiboConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接腾讯微博应用，此应用需要引用TencentWeiboConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                          redirectUri:(NSString *)redirectUri;
/**
 *	@brief	连接QQ空间应用，此应用需要引用QZoneConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
- (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret;
/**
 *	@brief	连接网易微博应用，此应用需要引用T163WeiboConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connect163WeiboWithAppKey:(NSString *)appKey
                        appSecret:(NSString *)appSecret
                      redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接搜狐应用，此应用需要引用SohuWeiboConnection.framework
 *
 *	@param 	consumerKey 	消费者Key
 *	@param 	consumerSecret 	消费者密钥
 */
- (void)connectSohuWeiboWithConsumerKey:(NSString *)consumerKey
                         consumerSecret:(NSString *)consumerSecret;

/**
 *	@brief	连接豆瓣应用，此应用需要引用DouBanConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connectDoubanWithAppKey:(NSString *)appKey
                      appSecret:(NSString *)appSecret
                    redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接人人网应用，此应用需要引用RenRenConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
- (void)connectRenRenWithAppKey:(NSString *)appKey
                      appSecret:(NSString *)appSecret;

/**
 *	@brief	连接开心网应用，此应用需要引用KaiXinConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connectKaiXinWithAppKey:(NSString *)appKey
                      appSecret:(NSString *)appSecret
                    redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接Instapaper应用，此应用需要引用InstapaperConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
- (void)connectInstapaperWithAppKey:(NSString *)appKey
                          appSecret:(NSString *)appSecret;


/**
 *	@brief	连接有道云笔记应用，此应用需要引用YouDaoNoteConnection.framework
 *
 *	@param 	consumerKey 	消费者Key
 *	@param 	consumerSecret 	消费者密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connectYouDaoNoteWithConsumerKey:(NSString *)consumerKey
                          consumerSecret:(NSString *)consumerSecret
                             redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接Facebook应用，此应用需要引用FacebookConnection.framework
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
- (void)connectFacebookWithAppKey:(NSString *)appKey
                        appSecret:(NSString *)appSecret;

/**
 *	@brief	连接Twitter应用，此应用需要引用TwitterConnection.framework
 *
 *	@param 	consumerKey 	消费者Key
 *	@param 	consumerSecret 	消费者密钥
 *	@param 	redirectUri 	回调地址
 */
- (void)connectTwitterWithConsumerKey:(NSString *)consumerKey
                       consumerSecret:(NSString *)consumerSecret
                          redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接QQ应用，此应用需要引用QQConnection.framework和QQApi.framework库
 *
 *	@param 	appId 	应用ID
 *	@param 	qqApiCls 	QQApi类型
 */
- (void)connectQQWithAppId:(NSString *)appId
                  qqApiCls:(Class)qqApiCls;

/**
 *	@brief	连接微信应用，
 *
 *	@param 	appId 	应用ID
 *	@param 	wechatCls 	微信Api类型
 */
- (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls;

/**
 *	@brief	连接邮件
 */
- (void)connectMail;

/**
 *	@brief	连接短信
 */
- (void)connectSMS;

/**
 *	@brief	连接打印
 */
- (void)connectPrint;

/**
 *	@brief	连接复制
 */
- (void)connectCopy;


@end
