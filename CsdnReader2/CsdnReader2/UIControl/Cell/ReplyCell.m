//
//  ReplyCell.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-14.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "ReplyCell.h"


@interface ReplyCell()<UIWebViewDelegate>
{
    UILabel *userInfoLabel;
    UILabel *rowLabel;
    UILabel *replyNmaeLabel;
    UILabel *dateLabel;
    UIWebView *webView;
    FLAsyncImageView *logo;
    UIView *coverView;
    
}


@end


@implementation ReplyCell

@synthesize reply;

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



- (void)initView
{
    dateLabel      = [[UILabel alloc] init];
    webView        = [[UIWebView alloc] initWithFrame:CGRectMake(5, 40 , SCREEN_WIDTH - 10, 60)];
    coverView =    [[UIView alloc] init];
    
    replyNmaeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 120, 21)];
    userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 21, SCREEN_WIDTH - 120, 21)];
    rowLabel =  [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 60, 21)];
    logo = [[FLAsyncImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    logo.isCircleShape = YES;
    logo.isCacheImage = YES;
    logo.defaultImage = [UIImage imageNamed:@"guest"];
    
    rowLabel.textAlignment = NSTextAlignmentRight;
    
    replyNmaeLabel.font = MIN_FONT2;
    userInfoLabel.font = MIN_FONT2;
    rowLabel.font = MIN_FONT2;
    dateLabel.font = MIN_FONT2;
    
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = .1;
    
    
    webView.opaque = NO;
    webView.backgroundColor=[UIColor whiteColor];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    
//    webView.scalesPageToFit = YES ;

    [self addSubview:userInfoLabel];
    [self addSubview:rowLabel];
    [self addSubview:replyNmaeLabel];
    [self addSubview:webView];
    [self addSubview:logo];
    [self addSubview:dateLabel];
//    [self addSubview:coverView];

}

- (void)setUpCellWithData:(id)data
{
    
//    [webView loadHTMLString:@" " baseURL:nil];

    reply = (ReplyData *)data;

    webView.frame = CGRectMake(5, 40 , SCREEN_WIDTH - 10, reply.contentHeight);
    dateLabel.frame = CGRectMake(5, reply.contentHeight + 40 , SCREEN_WIDTH - 10, 21);
    coverView .frame = CGRectMake(SCREEN_WIDTH*3./4, 0 , SCREEN_WIDTH/4 , reply.contentHeight+60);
    
    userInfoLabel.text = [NSString stringWithFormat:@"等级：%@ (排名:%@)",reply.grade,reply.rank];
    NSMutableString *showName = [[NSMutableString alloc] initWithString:reply.name];

    if (reply.indexR == 0)
    {
        rowLabel.text = @"楼主";
        dateLabel.text = [NSString stringWithFormat:@"发表于：%@，%@",reply.date,reply.closeRate];
    }
    else
    {
        rowLabel.text = [NSString stringWithFormat:@"%d楼",reply.indexR];
        dateLabel.text = [NSString stringWithFormat:@"回复于：%@",reply.date];
    }
    replyNmaeLabel.textColor = [UIColor blackColor];
    if (reply.isAuthor)
    {
        [showName appendString:@" (楼主)"];
        replyNmaeLabel.textColor = [UIColor blueColor];
    }
    if (reply.isModerator)
    {
        [showName appendString:@" (版主)"];
        replyNmaeLabel.textColor = [UIColor redColor];
    }
    replyNmaeLabel.text = showName;
    logo.imageUrl = reply.profileImageUrl;

    [webView loadHTMLString:reply.rawContents baseURL:nil];
    

    


}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return navigationType == UIWebViewNavigationTypeOther;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
//    if (reply.webContentHeight == 0)
//    {
//        reply.webContentHeight = fittingSize.height;
//        reply.contentHeight = fittingSize.height;
//        NSLog(@"fittingSize.height: %f",  fittingSize.height);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload123" object:nil];
//    }

    if (reply.contentHeight < fittingSize.height)
    {
        reply.contentHeight = fittingSize.height;
        NSLog(@"fittingSize.height: %f",  fittingSize.height);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload123" object:nil];
    }
    reply.webContentHeight = fittingSize.height;

}





@end
