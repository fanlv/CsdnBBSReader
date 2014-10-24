//
//  Reply.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-20.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyData : NSObject

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
@property (nonatomic, strong) NSString *topic_extra_infoContent;

@property (nonatomic) BOOL isAuthor;
@property (nonatomic) BOOL isModerator;
@property (nonatomic) int  indexR;

@property (nonatomic, assign) float contentHeight;

@property (nonatomic, assign) float webContentHeight;



@end
