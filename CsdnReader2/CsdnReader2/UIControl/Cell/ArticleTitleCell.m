//
//  ArticleTitleCell.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-14.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "ArticleTitleCell.h"
#import "GlobalData.h"

@implementation ArticleTitleCell

@synthesize titleLabel,pointLabel,replyCountLabel,authorAndDateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}


//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UILabel *authorAndDateLabel;
//@property (strong, nonatomic) UILabel *replyCountLabel;
//@property (strong, nonatomic) UILabel *pointLabel;
- (void)initView
{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = MID_FONT;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    
    authorAndDateLabel = [[UILabel alloc] init];
    authorAndDateLabel.font = MIN_FONT2;
    authorAndDateLabel.textColor = [UIColor lightGrayColor];
    
    replyCountLabel = [[UILabel alloc] init];
    replyCountLabel.font = MIN_FONT2;
    replyCountLabel.textAlignment = NSTextAlignmentRight;
    replyCountLabel.textColor = [UIColor lightGrayColor];
    
    pointLabel = [[UILabel alloc] init];
    pointLabel.font = MIN_FONT2;
    pointLabel.textAlignment = NSTextAlignmentRight;
    pointLabel.textColor = [UIColor lightGrayColor];

    
    [self addSubview:titleLabel];
    [self addSubview:authorAndDateLabel];
    [self addSubview:replyCountLabel];
    [self addSubview:pointLabel];

}

- (void)setUpCellWithData:(id)data
{
    ArticleData *article = (ArticleData *)data;

    titleLabel.frame = CGRectMake(10, 8, SCREEN_WIDTH - 20, article.titleHeight);
    authorAndDateLabel.frame = CGRectMake(10, article.titleHeight + 8, SCREEN_WIDTH - 100, 21);
    
    replyCountLabel.frame =CGRectMake(SCREEN_WIDTH - 10 - 60, article.titleHeight + 8, 60, 21);
    
    pointLabel.frame =  CGRectMake(SCREEN_WIDTH - 10 -120, article.titleHeight + 8, 60, 21);
    
    
    self.titleLabel.text =[NSString stringWithFormat:@"%@   [%@]",article.title,article.category];
    if (article.titleColor != nil)
    {
        NSRange range = [article.titleColor rangeOfString:@"red" options:NSCaseInsensitiveSearch];//判断字符串是否包含
        if (range.location != NSNotFound)
        {
            titleLabel.textColor = [UIColor redColor];
        }
        range = [article.titleColor rangeOfString:@"green" options:NSCaseInsensitiveSearch];//判断字符串是否包含
        if (range.location != NSNotFound)
        {
            titleLabel.textColor = [UIColor greenColor];
        }
        range = [article.titleColor rangeOfString:@"blue" options:NSCaseInsensitiveSearch];//判断字符串是否包含
        if (range.location != NSNotFound)
        {
            titleLabel.textColor = [UIColor blueColor];
        }
    }
    //------显示问题分数
    self.pointLabel.text = [NSString stringWithFormat:@"%@分",article.point];
    //------显示有多少回复
    self.replyCountLabel.text = [NSString stringWithFormat:@"%@回应",article.replycount];
    //------显示发布时间和发布人
    NSString *miunesTime = [GlobalData showMinusTimeWithNoYearDateString:article.date];
    self.authorAndDateLabel.text = [NSString stringWithFormat:@"%@  %@",article.author,miunesTime];
    
}


@end
