//
//  ArticleViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-12.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "ArticleViewController.h"
#import "ASIHTTPRequest.h"
#import "RegexKitLite.h"
#import "HTMLParser.h"
#import "ArticleTitleCell.h"
#import "SGInfoAlert.h"
#import "ConstParameterAndMethod.h"
#import "ArticleDetailViewController.h"
#import "Article.h"


@interface ArticleViewController ()

@property (nonatomic,strong) NSArray *articleLists;
@property (nonatomic,strong) NSString *urlWithOutPage;
@property (nonatomic,strong) CustomPullToRefresh *coustomPullToRefresh;
@property (nonatomic) NSInteger page;
@property (nonatomic,strong) UIBarButtonItem *refreshButton;

@end

@implementation ArticleViewController

@synthesize articleLists;
@synthesize urlWithOutPage;
@synthesize coustomPullToRefresh;
@synthesize page;
@synthesize refreshButton = _refreshButton;

#pragma mark - 配置右上角刷新按钮

- (UIBarButtonItem *)refreshButton
{
    if (_refreshButton == nil)
    {
        _refreshButton = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                          target:self action:@selector(doRefresh:) ];
    }
    return _refreshButton;
}


- (void)doRefresh:(id)sender
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    //[spinner stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    [self.coustomPullToRefresh startRefresh];
    [ConstParameterAndMethod setDataSourceWithGetWebSiteHtmlWithOutCookie:urlWithOutPage andSetDelegate:self];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    coustomPullToRefresh = [[CustomPullToRefresh alloc] initWithScrollView:self.tableView delegate:self];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    
    //---设置左上角按钮
    self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    if ([self.navigationItem.title isEqualToString:@".NET"])
    {
        urlWithOutPage = CSDN_BBS_DOTNET_URL;
    }
    else if([self.navigationItem.title isEqualToString:@"C/C++"])
    {
        urlWithOutPage = CSDN_BBS_CPP_URL;
    }
    else if([self.navigationItem.title isEqualToString:@"移动平台"])
    {
        urlWithOutPage = CSDN_BBS_MOBILE_URL;
    }
    else
    {
        urlWithOutPage = CSDN_BBS_OTHER_URL;
    }
    [ConstParameterAndMethod setDataSourceWithGetWebSiteHtmlWithOutCookie:urlWithOutPage andSetDelegate:self];
}




#pragma mark - 解析获取的HTML数据

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
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
        self.navigationItem.rightBarButtonItem = self.refreshButton;
        
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *spanNodes = [bodyNode findChildTags:@"tr"];
    NSMutableArray *artcileLisMutableArray ;
    NSUInteger rowCount = 0;
    if (page != 1)
    {
        artcileLisMutableArray = [[NSMutableArray alloc] initWithArray:articleLists];
        rowCount = artcileLisMutableArray.count;
    }
    else
    {
        artcileLisMutableArray = [[NSMutableArray alloc] init];
    }
    
    for (HTMLNode *spanNode in spanNodes)
    {
        NSArray *spanNodes2 = [spanNode findChildTags:@"td"];
        if (spanNodes2.count == 6)
        {
            HTMLNode *titleNode =[spanNodes2 objectAtIndex:0];
            if ( [[titleNode getAttributeNamed:@"class"] isEqualToString:@"title"])
            {
                NSArray *alinkArray = [titleNode findChildTags:@"a"];
                
                HTMLNode *titleNodeTitle = [alinkArray objectAtIndex:0];
                NSString *title = titleNodeTitle.allContents;
                NSString *titleColor = [titleNodeTitle getAttributeNamed:@"class"];
                HTMLNode *categorNode = [alinkArray objectAtIndex:2];
                NSString *categorString = categorNode.allContents;
                
                Article *article =[[Article alloc] init];
                article.titleColor = titleColor;
                
                //------链接
                article.link = [titleNodeTitle getAttributeNamed:@"href"];
                
                //------标题
                // ----去掉头尾的空格
                title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                article.title = title;
                //------分类
                article.category = categorString;
                //------帖子分数
                HTMLNode *pointNode =[spanNodes2 objectAtIndex:1];
                article.point = [pointNode allContents];
                //-----发帖人
                HTMLNode *authorAndArtcileDate =[spanNodes2 objectAtIndex:2];
                HTMLNode *authorNode = [authorAndArtcileDate findChildTag:@"a"];
                article.author = [authorNode allContents];
                //-----发帖时间
                HTMLNode *artcileDate = [authorAndArtcileDate findChildTag:@"span"];
                article.date = [artcileDate allContents];;
                //-----回复数
                HTMLNode *replyCountNode =[spanNodes2 objectAtIndex:3];
                article.replycount = [replyCountNode allContents];
                //-----最后回复人--回复时间
                HTMLNode *pointNode3 =[spanNodes2 objectAtIndex:4];
                HTMLNode *pointNode4 =[pointNode3 findChildTag:@"span"];                
                article.lastUpDate = [pointNode4 allContents];
                
                [artcileLisMutableArray addObject:article];
                
            }
            
        }
        
    }
    articleLists = [artcileLisMutableArray copy];
    [coustomPullToRefresh endRefresh];
    if (self.navigationItem.rightBarButtonItem != self.refreshButton)
    {
        self.navigationItem.rightBarButtonItem = self.refreshButton;
    }
    
    [self.tableView reloadData];
    if (rowCount != 0 && artcileLisMutableArray.count > rowCount)
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
    [coustomPullToRefresh endRefresh];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    [self.coustomPullToRefresh endRefresh];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.articleLists.count == 0)
	{
        return 1;
    }
    return self.articleLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.articleLists.count == 0 && indexPath.row == 0)
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
        
		cell.detailTextLabel.text = [NSString stringWithFormat:@"数据加载中…."];
		
		return cell; //记录为0则直接返回，只显示数据加载中…
    }
    
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ArticleTitleCell" owner:self options:nil];
        cell = self.articleTitleCell;
    }

    ArticleTitleCell *theCell = (ArticleTitleCell*)cell; // cast as MyCell, use properties
    
    //------显示标题
    Article *article = [self.articleLists objectAtIndex:indexPath.row];
    
    theCell.titleLabel.text =[NSString stringWithFormat:@"%@   [%@]",article.title,article.category];
    
    
    if (article.titleColor != nil)
    {
        
        NSRange range = [article.titleColor rangeOfString:@"red" options:NSCaseInsensitiveSearch];//判断字符串是否包含
        
        if (range.location != NSNotFound)
        {
            //NSLog(@"%@",article.titleColor);
            theCell.titleLabel.textColor = [UIColor redColor];
        }
        
        range = [article.titleColor rangeOfString:@"green" options:NSCaseInsensitiveSearch];//判断字符串是否包含
        if (range.location != NSNotFound)
        {
            theCell.titleLabel.textColor = [UIColor greenColor];
        }
        
        range = [article.titleColor rangeOfString:@"blue" options:NSCaseInsensitiveSearch];//判断字符串是否包含
        if (range.location != NSNotFound)
        {
            theCell.titleLabel.textColor = [UIColor blueColor];
        }
 
//        range = [article.titleColor rangeOfString:@"bold" options:NSCaseInsensitiveSearch];//判断字符串是否包含
//        if (range.location != NSNotFound)
//        {
//            theCell.titleLabel.font = [UIFont fontWithName:@"System-Bold" size:12];
//            
//        }
    }

    
    //------显示问题分数
    theCell.pointLabel.text = [NSString stringWithFormat:@"%@分",article.point];
    //------显示有多少回复
    theCell.replyCountLabel.text = [NSString stringWithFormat:@"%@回应",article.replycount];
    //------显示发布时间和发布人
    NSString *miunesTime = [ConstParameterAndMethod showMinusTimeWithNoYearDateString:article.date];
    theCell.authorAndDateLabel.text = [NSString stringWithFormat:@"%@  %@",article.author,miunesTime];
    
    
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    if (self.articleLists.count > 0)
    {
        
        
        Article *article = [self.articleLists objectAtIndex:indexPath.row];
        
        NSString *articleTitle = [NSString stringWithFormat:@"%@   [%@]",article.title,article.category];
        height = [ConstParameterAndMethod getArticleTitleHeight:articleTitle
                                                   withWidth:tableView.frame.size.width //- 5
                                                     andFont:[UIFont systemFontOfSize:ARTICLE_TITIE_SIZE]];
    }
    
    if (height < 45)
        return 60;
    else
        return 70;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetail"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        Article *article = [self.articleLists objectAtIndex:selectedRowIndex.row];
        ArticleDetailViewController *articleDetailViewController = [segue destinationViewController];
        [articleDetailViewController setArticle:article];
        
    }
}

#pragma mark - 下拉、上拉实现 动态加载数据

- (void) customPullToRefreshShouldRefresh:(CustomPullToRefresh *)ptr didRefreshDirection:(MSRefreshDirection)direction
{
    if (direction == MSRefreshDirectionBottom)
    {
        page += 1;
        
        NSMutableString *tmp = [[NSMutableString alloc] initWithString:urlWithOutPage];
        [tmp appendString:[NSString stringWithFormat:@"?page=%d",page]];
        // NSLog(@"%@", tmp);
        [self performSelectorInBackground:@selector(refresh:) withObject:tmp];
    }
    if (direction == MSRefreshDirectionTop)
    {
        page = 1;
        [self performSelectorInBackground:@selector(refresh:) withObject:urlWithOutPage];
    }
    
}

- (void)refresh:(NSString *)webSiteUrl
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    //[spinner stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    //[self.coustomPullToRefresh startRefresh];
    [ConstParameterAndMethod setDataSourceWithGetWebSiteHtmlWithOutCookie:webSiteUrl andSetDelegate:self];
}



- (void)viewDidUnload { 
    [self setTableView:nil];
    [self setArticleTitleCell:nil];
    [super viewDidUnload];
}

@end











//-------------------2013-01-13

//http://bbs.csdn.net/forums/DotNET?page=2


//<tr>
//<td class="title">
//<strong class="green">？</strong>
//<a href="/topics/390341875" target="_blank" title="登录后台总是提示“用户名或者密码错误”，求解决">登录后台总是提示“用户名或者密码错误”，求解决</a>
//<span class="forum_link">[<span class="parent"><a href="/forums/DotNET">.NET技术</a></span> <a href="/forums/ASPDotNET">ASP.NET</a>]</span>
//</td>
//<td class="tc">40</td>
//<td class="tc">
//<a href="http://my.csdn.net/gzbbq888" target="_blank">gzbbq888</a><br />
//<span class="time">01-09 13:51</span></td>
//<td class="tc">2</td>
//<td class="tc">
//<a href="http://my.csdn.net/gzbbq888" target="_blank">gzbbq888</a><br />
//<span class="time">01-09 14:04</span>
//</td>
//<td class="tc">
//<a href="/topics/390341875/close" target="_blank">管理</a>
//</td>
//</tr>














