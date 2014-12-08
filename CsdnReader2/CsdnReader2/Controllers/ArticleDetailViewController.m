//
//  ArticleDetailViewController.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-14.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ReplyData.h"
#import "ReplyCell.h"
#import "HTMLParser.h"
#import "SGInfoAlert.h"
#import "UIPopoverListView.h"
#import "ReplyViewController.h"

@interface ArticleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MyHandleDelegate,FLTableViewDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate>
{
    FLTableView *_tableView;
    int page;
    NSArray *replyLists;
    NSArray *authorReplyLists;
    BOOL isOnlySeeAuthor;
    NSString *errorCode;
    UIImage *captchaImg;
    NSString *captchaUrl;

}

@property (nonatomic,strong) UIPopoverListView *poplistview;
@property (nonatomic,strong) NSArray *optionList;

@end

@implementation ArticleDetailViewController

@synthesize article;
@synthesize poplistview = _poplistview;
@synthesize optionList = _optionList;


- (NSArray *)optionList
{
    if (_optionList == nil)
    {
        NSString *str = isOnlySeeAuthor ? @"查看所有" :@"只看楼主";
        _optionList = @[@"回复",str];
        
    }
    return _optionList;

}


- (UIPopoverListView *)poplistview
{
    if (_poplistview == nil)
    {
        CGFloat xWidth = SCREEN_WIDTH - 20.0f;
        CGFloat yHeight = 150;
        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
        _poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
        _poplistview.delegate = self;
        _poplistview.datasource = self;
        _poplistview.listView.scrollEnabled = YES;
        
    }
    return _poplistview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = self.article.title;
    self.navigationBar.backBtnTitle = @"";
    [self.navigationBar setRightButtonWithTitle:@"菜单" btnBG:nil action:self selector:@selector(shouOptionList)];
    isOnlySeeAuthor = NO;
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
    [self.view addSubview:_tableView];
    
    
    self.title = self.article.title;
    NSMutableString *articleTitle = [[NSMutableString alloc] initWithString:self.article.title];
    
    if (self.article.category != nil || self.article.point)
    {
        [articleTitle appendString:@"   ["];
        
        [articleTitle appendString:self.article.category];
        [articleTitle appendString:@"]   ["];
        [articleTitle appendString:self.article.point];
        [articleTitle appendString:@"分"];
        [articleTitle appendString:@"]"];
    }
    
    CGSize size = [GlobalData getTextSizeWithText:articleTitle rect:CGSizeMake(SCREEN_WIDTH - 20, 20) font:MID_FONT2];
    if (size.height < 25) size.height = 25;
    CGFloat tableHeaderHeight = size.height +10;

    
    //创建一个视图（_headerView）
    UIView *tableViewHeader= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, tableHeaderHeight)];
    // 创建一个 _headerLabel 用来显示标题
    UILabel *tableHeaderViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, SCREEN_WIDTH - 20, tableHeaderHeight)];
    tableHeaderViewLabel.backgroundColor = [UIColor clearColor];
    tableHeaderViewLabel.numberOfLines = 0;
    tableHeaderViewLabel.textColor = [UIColor blackColor];
    tableHeaderViewLabel.font = MID_FONT2;
    tableHeaderViewLabel.lineBreakMode = NSLineBreakByCharWrapping;// UILineBreakModeWordWrap;
    tableHeaderViewLabel.text = articleTitle;
    [tableViewHeader addSubview:tableHeaderViewLabel];
    
    _tableView.tableHeaderView = tableViewHeader;
    
    
    
    page = 1;
    [self refreshTableView];
    
//    [SGInfoAlert showInfo:@"友情提示 ： 整个页面的左边滑动单个回复，整个页面的右边滑动整个页面。"
//                  bgColor:[[UIColor darkGrayColor] CGColor]
//                   inView:self.view
//                 vertical:0.5];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataMyTable)
                                                 name:@"reload123" object:nil];
    
    
}

#pragma mark - Action

- (void)shouOptionList
{
    _poplistview = nil;
    [self.poplistview setTitle:@"请选择操作"];
    [self.poplistview show];
}


- (void)onlySeeAuthor
{
    isOnlySeeAuthor = !isOnlySeeAuthor;
    [_tableView reloadData];
}


- (void)reloadDataMyTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}

- (void)refreshTableView
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:article.completeLink];
    if (page >1)
    {
        [url appendString:[NSString stringWithFormat:@"?page=%d",page]];
    }
    task = [[HttpTask alloc] initWith:self url:url action:@selector(getData1:) cookies:self.userInfo.cookies];
    [HttpTask addToQueue:task];
    
    
}


#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (replyLists.count == 0)
    {
        return 1;
    }
    if (isOnlySeeAuthor)
    {
        return authorReplyLists.count;
    }
    return replyLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((replyLists.count == 0 && indexPath.row == 0) || errorCode != nil)
    {
        NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:PlaceholderCellIdentifier];
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (errorCode != nil)
        {
          
            cell.detailTextLabel.text = errorCode;
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"数据加载中…"];
        
        return cell; //记录为0则直接返回，只显示数据加载中…
    }
    //NSLog(@"%f",self.pv.progress);
    
    
    static NSString *CellIdentifier = @"ReplyCell";
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    ReplyData *reply ;
    if (isOnlySeeAuthor)
    {
        reply = [authorReplyLists objectAtIndex:indexPath.row];
    }
    else
    {
        reply = [replyLists objectAtIndex:indexPath.row];
    }
    [cell setUpCellWithData:reply];
    return cell;

    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (replyLists.count > 0)
    {
        ReplyData *reply;
        if (isOnlySeeAuthor)
        {
            reply = [authorReplyLists objectAtIndex:indexPath.row];
        }
        else
        {
            reply = [replyLists objectAtIndex:indexPath.row];
        }
        return  reply.contentHeight  + 60;
    }
    else
    {
        return 60;
    }
}



#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text = [self.optionList objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView numberOfRowsInSection:(NSInteger)section
{
    return [self.optionList count];
}

#pragma mark - UIPopoverListViewDelegate

- (void)popoverListView:(UIPopoverListView *)popoverListView didSelectIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if(self.userInfo.isLogin)
        {
            ReplyViewController *vc = [[ReplyViewController alloc] init];
            NSString *topicId = [self.article.link stringByReplacingOccurrencesOfString:@"/topics/" withString:@""];
            [vc setTopicId:topicId];
            vc.captchaImg = captchaImg;
            vc.captchaUrl = captchaUrl;
            
//            NSLog(@"%@",captchaUrl);

            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请先登录账号，谢谢。"];
        }
        

    }
    else if (indexPath.row == 1)
    {
        _optionList = nil;
        [self onlySeeAuthor];
    }
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
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


- (void)getData1:(HandleMsg *)msg
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
    
    errorCode = [GlobalData isErrorPageWithHtml:responseString];
    if (errorCode != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        return;
    }
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        [SVProgressHUD showErrorWithStatus:@"数据解析异常" duration:3];
        return;
    }
    NSMutableArray *replyLisMutableArray ;
    NSMutableArray *authorReplyLisMutableArray ;
    
    NSUInteger rowCount = 0;
    NSUInteger authorRowCount = 0;
    int indexTmp = 0;
    
    if (page != 1)
    {
        replyLisMutableArray = [[NSMutableArray alloc] initWithArray:replyLists];
        rowCount = replyLisMutableArray.count;
        indexTmp = (int)rowCount;
        
        authorReplyLisMutableArray = [[NSMutableArray alloc] initWithArray:authorReplyLists];
        authorRowCount = authorReplyLisMutableArray.count;
    }
    else
    {
        replyLisMutableArray = [[NSMutableArray alloc] init];
        authorReplyLisMutableArray = [[NSMutableArray alloc] init];
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *wraper = [bodyNode findChildOfClass:@"wraper"];
    HTMLNode *detailed = [wraper findChildOfClass:@"detailed"];
    NSArray *replyNodes = [detailed findChildTags:@"table"];
    
    
    HTMLNode *captcha = [[bodyNode findChildrenWithAttribute:@"alt" matchingName:@"captcha" allowPartial:YES] firstObject];

    if (captcha)
    {
        captchaUrl = [captcha getAttributeNamed:@"src"];
        NSString *url = [NSString stringWithFormat:@"http://bbs.csdn.net%@",captchaUrl];
        NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        captchaImg = [UIImage imageWithData:data];
        NSLog(@"%@",captchaUrl);
    }
    else
    {
        captchaImg = nil;
        captchaUrl = @"";
    }
    
    for (HTMLNode *tableNode in replyNodes)
    {
        HTMLNode *trNode = [tableNode findChildTag:@"tr"];
        NSArray *tdNodes = [trNode findChildTags:@"td"];
        HTMLNode *tdNode1 = [tdNodes objectAtIndex:0];
        if ([tdNode1.className isEqualToString:@"wirter"])
        {
            ReplyData *reply = [[ReplyData alloc] init];
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
            
            
            for (HTMLNode *nameNode in ddNodesArray)
            {
//                NSLog(@"%@",nameNode.rawContents);
                if ([[nameNode className] isEqualToString:@"username"])
                {
                    reply.name = [nameNode.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    //NSLog(@"Name:%@",reply.name);

                    HTMLNode *moderatorImg = [nameNode findChildTag:@"img"];
                    if (moderatorImg != nil)
                    {
                        if ([[moderatorImg getAttributeNamed:@"alt"] isEqualToString:@"版主"])
                        {
                            reply.isModerator = YES;
                        }
                    }
                }
                else if ([[nameNode className] isEqualToString:@"nickname"])
                {
                    reply.nickName = [nameNode.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    //-------NickName
                    // NSLog(@"NickName:%@",reply.nickName);
                }
                else if([nameNode findChildrenOfClass:@"topic_show_user_level"].count >0)
                {
                    HTMLNode *topic_show_user_level = [nameNode findChildOfClass:@"topic_show_user_level"];
                    NSString *topic_show_user_level_alt = [topic_show_user_level getAttributeNamed:@"alt"];
                    reply.grade = topic_show_user_level_alt;
                    
                    HTMLNode *smallTittle = [nameNode findChildOfClass:@"smallTittle"];
                    reply.totalTechnicalpoints = [smallTittle.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
//                    NSLog(@"%@",topic_show_user_level.rawContents);
                    
                }
                    
//                else if ([[nameNode getAttributeNamed:@"title"] hasPrefix:@"总技术分"])
//                {
//                    //-------总技术分 总技术排名 等级
//
//                    NSString *gradeAndRankTotalPointsTitleClass = [nameNode getAttributeNamed:@"title"];
//                    NSArray *aArray = [gradeAndRankTotalPointsTitleClass componentsSeparatedByString:@"；"];
//                    reply.totalTechnicalpoints = [[aArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@"总技术分：" withString:@""];
//                    //NSLog(@"总技术分:%@",reply.totalTechnicalpoints);
//                    
//                    reply.rank = [[aArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"总技术排名：" withString:@""];
//                    //NSLog(@"总技术排名:%@",reply.rank);
//                    
//                    HTMLNode *gradeNode = [nameNode findChildTag:@"img"];
//                    NSString *grade = [gradeNode getAttributeNamed:@"class"];
//                    grade = [grade stringByReplacingOccurrencesOfString:@"grade " withString:@""];
//                    grade = [grade stringByReplacingOccurrencesOfString:@"user" withString:@"裤衩"];
//                    grade = [grade stringByReplacingOccurrencesOfString:@"star" withString:@"星星"];
//                    grade = [grade stringByReplacingOccurrencesOfString:@"diam" withString:@"钻石"];
//                    reply.grade = grade;
//                    //NSLog(@"%@",reply.grade);
//                }
                else if ([[nameNode allContents] hasPrefix:@"结帖率"])
                {
                    //-------结贴率
                    reply.closeRate = nameNode.allContents;
//                    NSLog(@"%@",reply.closeRate);
                }

            }
            
            
            //--------回复内容
            HTMLNode *contentNode = [trNode findChildOfClass:@"post_body"];
            reply.rawContents = contentNode.rawContents;
            reply.content = [contentNode.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            
            
            
            HTMLNode *topic_extra_info = [contentNode findChildWithAttribute:@"id" matchingName:@"topic-extra-info" allowPartial:YES];
            if (topic_extra_info)
            {
                reply.topic_extra_infoContent = topic_extra_info.allContents;
                reply.rawContents  =[reply.rawContents stringByReplacingOccurrencesOfString:topic_extra_info.rawContents withString:@""];
            }

            HTMLNode *iframe = [contentNode findChildTag:@"iframe"];
            if (iframe)
            {
                reply.rawContents  =[reply.rawContents stringByReplacingOccurrencesOfString:iframe.rawContents withString:@""];
            }
        
            
            //NSLog(@"%@",reply.content);
            
            //----是不是楼主
            reply.isAuthor = [reply.name isEqualToString:self.article.author];
            
            
            reply.indexR = indexTmp++;
            if (reply.isAuthor)
            {
                [authorReplyLisMutableArray addObject:reply];
            }
            
            [replyLisMutableArray addObject:reply];
            
        }
    }
    
    replyLists = [replyLisMutableArray copy];
    authorReplyLists = [authorReplyLisMutableArray copy];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        
        
        BOOL b = ((replyLisMutableArray.count-1) % 50==0);
        
        _tableView.footerEnable = b;

        if (isOnlySeeAuthor)
        {
            if (authorRowCount != 0 && authorReplyLisMutableArray.count > authorRowCount)
            {
                NSUInteger ii[2] = {0, authorRowCount};
                NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
            }
        }
        else
        {
            if (rowCount != 0 && replyLisMutableArray.count > rowCount)
            {
                
                NSUInteger ii[2] = {0, rowCount};
                NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
            }
        }
    });
    
    

}


@end
