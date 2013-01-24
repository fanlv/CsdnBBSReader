//
//  ArticleDetailViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-18.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "HTMLParser.h"
#import "SGInfoAlert.h"
#import "CustomPullToRefresh.h"
#import "ConstParameterAndMethod.h"
#import "Reply.h"
#import "AsyncImageView.h"


@interface ArticleDetailViewController () <CustomPullToRefreshDelegate>
{
    NSTimer *showTimer;
}

@property (nonatomic,strong) CustomPullToRefresh *coustomPullToRefresh;
@property (nonatomic) NSInteger page;
@property (nonatomic,strong) NSArray *replyLists;

@end

@implementation ArticleDetailViewController

@synthesize article = _article;
@synthesize coustomPullToRefresh;
@synthesize page;
@synthesize replyLists;

- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    coustomPullToRefresh = [[CustomPullToRefresh alloc] initWithScrollView:self.tableView delegate:self];
    
    
    self.title = self.article.title;
    NSMutableString *articleTitle = [[NSMutableString alloc] initWithString:self.article.title];
    
    [articleTitle appendString:@"   ["];
    [articleTitle appendString:self.article.category];
    [articleTitle appendString:@"]   ["];
    [articleTitle appendString:self.article.point];
    [articleTitle appendString:@"分"];
    [articleTitle appendString:@"]"];
    
    CGFloat tableHeaderHeight = [ConstParameterAndMethod getArticleTitleHeight:articleTitle
                                                            withWidth:self.tableView.frame.size.width
                                                              andFont:[UIFont systemFontOfSize:ARTICLE_TITIE_SIZE]];
    //创建一个视图（_headerView）
    UIView *tableViewHeader= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, tableHeaderHeight)];
    //tableViewHeader.backgroundColor = [UIColor colorWithRed:1.0 green:233/255.0 blue:1.0 alpha:1.0];
    // 创建一个 _headerLabel 用来显示标题
    UILabel *tableHeaderViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, self.tableView.frame.size.width-20, tableHeaderHeight-10)];
    tableHeaderViewLabel.backgroundColor = [UIColor clearColor];
    tableHeaderViewLabel.numberOfLines = 0;
    tableHeaderViewLabel.textColor = [UIColor blackColor];
    tableHeaderViewLabel.font = [UIFont systemFontOfSize:ARTICLE_TITIE_SIZE];
    tableHeaderViewLabel.lineBreakMode = UILineBreakModeWordWrap;
    tableHeaderViewLabel.text = articleTitle;
    [tableViewHeader addSubview:tableHeaderViewLabel];
    
    self.tableView.tableHeaderView = tableViewHeader;
    
    //self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    
}

- (Article *)article
{
    if (_article == nil)
    {
        _article = [[Article alloc] init];
    }
    return _article;
}

- (void)setArticle:(Article *)article
{
    
    _article = article;
    [ConstParameterAndMethod setDataSourceWithWebSiteHtmlWithCookie:article.completeLink andSetDelegate:self];
    
}


#pragma mark - 解析获取的HTML数据





- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    // NSLog(@"1--%@", request.url);
    NSString *responseString = [request responseString];
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        NSString *errorDetail = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        [SGInfoAlert showInfo: [NSString stringWithFormat:@"网络异常: %@",errorDetail]
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view vertical:0.8];
        [coustomPullToRefresh endRefresh];
        return;
    }
    NSMutableArray *replyLisMutableArray ;
    NSUInteger rowCount = 0;
    if (page != 1)
    {
        replyLisMutableArray = [[NSMutableArray alloc] initWithArray:replyLists];
        rowCount = replyLisMutableArray.count;
    }
    else
    {
        replyLisMutableArray = [[NSMutableArray alloc] init];
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *wraper = [bodyNode findChildOfClass:@"wraper"];
    HTMLNode *detailed = [wraper findChildOfClass:@"detailed"];
    NSArray *replyNodes = [detailed findChildTags:@"table"];
    for (HTMLNode *tableNode in replyNodes)
    {
        HTMLNode *trNode = [tableNode findChildTag:@"tr"];
        NSArray *tdNodes = [trNode findChildTags:@"td"];
        HTMLNode *tdNode1 = [tdNodes objectAtIndex:0];
        if ([tdNode1.className isEqualToString:@"wirter"])
        {
            Reply *reply = [[Reply alloc] init];
            //NSLog(@"--------------------------------------------------------------------");
            
            //--------回复时间
            HTMLNode *time = [trNode findChildOfClass:@"time"];
            NSString *timeString = time.allContents;
            timeString = [timeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            timeString = [timeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            timeString = [timeString substringFromIndex:6];
            timeString = [timeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            reply.date = timeString;
            //NSLog(@"回复时间:%@",reply.date);
            
            HTMLNode *dlNode = [tdNode1 findChildTag:@"dl"];
            //-------回复人图片Url
            HTMLNode *dtNode = [dlNode findChildTag:@"dt"];
            HTMLNode *imgNode = [dtNode findChildTag:@"img"];
            reply.profileImageUrl = [imgNode getAttributeNamed:@"src"];
            
            reply.profileImageUrl = [reply.profileImageUrl stringByReplacingOccurrencesOfString:@"/1_" withString:@"/3_"];
            //NSLog(@"回复人图片Url:%@",reply.profileImageUrl);
            
            NSArray *ddNodesArray = [dlNode findChildTags:@"dd"];
            //-------Name
            HTMLNode *nameNode = [ddNodesArray objectAtIndex:0];
            reply.name = [nameNode.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            HTMLNode *moderatorImg = [nameNode findChildTag:@"img"];
            if (moderatorImg != nil)
            {
                if ([[moderatorImg getAttributeNamed:@"alt"] isEqualToString:@"版主"]) {
                    
                    reply.name = [NSString stringWithFormat:@"%@(版主)",reply.name];
                    //reply.name = [NSS
                }
            }
            
            //NSLog(@"Name:%@",reply.name);
            //-------NickName
            HTMLNode *nickNameNode = [ddNodesArray objectAtIndex:1];
            reply.nickName = nickNameNode.allContents;
            // NSLog(@"NickName:%@",reply.nickName);
            
            //-------总技术分 总技术排名 等级
            HTMLNode *gradeAndRankTotalPointsNode = [ddNodesArray objectAtIndex:2];
            NSString *gradeAndRankTotalPointsTitleClass = [gradeAndRankTotalPointsNode getAttributeNamed:@"title"];
            NSArray *aArray = [gradeAndRankTotalPointsTitleClass componentsSeparatedByString:@"；"];
            reply.totalTechnicalpoints = [[aArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@"总技术分：" withString:@""];
            //NSLog(@"总技术分:%@",reply.totalTechnicalpoints);
            
            reply.rank = [[aArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"总技术排名：" withString:@""];
            //NSLog(@"总技术排名:%@",reply.rank);
            
            HTMLNode *gradeNode = [gradeAndRankTotalPointsNode findChildTag:@"img"];
            NSString *grade = [gradeNode getAttributeNamed:@"class"];
            grade = [grade stringByReplacingOccurrencesOfString:@"grade " withString:@""];
            grade = [grade stringByReplacingOccurrencesOfString:@"user" withString:@"裤衩"];
            grade = [grade stringByReplacingOccurrencesOfString:@"star" withString:@"星星"];
            grade = [grade stringByReplacingOccurrencesOfString:@"diam" withString:@"钻石"];
            reply.grade = grade;
            //NSLog(@"%@",reply.grade);
            
            //-------结贴率
            HTMLNode *closeRate = [ddNodesArray objectAtIndex:3];
            reply.closeRate = closeRate.allContents;
            //NSLog(@"%@",reply.closeRate);
            
            //--------回复内容
            HTMLNode *contentNode = [trNode findChildOfClass:@"post_body"];
            reply.rawContents = contentNode.rawContents;
            reply.content = [contentNode.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //NSLog(@"%@",reply.content);
            
            [replyLisMutableArray addObject:reply];
        }
    }
    
    replyLists = [replyLisMutableArray copy];
    [coustomPullToRefresh endRefresh];
    
    [self.tableView reloadData];
    if (rowCount != 0 && replyLisMutableArray.count > rowCount)
    {
        NSUInteger ii[2] = {0, rowCount};
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSString *errorDetail = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"Error: %@", errorDetail);
    [SGInfoAlert showInfo: [NSString stringWithFormat:@"网络异常: %@",errorDetail]
                  bgColor:[[UIColor blackColor] CGColor]
                   inView:self.view vertical:0.8];
    [self.coustomPullToRefresh endRefresh];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.replyLists.count == 0)
	{
        return 1;
    }
    return self.replyLists.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.replyLists.count == 0 && indexPath.row == 0)
	{
        NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:PlaceholderCellIdentifier];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }        
        
		cell.detailTextLabel.text = [NSString stringWithFormat:@"数据加载中…"];		
		return cell; //记录为0则直接返回，只显示数据加载中…
    }
    //NSLog(@"%f",self.pv.progress);
    
    
    static NSString *CellIdentifier = @"b";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Reply *reply = [self.replyLists objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:998];
    UILabel *rowLabel = (UILabel *)[cell viewWithTag:997];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:995];
    UIWebView *webView = (UIWebView *)[cell viewWithTag:588];
    
    nameLabel.text = [NSString stringWithFormat:@"%@   等级：%@ (排名:%@)",reply.name,reply.grade,reply.rank]; // reply.name;
    if (indexPath.row == 0)
    {
        rowLabel.text = @"楼主";
        dateLabel.text = [NSString stringWithFormat:@"发表于：%@，%@",reply.date,reply.closeRate];
    }
    else
    {
        rowLabel.text = [NSString stringWithFormat:@"%d楼",indexPath.row];
        dateLabel.text = [NSString stringWithFormat:@"回复于：%@",reply.date];
        
    }
    float height = [ConstParameterAndMethod getArticleTitleHeight:reply.rawContents
                                               withWidth:tableView.frame.size.width - 10
                                                 andFont:[UIFont systemFontOfSize:ARTICLE_TITIE_SIZE]];
    CGRect frame = webView.frame;
    frame.size.height = height;
    webView.frame = frame;
    //webView.delegate = self;
    [webView loadHTMLString:reply.rawContents baseURL:nil];
    //webView.sizeThatFits = YES;
    //webView.scrollView.scrollEnabled = NO;
    
    
    if (reply.imageView == nil)
    {
        CGRect frame = CGRectMake(5, 5, 30, 30);
        AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];
        asyncImage.tag = 999;
        NSURL *url2 = [NSURL URLWithString:reply.profileImageUrl];
        [asyncImage loadImageFromURL:url2];
        reply.imageView = asyncImage;
    }
    [cell.contentView addSubview:reply.imageView];
//    [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
//                     withRowAnimation: UITableViewRowAnimationNone];
    
    
    return cell;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return navigationType == UIWebViewNavigationTypeOther;
}


//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    CGRect frame = webView.frame;
//    frame.size.height = 1;
//    webView.frame = frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size.height = fittingSize.height;
//    frame.size.width = 320;
//    webView.frame = frame;
//    //NSLog(@"%f",frame.size.height);
//}





#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // cell.backgroundColor = tableView.tableHeaderView.backgroundColor;
    }
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.article.title;
//}



- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.replyLists.count > 0)
    {
        
        Reply *reply = [self.replyLists objectAtIndex:indexPath.row];
        float height = [ConstParameterAndMethod getArticleTitleHeight:reply.rawContents
                                                   withWidth:tableView.frame.size.width - 10
                                                     andFont:[UIFont systemFontOfSize:ARTICLE_TITIE_SIZE]];
                return  height  + 60;
    }
    
    else
    {
        return 60;
    }
}


#pragma mark - 下拉、上拉实现 动态加载数据

- (void) customPullToRefreshShouldRefresh:(CustomPullToRefresh *)ptr didRefreshDirection:(MSRefreshDirection)direction
{
    if (direction == MSRefreshDirectionBottom)
    {
        page += 1;
        NSMutableString *tmp = [[NSMutableString alloc] initWithString:self.article.completeLink];
        [tmp appendString:[NSString stringWithFormat:@"?page=%d",page]];
        //[self performSelectorInBackground:@selector(setDataSourceFromWebSite:) withObject:tmp];
        
        [ConstParameterAndMethod setDataSourceWithWebSiteHtmlWithCookie:tmp andSetDelegate:self];

    }
    if (direction == MSRefreshDirectionTop)
    {
        page = 1;
        
        [ConstParameterAndMethod setDataSourceWithWebSiteHtmlWithCookie:self.article.completeLink andSetDelegate:self];
    }
    
}


- (void)setDataSourceFromWebSite:(NSString *)webSite
{
}


@end









//------2013-01-20
//<table border="0" cellspacing="0" cellpadding="0" id="post-393517612" class="post  " data-post-id="393517612" data-is-topic-locked="false">
//<colgroup><col width="180" /><col /></colgroup>
//<tr>
//<td rowspan="2" valign="top" class="wirter">
//<dl class="user_info user_moderator">
//<dt class="user_head" data-username="q107770540"><a href="http://my.csdn.net/q107770540" target="_blank"><img alt="q107770540" class="avatar" src="http://avatar.profile.csdn.net/6/B/7/1_q107770540.jpg" /></a>
//</dt>
//<dd class="username"><a href="http://my.csdn.net/q107770540" target="_blank">q107770540</a><img alt="版主" src="/assets/ico_BM-04df65c6033b993e1474606aa5ea59c5.png" title=".NET技术-LINQ版版主,.NET技术-非技术区版版主" />
//</dd>
//<dd class="nickname"><span class="name2nick">q107770540</span></dd>
//<dd title="总技术分：138945；总技术排名：54">等级：<img alt="Blank" class="grade star5" src="/assets/blank.gif" /></dd>
//<dd class="close_rate" title="用户结帖率：92.11% 总发帖：76 正常结帖：70 未结帖：6">结帖率：92.11%</dd>
//<div class="medal_MSMVP count" title="2011年4月 荣获微软MVP称号2012年4月 荣获微软MVP称号">
//<div class="medal_count">2</div>
//</div>
//<div class="medal_red " title="2010年9月 挨踢职涯大版内专家分月排行榜第一"></div>
//<div class="medal_yellow count" title="2010年8月 挨踢职涯大版内专家分月排行榜第二  2010年10月 挨踢职涯大版内专家分月排行榜第二 2010年12月 .NET技术大版内专家分月排行榜第二"><div class="medal_count">3</div></div><a href="/users/q107770540/medals" class="more_medals" target="_blank">更多勋章</a>
//</dl>
//
//</td>
//<td valign="top" class="post_info star" data-username="q107770540" data-floor="1">
//<div class="data">
//<span class="fr">
//<a href="#post-393517612">#1</a>
//得分：0
//</span>
//<span class="time">
//回复于：2013-01-20 13:23:25
//</span>
//</div>
//<div class="post_body">
//<img src="http://forum.csdn.net/PointForum/ui/scripts/csdn/Plugin/003/monkey/7.gif" alt="" />
//</div>
//
//</td>
//</tr>
//
//</table>











