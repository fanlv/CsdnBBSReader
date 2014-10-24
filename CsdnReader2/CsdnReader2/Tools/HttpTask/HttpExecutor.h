//
//  HttpExecutor.h
//  SmartWuhan
//
//  Created by 帆 高 on 13-4-27.
//  Copyright (c) 2013年 haoqi. All rights reserved.
//

#import "BaseExecutor.h"
#import "ASIHTTPRequest.h"

@interface HttpExecutor : BaseExecutor<ASIProgressDelegate>
{

}

@property(nonatomic,retain)	NSString* action;
@property(nonatomic,retain) NSString* url;
@property(nonatomic,retain) NSDictionary* body;
@property(nonatomic,retain) NSDictionary* headers;
@property(nonatomic,retain) NSMutableArray *cookieArray;

-(id)initWith:(id<MyTaskDelegate>)del url:(NSString*)strUrl action:(NSString*)strAction body:(NSDictionary*)dataBody header:(NSDictionary*)head cookies:(NSArray *)cookie;

@end
