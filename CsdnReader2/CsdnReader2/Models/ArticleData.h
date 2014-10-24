//
//  Article.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-19.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArticleData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleColor;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *completeLink;

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *replycount;
@property (nonatomic, strong) NSString *lastUpDate;
@property (nonatomic, strong) NSString *category;


@property (nonatomic, assign) float titleHeight;

@end
