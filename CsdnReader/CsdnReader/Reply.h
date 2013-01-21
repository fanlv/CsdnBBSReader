//
//  Reply.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-20.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reply : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *closeRate;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *totalTechnicalpoints;
@property (nonatomic, strong) UIView   *imageView;
@property (nonatomic, strong) NSString *rawContents;




@end
