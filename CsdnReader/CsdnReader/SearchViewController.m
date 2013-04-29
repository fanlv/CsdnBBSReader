//
//  SearchViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-4-10.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "SearchViewController.h"
#import "ConstParameterAndMethod.h"
#import "CustomPullToRefresh.h"
#import "ASIHTTPRequest.h"
#import "HTMLParser.h"
#import "SVProgressHUD.h"
#import "Article.h"
#import "ArticleTitleCell.h"
#import "ArticleDetailViewController.h"

@interface SearchViewController ()< UISearchBarDelegate,CustomPullToRefreshDelegate>
{
    int page;
    NSString *urlWithOutPage;
    NSArray *articleLists;
    NSIndexPath *currentIndexPath;
    CustomPullToRefresh *coustomPullToRefresh;
}

@property (strong, nonatomic)  ArticleTitleCell *articleTitleCell;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController


#pragma mark -  View Life Cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = YES
    coustomPullToRefresh = [[CustomPullToRefresh alloc] initWithScrollView:self.tableView delegate:self];
    [self.searchBar becomeFirstResponder];
    self.searchBar.showsCancelButton = YES;
    
    for(id subview in [self.searchBar subviews])
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            [(UIButton*)subview setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}



- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    if (self.searchBar.tintColor != [ConstParameterAndMethod getUserSaveColor])
    {
        self.searchBar.tintColor = [ConstParameterAndMethod getUserSaveColor];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return articleLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ArticleTitleCell" owner:self options:nil];
        cell = self.articleTitleCell;
    }
    
    ArticleTitleCell *theCell = (ArticleTitleCell*)cell; // cast as MyCell, use properties
    
    theCell.pointLabel.hidden = YES;
    //------显示标题
    Article *article = [articleLists objectAtIndex:indexPath.row];
    
    theCell.titleLabel.text =[NSString stringWithFormat:@"%@",article.title];
        
    //------显示有多少回复
    theCell.replyCountLabel.text = [NSString stringWithFormat:@"%@浏览",article.replycount];
    //------显示发布时间和发布人
    theCell.authorAndDateLabel.text = [NSString stringWithFormat:@"%@  %@",article.author,article.date];
    
    
    return cell;

    
    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    [self performSegueWithIdentifier:@"show" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        Article *article = [articleLists objectAtIndex:selectedRowIndex.row];
        ArticleDetailViewController *articleDetailViewController = [segue destinationViewController];
        [articleDetailViewController setArticle:article];
        
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    if (articleLists.count > 0)
    {
        
        
        Article *article = [articleLists objectAtIndex:indexPath.row];
        
        height = [ConstParameterAndMethod getArticleTitleHeight:article.title
                                                      withWidth:tableView.frame.size.width //- 5
                                                        andFont:[UIFont systemFontOfSize:ARTICLE_TITIE_SIZE]];
        
        if (height < 45)
            return 60;
        else
            return 70;
    }


    return 35;
    

}
#pragma mark - searchBar Delegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    
    [SVProgressHUD showWithStatus:@"搜索中....."];

    [self.searchBar resignFirstResponder];
    for(id subview in [self.searchBar subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    
    page = 1;
    
    NSString *searchWord = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *webSite =[NSString stringWithFormat:@"http://so.csdn.net/search?utf8=✓&q=%@&commit=搜+索&sort=&t=thread" ,searchWord];

    webSite = [webSite stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    urlWithOutPage = webSite;
    [self searchWithWbSite:webSite];
    
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 解析获取的HTML数据


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = [request responseString];
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        [SVProgressHUD dismissWithError:@"返回数据异常。。"];
        return;
    }

    HTMLNode *body = [parser body];
    
    
    HTMLNode *no_result = [body findChildOfClass:@"no_result"];
    if (no_result != nil)
    {
        [SVProgressHUD dismissWithError:no_result.allContents];

        return;
    }
   
    NSArray *resultLsits = [body findChildrenOfClass:@"ires"];
    
    
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

    
    
    for (HTMLNode *resultNode in resultLsits)
    {
        
        NSArray *aList = [resultNode findChildTags:@"a"];
        
        HTMLNode *titleLink = [aList objectAtIndex:0];
        HTMLNode *titleLink2 = [aList objectAtIndex:1];
        
        HTMLNode *rd = [resultNode findChildOfClass:@"rd"];
        
        NSArray *emArray  = [rd findChildTags:@"em"];
        HTMLNode *em1 = [emArray objectAtIndex:0];
        HTMLNode *em2 = [emArray objectAtIndex:1];
        
        //HTMLNode *rb = [resultNode findChildOfClass:@"rb"];


        Article *article = [[Article alloc] init];
        

        
        article.title = titleLink.allContents;
        
        article.completeLink = [titleLink getAttributeNamed:@"href"];
        article.link = [article.completeLink stringByReplacingOccurrencesOfString:CSDN_BBS_URL withString:@""];

        article.author = titleLink2.allContents;
        article.date = [em1 contents];
        article.replycount = [em2 contents];
        //searchResult.description = [rb contents];
        
//        NSLog(@"%@,%@",searchResult.title ,searchResult.completeLink);
//        NSLog(@"%@,%@",titleLink2.allContents,titleLink2.tagName);
//        NSLog(@"%@,%@",searchResult.date,searchResult.seeCount);
//        NSLog(@"%@",searchResult.description);
        
        [artcileLisMutableArray addObject:article];


    }
    articleLists = [artcileLisMutableArray copy];
    [coustomPullToRefresh endRefresh];

    
    [self.tableView reloadData];
    if (rowCount != 0 && artcileLisMutableArray.count > rowCount)
    {
        NSUInteger ii[2] = {0, rowCount};
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
        
    }
    
    if (page == 1)
    {
        [SVProgressHUD dismissWithSuccess:@"搜索成功."];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSString *errorDetail = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"Error: %@", errorDetail);
    [SVProgressHUD dismissWithError:@"网络异常。。。"];
    
}




#pragma mark - 下拉、上拉实现 动态加载数据

- (void) customPullToRefreshShouldRefresh:(CustomPullToRefresh *)ptr didRefreshDirection:(MSRefreshDirection)direction
{
    if (direction == MSRefreshDirectionBottom)
    {
        page += 1;
        NSMutableString *tmp = [[NSMutableString alloc] initWithString:urlWithOutPage];
        [tmp appendString:[NSString stringWithFormat:@"&page=%d",page]];
        [self performSelectorInBackground:@selector(searchWithWbSite:) withObject:tmp];
    }
    if (direction == MSRefreshDirectionTop)
    {
        [coustomPullToRefresh endRefresh];
        return;
    }
    
}



- (void)searchWithWbSite:(NSString *)webSite
{
    NSURL *url2 = [NSURL URLWithString:webSite];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url2];
    
    //Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B141 Safari/8536.25
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B141 Safari/8536.25"];
    [request setDelegate:self];
    [request startAsynchronous];
}




/*
<div id="result_list">


<div class="ires">
 
 
<h3 class="rt">
 <a href="http://bbs.csdn.net/topics/390423492" onclick="click_log(&#x27;topic&#x27;,&#x27;c#&#x27;,&#x27;390423492&#x27;)" target="_blank"><span class="keyword">C#</span>中如何声明一个使用不定类型和数量参数的方法</a></h3>
<p class="rd">
作者：
<a href="http://blog.csdn.net/t_Razer" target="_blank">t_Razer</a>
-
日期：<em>2013-04-12</em>
浏览 <em>10</em> 次
</p>
<div class="rb">还是那个<span class="keyword">C#</span> winform调用非托管dll（纯C或者C++编写）的老问题，经过论坛大神们的指点，我已经摸索出了完全动态加载\344\275\277用\卸载dll的方法。现在有一个问题，用<span class="keyword">C#</span>做出来的程序需要加载各种非托管dll，这些dll中的导出函数的参数类型和数量不确定。<span class="keyword">C#</span>中要使用非托管dll\344\270\255的导出函数就得声明一个和导出函数型式一样的委托（型式一样指的是返回类型和参数</div>
<a href="http://bbs.csdn.net/topics/390423492" class="rl" onclick="click_log(&#x27;topic&#x27;,&#x27;c#&#x27;,&#x27;390423492&#x27;)" target="_blank">http://bbs.csdn.net/topics/390423492</a>
</div>
 
 */





@end
