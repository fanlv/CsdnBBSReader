//
//  ArticleTitleCell.h
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-14.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "BaseCell.h"
#import "ArticleData.h"

@interface ArticleTitleCell : BaseCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorAndDateLabel;
@property (strong, nonatomic) UILabel *replyCountLabel;
@property (strong, nonatomic) UILabel *pointLabel;

@end
