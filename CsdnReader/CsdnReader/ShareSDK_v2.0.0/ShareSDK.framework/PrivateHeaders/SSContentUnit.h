//
//  SSContentUnit.h
//  ShareSDKInterface
//
//  Created by gzsj on 13-4-3.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSContent.h"

/**
 *	@brief	内容单元
 */
@interface SSContentUnit : NSObject
{
@private
    NSMutableDictionary *_fields;
@protected
    id<ISSContent> _parentContent;
}

/**
 *	@brief	初始化内容单元
 *
 *	@param 	content 	内容对象
 *
 *	@return	内容单元
 */
- (id)initWithContent:(id<ISSContent>)content;

/**
 *	@brief	获取字段值
 *
 *	@param 	name 	字段名称
 *
 *	@return	字段值
 */
- (id)getFieldValue:(NSString *)name;

/**
 *	@brief	设置字段值
 *
 *	@param 	name 	字段名称
 *	@param 	value 	字段值
 */
- (void)setField:(NSString *)name value:(id)value;

/**
 *	@brief	删除字段
 *
 *	@param 	name 	字段名称
 */
- (void)removeField:(NSString *)name;


@end
