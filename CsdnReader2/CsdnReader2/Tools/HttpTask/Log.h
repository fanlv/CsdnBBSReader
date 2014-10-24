//
//  Log.h
//  SmartCity
//
//  Created by wyfly on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log : NSObject
+(void)print:(NSString*)tag msg:(NSString*)fmt,...;
@end
