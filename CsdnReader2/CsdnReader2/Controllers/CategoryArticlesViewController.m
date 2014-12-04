//
//  CategoryArticlesViewController.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-14.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "CategoryArticlesViewController.h"
#import "ArticleDetailViewController.h"

#import "ArticleTitleCell.h"
#import "HTMLParser.h"

@interface CategoryArticlesViewController ()<UITableViewDataSource,UITableViewDelegate,MyHandleDelegate,FLTableViewDelegate>
{
    FLTableView *_tableView;
    NSArray *articleLists;
    int page;
}

@end

@implementation CategoryArticlesViewController

@synthesize bbsCatgoryUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = self.title;
    self.navigationBar.backBtnTitle = @"";
    [self initViews];
    
    
}

- (void)initViews
{
    _tableView = [[FLTableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - DEVICE_STATUS_BAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.userInteractionEnabled = YES;
    _tableView.baseDeleagte = self;
    _tableView.headerEnable = YES;
    _tableView.footerEnable = YES;
    [self.view addSubview:_tableView];
    
    page = 1;
    [_tableView.header beginRefreshing];

}
#pragma mark - Action

- (void)refreshTableView
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:bbsCatgoryUrl];
    if (page >1)
    {
        [url appendString:[NSString stringWithFormat:@"?page=%d",page]];
    }
    task = [[HttpTask alloc] initWith:self url:url action:@selector(getData:) cookies:self.userInfo.cookies];
    [HttpTask addToQueue:task];
    

}


#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articleLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleTitleCell";
    ArticleTitleCell *theCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (theCell == nil)
    {
        theCell = [[ArticleTitleCell alloc] initWithStyle:UITableViewCellStyleValue1
                                    reuseIdentifier:CellIdentifier];
        
    }
    //------显示标题
    ArticleData *article = [articleLists objectAtIndex:indexPath.row];
    [theCell setUpCellWithData:article];
    
    return theCell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleData *article = [articleLists objectAtIndex:indexPath.row];

    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] init];
    vc.article = article;
    [self.navigationController pushViewController:vc animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    if (articleLists.count > 0)
    {
        ArticleData *article = [articleLists objectAtIndex:indexPath.row];
        height = article.titleHeight + 30;
        if (height < 45)
            height = 60;
    }

    return height;
}






#pragma mark - FLTableViewDelegate

-(void)tableViewRefreshData:(FLTableView *)tableView
{
    page = 1;
    [self refreshTableView];
}

-(void)tableViewLoadMoreData:(FLTableView *)tableView
{
    page++;
    [self refreshTableView];
}



#pragma mark - MyHandleDelegate


- (void)getData:(HandleMsg *)msg
{
    [_tableView finishReloadingData];
    if (msg.status == EXCUTE_SUCCESSFUL)
    {
        [self analysisData:msg.data];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请求失败" duration:3];
    }
}


- (void)analysisData:(NSString *)responseString
{
    
    NSString *errorString = [GlobalData isErrorPageWithHtml:responseString];

    if (errorString)
    {
        [SVProgressHUD showErrorWithStatus:errorString duration:3];
        return;
    }
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        [SVProgressHUD showErrorWithStatus:@"数据解析异常" duration:3];
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
                ArticleData *article =[[ArticleData alloc] init];
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


    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        if (rowCount != 0 && artcileLisMutableArray.count > rowCount)
        {
            NSUInteger ii[2] = {0, rowCount};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
            
        }
    });
    
    

}


@end
