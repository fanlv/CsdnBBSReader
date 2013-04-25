//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:1955211608
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "NSArray+ShareSDK.h"
#import "ShareSDKTypeDef.h"
#import "ShareSDKEventHandlerDef.h"
#import "ShareSDKDef.h"
#import "ISSAuthController.h"
#import "ISSAuthOptions.h"
#import "ISSViewDelegate.h"
#import "ISSPage.h"
#import "ISSContent.h"
#import "ISSShareActionSheet.h"
#import "ISSShareOptions.h"
#import "ISSShareViewDelegate.h"
#import "ISSShareActionSheetItem.h"
#import "ISSOAuth2Credential.h"
#import "ISSOAuthCredential.h"

@interface ShareSDK : NSObject

/**
 *	@brief	注册应用,此方法在应用启动时调用一次并且只能在主线程中调用。
 *
 *	@param 	appKey 	应用Key,在ShareSDK官网中注册的应用Key
 */
+ (void)registerApp:(NSString *)appKey;

/**
 *	@brief	注册应用,此方法在应用启动时调用一次
 *
 *  @since  ver1.2.4
 *
 *	@param 	appKey 	应用Key
 *  @param  statDeviceEnabled   统计设备使能
 *  @param  statUserEnabled     统计用户使能
 *  @param  statShareEnabled    统计分享使能
 */
+ (void)registerApp:(NSString *)appKey
  statDeviceEnabled:(BOOL)statDeviceEnabled
    statUserEnabled:(BOOL)statUserEnabled
   statShareEnabled:(BOOL)statShareEnabled;

#pragma mark 设置

/**
 *	@brief	设置统计设备信息使能状态, 默认为YES
 *
 *	@param 	enabled 	使能状态
 */
+ (void)statDeviceEnabled:(BOOL)enabled;

/**
 *	@brief	设置统计用户信息使能状态，默认为YES
 *
 *	@param 	enabled 	使能状态
 */
+ (void)statUserEnabled:(BOOL)enabled;

/**
 *	@brief	设置统计分享信息使能状态，默认为YES
 *
 *	@param 	enabled 	使能状态
 */
+ (void)statShareEnabled:(BOOL)enabled;

/**
 *	@brief	SSO登录方式使能
 *
 *	@param 	ssoEnabled 	YES表示使用SSO方式登录，NO表示不使用SSO方式登录，默认为YES
 */
+ (void)ssoEnabled:(BOOL)ssoEnabled;

/**
 *	@brief	转换URL链接，YES：表示转换链接。NO：表示不转换链接，设置不转换链接后分享内容中的链接将不纳入回流统计中。
 *
 *	@param 	convertUrlEnabled 	YES表示转换短链，NO表示不转换，默认为YES
 */
+ (void)convertUrlEnabled:(BOOL)convertUrlEnabled;


#pragma mark 初始化

/**
 *	@brief	连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
 *          http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址,无回调页面或者不需要返回回调时可以填写新浪默认回调页面：https://api.weibo.com/oauth2/default.html
 *                          但新浪开放平台中应用的回调地址必须填写此值
 */
+ (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
 *          http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址，此地址则为应用地址。
 */
+ (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                          redirectUri:(NSString *)redirectUri;


/**
 *	@brief	连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
 *          http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
+ (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret;

/**
 *	@brief	连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
 *          http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
+ (void)connect163WeiboWithAppKey:(NSString *)appKey
                        appSecret:(NSString *)appSecret
                      redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接搜狐微博应用以使用相关功能，此应用需要引用SohuWeiboConnection.framework
 *          http://open.t.sohu.com上注册搜狐微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	consumerKey 	消费者Key
 *	@param 	consumerSecret 	消费者密钥
 */
+ (void)connectSohuWeiboWithConsumerKey:(NSString *)consumerKey
                         consumerSecret:(NSString *)consumerSecret;

/**
 *	@brief	连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
 *          http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
+ (void)connectDoubanWithAppKey:(NSString *)appKey
                      appSecret:(NSString *)appSecret
                    redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
 *          http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
+ (void)connectRenRenWithAppKey:(NSString *)appKey
                      appSecret:(NSString *)appSecret;

/**
 *	@brief	连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
 *          http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址
 */
+ (void)connectKaiXinWithAppKey:(NSString *)appKey
                      appSecret:(NSString *)appSecret
                    redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接Instapaper应用以使用相关功能，此应用需要引用InstapaperConnection.framework
 *          http://www.instapaper.com/main/request_oauth_consumer_token上注册Instapaper应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
+ (void)connectInstapaperWithAppKey:(NSString *)appKey
                          appSecret:(NSString *)appSecret;

/**
 *	@brief	连接有道云笔记应用以使用相关功能，此应用需要引用YouDaoNoteConnection.framework
 *          http://note.youdao.com/open/developguide.html#app上注册应用，并将相关信息填写到以下字段
 *
 *	@param 	consumerKey 	消费者Key
 *	@param 	consumerSecret 	消费者密钥
 *	@param 	redirectUri 	回调地址
 */
+ (void)connectYouDaoNoteWithConsumerKey:(NSString *)consumerKey
                          consumerSecret:(NSString *)consumerSecret
                             redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
 *          https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
+ (void)connectFacebookWithAppKey:(NSString *)appKey
                        appSecret:(NSString *)appSecret;

/**
 *	@brief	连接Twitter应用以使用相关功能，此应用需要引用TwitterConnection.framework
 *          https://dev.twitter.com上注册应用，并将相关信息填写到以下字段
 *
 *	@param 	consumerKey 	消费者Key
 *	@param 	consumerSecret 	消费者密钥
 *	@param 	redirectUri 	回调地址
 */
+ (void)connectTwitterWithConsumerKey:(NSString *)consumerKey
                       consumerSecret:(NSString *)consumerSecret
                          redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
 *          http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
 *
 *	@param 	appId 	应用ID
 *	@param 	qqApiCls 	QQApi类型
 */
+ (void)connectQQWithAppId:(NSString *)appId
                  qqApiCls:(Class)qqApiCls;

/**
 *	@brief	连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
 *          http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
 *
 *	@param 	appId 	应用ID
 *	@param 	wechatCls 	微信Api类型
 */
+ (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls;

/**
 *	@brief	处理请求打开链接,如果集成新浪微博(SSO)、Facebook(SSO)、微信、QQ分享功能需要加入此方法
 *
 *	@param 	url 	链接
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *	@return	YES 表示接受请求 NO 表示不接受
 */
+ (BOOL)handleOpenURL:(NSURL *)url wxDelegate:(id)wxDelegate;


/**
 *	@brief	处理请求打开链接,如果集成新浪微博(SSO)、Facebook(SSO)、微信、QQ分享功能需要加入此方法
 *
 *	@param 	url 	链接
 *	@param 	sourceApplication 	源应用
 *	@param 	annotation 	源应用提供的信息
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *	@return	YES 表示接受请求，NO 表示不接受请求
 */
+ (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate;

#pragma mark 辅助

/**
 *	@brief	获取平台客户端名称
 *
 *  @since  ver1.2.4
 *
 *	@param 	type 	分享类型
 *
 *	@return	名称
 */
+ (NSString *)getClientNameWithType:(ShareType)type;

/**
 *	@brief	获取平台客户端图标
 *
 *  @since  ver1.2.4
 *
 *	@param 	type 	分享类型
 *
 *	@return	图标
 */
+ (UIImage *)getClientIconWithType:(ShareType)type;

/**
 *	@brief	获取平台客户端
 *
 *	@param 	type 	分享类型
 *
 *	@return	平台客户端
 */
+ (id<ISSCOpenApp>)getClientWithType:(ShareType)type;

/**
 *	@brief	获取分享列表
 *
 *	@param 	shareType 	社会化平台类型
 *
 *	@return	分享列表
 */
+ (NSArray *)getShareListWithType:(ShareType)shareType, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *	@brief	添加通知监听
 *
 *	@param 	name 	通知名称
 *	@param 	target 	目标对象
 *	@param 	action 	处理方法
 */
+ (void)addNotificationWithName:(NSString *)name
                         target:(id)target
                         action:(SEL)action;

/**
 *	@brief	移除通知监听
 *
 *	@param 	name 	通知名称
 *	@param 	target 	目标对象
 */
+ (void)removeNotificationWithName:(NSString *)name
                            target:(id)target;

/**
 *	@brief	移除全部通知监听
 *
 *	@param 	target 	目标对象
 */
+ (void)removeAllNotificationWithTarget:(id)target;

/**
 *	@brief	创建分页对象,为提供获取关注用户列表中的page参数提供的构造方法
 *
 *	@param 	cursor 	分页游标，目前此方法仅用于Twitter，获取起始页请传入-1
 *
 *	@return 分页对象
 */
+ (id<ISSPage>)pageWithCursor:(long long)cursor;

/**
 *	@brief	创建分页对象,为提供获取关注用户列表中的page参数提供的构造方法
 *
 *	@param 	pageNo 	页码
 *	@param 	pageSize 	分页尺寸
 *
 *	@return	分页对象
 */
+ (id<ISSPage>)pageWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize;

/**
 *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
 *
 *	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
 *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
 *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝）
 *	@param 	title 	标题（QQ空间、人人、微信、QQ）
 *	@param 	url 	链接（QQ空间、人人、instapaper、微信、QQ）
 *	@param 	description 	主体内容（人人）
 *	@param 	mediaType 	分享类型（QQ、微信）
 *
 *	@return	分享内容对象
 */
+ (id<ISSContent>)content:(NSString *)content
           defaultContent:(NSString *)defaultContent
                    image:(id<ISSCAttachment>)image
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                mediaType:(SSPublishContentMediaType)mediaType;

/**
 *	@brief	获取图片信息
 *
 *	@param 	path 	图片路径
 *
 *	@return 图片信息
 */
+ (id<ISSCAttachment>)imageWithPath:(NSString *)path;

/**
 *	@brief	创建JPEG图片信息
 *
 *	@param 	image 	图片对象
 *  @param  quality 图片质量
 *
 *	@return	图片信息
 */
+ (id<ISSCAttachment>)jpegImageWithImage:(UIImage *)image quality:(CGFloat)quality;

/**
 *	@brief	创建PNG图片信息
 *
 *	@param 	image 	图片对象
 *
 *	@return	图片信息
 */
+ (id<ISSCAttachment>)pngImageWithImage:(UIImage *)image;

/**
 *	@brief	获取图片信息
 *
 *	@param 	data 	图片数据
 *	@param 	fileName 	文件名称
 *	@param 	mimeType 	MIME类型
 *
 *	@return	图片信息
 */
+ (id<ISSCAttachment>)imageWithData:(NSData *)data
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType;

/**
 *	@brief	创建容器对象
 *
 *	@return	容器对象
 */
+ (id<ISSContainer>)container;

/**
 *	@brief	创建自定义分享菜单项
 *
 *  @since  ver1.2.3
 *
 *	@param 	title 	标题
 *	@param 	icon 	图标
 *	@param 	clickHandler 	点击事件处理器
 *
 *	@return	分享菜单项
 */
+ (id<ISSShareActionSheetItem>)shareActionSheetItemWithTitle:(NSString *)title
                                                        icon:(UIImage *)icon
                                                clickHandler:(SSShareActionSheetItemClickHandler)clickHandler;

/**
 *	@brief	创建附件信息,用于设置有道云笔记平台的附件信息。
 *
 *	@param 	data 	附件数据
 *	@param 	mimeType 	附件类型
 *  @param  fileName    附件名称
 *
 *	@return	附件信息
 */
+ (id<ISSCAttachment>)attachmentWithData:(NSData *)data mimeType:(NSString *)mimeType fileName:(NSString *)fileName;

/**
 *	@brief	创建自定义分享列表
 *
 *	@param 	item 分享列表项，可以为包含ShareType的NSNumber类型，也可以为由shareActionSheetItemWithTitle创建的ISSShareActionSheetItem类型对象。
 *
 *	@return	分享列表
 */
+ (NSArray *)customShareListWithType:(id)item, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *	@brief	设置屏幕方向,默认是所有方向
 *
 *	@param 	interfaceOrientationMask 	屏幕方向掩码
 */
+ (void)setInterfaceOrientationMask:(SSInterfaceOrientationMask)interfaceOrientationMask;

/**
 *	@brief	将授权凭证进行序列化
 *
 *	@param 	credential 	序列化凭证
 *
 *	@return	序列化后的数据
 */
+ (NSData *)dataWithCredential:(id<ISSCredential>)credential;

/**
 *	@brief	反序列化数据为授权凭证
 *
 *	@param 	data 	授权凭证序列化后的数据
 *	@param 	type 	类型
 *
 *	@return	授权凭证
 */
+ (id<ISSCredential>)credentialWithData:(NSData *)data type:(ShareType)type;

/**
 *	@brief	将授权源数据转换为授权凭证，通过其他途径获取到的授权数据通过此接口转换为凭证对象传入SDK
 *
 *	@param 	sourceData 	源数据
 *	@param 	type 	类型
 *
 *	@return	授权凭证
 */
+ (id<ISSCredential>)credentialWithSourceData:(NSDictionary *)sourceData type:(ShareType)type;

#pragma mark 授权

/**
 *	@brief	获取授权凭证,凭证中包含accessToken或oauthToken、过期时间等信息
 *
 *	@param 	type 	平台类型
 *
 *	@return	授权凭证
 */
+ (id<ISSCredential>)getCredentialWithType:(ShareType)type;

/**
 *	@brief	设置授权凭证
 *
 *	@param 	credential 	授权凭证
 *	@param 	type 	平台类型
 */
+ (void)setCredential:(id<ISSCredential>)credential type:(ShareType)type;

/**
 *	@brief	创建授权选项
 *
 *	@param 	autoAuth 	自动授权标志，当分享内容时发现授权过期是否委托SDK处理授权问题，YES：表示委托授权， NO：表示不委托授权，需要自己根据返回值进行判断和处理
 *  @param  allowCallback   是否允许授权后回调到服务器，默认为YES，对于没有服务器或者不需要回调服务器的应用可以设置为NO
 *	@param 	authViewStyle 	授权视图样式，参考SSAuthViewStyle枚举类型
 *  @param  viewDelegate    授权视图协议委托，可通过视图委托来实现UI细节调整等。
 *  @param  authManagerViewDelegate     授权管理器视图协议委托。可通过委托实现UI细节调整等。
 *
 *	@return	授权选项
 */
+ (id<ISSAuthOptions>)authOptionsWithAutoAuth:(BOOL)autoAuth
                                allowCallback:(BOOL)allowCallback
                                authViewStyle:(SSAuthViewStyle)authViewStyle
                                 viewDelegate:(id<ISSViewDelegate>)viewDelegate
                      authManagerViewDelegate:(id<ISSViewDelegate>)authManagerViewDelegate;

/**
 *	@brief	创建授权控制器，此方法用于自定义授权页面时使用,可以自由控制授权UI及过程。(注：微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。)
 *
 *	@param 	type 	平台类型
 *
 *	@return	授权会话
 */
+ (id<ISSAuthController>)authorizeController:(ShareType)type;

/**
 *	@brief	显示授权界面，(注：微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。)
 *
 *	@param 	type    社会化平台类型
 *  @param  options 授权选项，如果为nil则表示使用默认设置
 *  @param  result    授权返回事件处理
 */
+ (void)authWithType:(ShareType)type
             options:(id<ISSAuthOptions>)options
              result:(SSAuthEventHandler)result;

/**
 *	@brief	判断是否授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *	@param 	type 	社会化平台类型
 *
 *	@return	YES 已授权； NO 未授权
 */
+ (BOOL)hasAuthorizedWithType:(ShareType)type;

/**
 *	@brief	取消授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *	@param 	type 	社会化平台类型
 */
+ (void)cancelAuthWithType:(ShareType)type;

#pragma mark 用户信息

/**
 *	@brief	获取当前授权用户信息
 *
 *	@param 	shareType 	平台类型
 *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等）,传入nil表示使用默认选项
 *  @param  result  获取用户信息返回事件
 */
+ (void)getUserInfoWithType:(ShareType)shareType
                authOptions:(id<ISSAuthOptions>)authOptions
                     result:(SSGetUserInfoEventHandler)result;

/**
 *	@brief	获取用户信息
 *
 *	@param 	type 	平台类型
 *	@param 	field 	用户信息字段值，用于指定对应用户的标识字段。
 *	@param 	fieldType 	字段类型，标识是用户ID、用户名称
 *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等）,设置未nil则表示采用默认选项
 *  @param  result  获取用户信息返回事件
 */
+ (void)getUserInfoWithType:(ShareType)type
                      field:(NSString *)field
                  fieldType:(SSUserFieldType)fieldType
                authOptions:(id<ISSAuthOptions>)authOptions
                     result:(SSGetUserInfoEventHandler)result;

#pragma mark 关系

/**
 *	@brief	关注用户
 *
 *	@param 	type 	平台类型
 *	@param 	field 	用户信息字段值，用于指定对应用户的标识字段。
 *	@param 	fieldType 	字段类型，标识是用户ID、用户名称
 *	@param 	authOptions 	授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等）,设置未nil则表示采用默认选项
 *  @param  viewDelegate    视图委托对象，对于Facebook的关注用户会弹出视图，该委托则用于派发视图的相关行为通知。非Facebook平台可以传入nil
 *	@param 	result 	关注用户返回事件
 */
+ (void)followUserWithType:(ShareType)type
                     field:(NSString *)field
                 fieldType:(SSUserFieldType)fieldType
               authOptions:(id<ISSAuthOptions>)authOptions
              viewDelegate:(id<ISSViewDelegate>)viewDelegate
                    result:(SSFollowUserEventHandler)result;

/**
 *	@brief	关注微信号
 *
 *	@param 	userData 	二维码数据
 */
+ (void)followWeixinUser:(NSString *)qrCode;

/**
 *	@brief	获取授权用户的关注用户列表
 *
 *	@param 	type 	社会化平台类型
 *	@param 	page 	分页对象
 *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等）,设置未nil则表示采用默认选项
 *	@param 	result 	获取好友列表返回事件
 */
+ (void)getFriendsWithType:(ShareType)type
                      page:(id<ISSPage>)page
               authOptions:(id<ISSAuthOptions>)authOptions
                    result:(SSGetFriendsEventHandler)result;


#pragma mark 分享

/**
 *	@brief	创建默认分享选项
 *
 *	@param 	title 	分享视图标题
 *	@param 	oneKeyShareList 	一键分享列表，如果传入nil，则表示使用默认分享列表
 *	@param 	qqButtonHidden 	QQ分享按钮是否隐藏,如果不隐藏则显示在分享视图的工具栏右侧，默认显示
 *	@param 	wxSessionButtonHidden 	微信好友分享按钮是否隐藏，如果不隐藏则显示在分享视图的工具栏右侧，默认显示
 *	@param 	wxTimelineButtonHidden 	微信朋友圈分享按钮是否隐藏，如果不隐藏则显示在分享视图的工具栏右侧，默认显示
 *	@param 	showKeyboardOnAppear 	分享视图显示时是否同时显示键盘，如果不显示键盘则显示一键分享列表，默认不显示
 *	@param 	shareViewDelegate 	分享视图委托，如果不需要控制视图则传入nil
 *	@param 	friendsViewDelegate 	好友视图委托，如果不需要控制视图则传入nil
 *	@param 	picViewerViewDelegate 	图片查看器视图委托，如果不需要控制视图则传入nil
 *
 *	@return	分享选项
 */
+ (id<ISSShareOptions>)defaultShareOptionsWithTitle:(NSString *)title
                                    oneKeyShareList:(NSArray *)oneKeyShareList
                                     qqButtonHidden:(BOOL)qqButtonHidden
                              wxSessionButtonHidden:(BOOL)wxSessionButtonHidden
                             wxTimelineButtonHidden:(BOOL)wxTimelineButtonHidden
                               showKeyboardOnAppear:(BOOL)showKeyboardOnAppear
                                  shareViewDelegate:(id<ISSShareViewDelegate>)shareViewDelegate
                                friendsViewDelegate:(id<ISSViewDelegate>)friendsViewDelegate
                              picViewerViewDelegate:(id<ISSViewDelegate>)picViewerViewDelegate;

/**
 *	@brief	创建简单分享选项
 *
 *	@param 	title 	分享视图标题
 *	@param 	shareViewDelegate 	分享视图委托，如果不需要控制视图则传入nil
 *
 *	@return	分享选项
 */
+ (id<ISSShareOptions>)simpleShareOptionsWithTitle:(NSString *)title
                                 shareViewDelegate:(id<ISSShareViewDelegate>)shareViewDelegate;

/**
 *	@brief	创建应用推荐分享选项
 *
 *	@param 	title 	分享视图标题
 *	@param 	shareViewDelegate 	分享视图委托，如果不需要控制视图则传入nil
 *
 *	@return	分享选项
 */
+ (id<ISSShareOptions>)appRecommendShareOptionsWithTile:(NSString *)title
                                      shareViewDelegate:(id<ISSShareViewDelegate>)shareViewDelegate;

/**
 *	@brief	分享内容
 *
 *	@param 	content 	内容对象
 *	@param 	type 	平台类型
 *	@param 	authOptions 	授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等）,设置未nil则表示采用默认选项
 *  @param  statusBarTips   状态栏提示
 *	@param 	result 	返回事件
 */
+ (void)shareContent:(id<ISSContent>)content
                type:(ShareType)type
         authOptions:(id<ISSAuthOptions>)authOptions
       statusBarTips:(BOOL)statusBarTips
              result:(SSPublishContentEventHandler)result;

/**
 *	@brief	一键分享内容
 *
 *	@param 	content 	内容对象
 *	@param 	shareList 	平台类型列表（邮件、短信、微信、QQ、打印、拷贝除外）
 *	@param 	authOptions 	授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等）,设置未nil则表示采用默认选项
 *  @param  statusBarTips   状态栏提示
 *	@param 	result 	返回事件
 */
+ (void)oneKeyShareContent:(id<ISSContent>)content
                 shareList:(NSArray *)shareList
               authOptions:(id<ISSAuthOptions>)authOptions
             statusBarTips:(BOOL)statusBarTips
                    result:(SSPublishContentEventHandler)result;

/**
 *	@brief	显示分享视图
 *
 *	@param 	type 	平台类型
 *  @param  container   用于显示分享界面的容器，如果只显示在iPhone客户端可以传入nil。如果需要在iPad上显示需要指定容器。
 *	@param 	content 	分享内容
 *	@param 	statusBarTips 	状态栏提示标识：YES：显示； NO：隐藏
 *	@param 	authOptions 	授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等），默认可传入nil
 *	@param 	shareOptions 	分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
 *	@param 	result 	分享返回事件处理
 */
+ (void)showShareViewWithType:(ShareType)type
                    container:(id<ISSContainer>)container
                      content:(id<ISSContent>)content
                statusBarTips:(BOOL)statusBarTips
                  authOptions:(id<ISSAuthOptions>)authOptions
                 shareOptions:(id<ISSShareOptions>)shareOptions
                       result:(SSPublishContentEventHandler)result;

/**
 *	@brief	显示分享菜单
 *
 *	@param 	container 	用于显示分享界面的容器，如果只显示在iPhone客户端可以传入nil。如果需要在iPad上显示需要指定容器。
 *	@param 	shareList 	平台类型列表
 *	@param 	content 	分享内容
 *  @param  statusBarTips   状态栏提示标识：YES：显示； NO：隐藏
 *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等），默认可传入nil
 *  @param  shareOptions    分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
 *  @param  result  分享返回事件处理
 */
+ (id<ISSShareActionSheet>)showShareActionSheet:(id<ISSContainer>)container
                                      shareList:(NSArray *)shareList
                                        content:(id<ISSContent>)content
                                  statusBarTips:(BOOL)statusBarTips
                                    authOptions:(id<ISSAuthOptions>)authOptions
                                   shareOptions:(id<ISSShareOptions>)shareOptions
                                         result:(SSPublishContentEventHandler)result;

@end
