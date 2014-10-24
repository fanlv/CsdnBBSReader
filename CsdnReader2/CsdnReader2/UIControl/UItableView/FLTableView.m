//
//  FLTableView.m
//  Droponto
//
//  Created by Fan Lv on 14-4-29.
//  Copyright (c) 2014年 fanlv. All rights reserved.
//

#import "FLTableView.h"

@implementation FLTableView

@synthesize header = _header;
@synthesize footer = _footer;



#pragma mark - Property

- (MJRefreshHeaderView *)header
{
    if (_header == nil &&_headerEnable)
    {
        _header = [MJRefreshHeaderView header];
        _header.isHideUpdateTime = YES;
        _header.scrollView = self;
        _header.delegate = self;
    }
    return _header;
}
- (MJRefreshFooterView *)footer
{
    if (_footer == nil && _footerEnable)
    {
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = self;
        _footer.delegate = self;
    }
    return _footer;
}

- (void)setHeaderEnable:(BOOL)enable
{
    _headerEnable = enable;
    if (enable)
    {
        self.header.scrollView = self;
        self.header.delegate = self;
        self.header.hidden = NO;
    }
    else
    {
        //        _header.scrollView = nil;
        _header.delegate = nil;
        _header.hidden = YES;
    }
}

- (void)setFooterEnable:(BOOL)enable
{
    _footerEnable = enable;
    if (enable)
    {
        self.footer.scrollView = self;
        self.footer.delegate = self;
        self.footer.hidden = NO;
    }
    else
    {
        //        _footer.scrollView = nil;
        _footer.delegate = nil;
        _footer.hidden = YES;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInterface];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self setUserInterface];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setUserInterface];
    }
    return self;
}

-(void)setUserInterface
{
    updateData = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    updateData.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 88);
    [self addSubview:updateData];
    
}

#pragma mark - MJRefreshBaseView Delegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header)
    {
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.5];
        
    }
    else if (refreshView == _footer)
    {
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.5];
    }
    
}

#pragma mark- force to show the refresh headerView

-(void)showRefreshHeader:(BOOL)animated
{
    [self.header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.2];
}

#pragma mark - Refresh Method
//刷新数据函数 - 下拉刷新执行的方法
-(void)refreshView
{
    if ([self.baseDeleagte respondsToSelector:@selector(tableViewRefreshData:)]) {
        [self.baseDeleagte tableViewRefreshData:self];
    }
    //    //----do nothing
    //    if (_header)
    //    {
    //        [_header performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
    //    }
}
//加载更多函数 - 上拉刷新时执行的方法
-(void)getNextPageView
{
    if ([self.baseDeleagte respondsToSelector:@selector(tableViewLoadMoreData:)]) {
        [self.baseDeleagte tableViewLoadMoreData:self];
    }
    //    //----do nothing
    //    if (_footer)
    //    {
    //        [_footer performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
    //    }
}


- (void)finishReloadingData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_header)
        {
            [_header endRefreshing];
        }
        if (_footer)
        {
            [_footer endRefreshing];
        }
    });
    
}
#pragma mark -status

-(void)loadStartStatuesView
{
    NSLog(@"start load");
    updateData.hidden = NO;
    [updateData startAnimating];
}

-(void)loadFinishStatuesView{
    NSLog(@"end load");
    updateData.hidden = YES;
    [updateData stopAnimating];
    [self finishReloadingData];
}

-(void)dealloc{
    
    NSLog(@"table dealloc");
    
    if (_header) {
        [_header free];

        _header.delegate = nil;
    }
    
    if (_footer) {
        [_footer free];
        _footer.delegate = nil;
    }
    self.baseDeleagte = nil;
}



//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *result = [super hitTest:point withEvent:event];
//    
//    if (self.tag == 101)
//    {
//        CGPoint contentOffsetPoint = self.contentOffset;
//        CGRect frame = self.frame;
//        NSLog(@"%f",self.contentOffset.y);
////        if (contentOffsetPoint.y == self.contentSize.height - frame.size.height || self.contentSize.height < frame.size.height)
////        {
////            id sdsd = [self viewWithTag:101];
////            UITableView *tableView = (UITableView *) sdsd;
////            NSLog(@"return UITableView");
////            return tableView;
////        }
////        else
////        {
////            return  self;
////            NSLog(@"return FLScrollView");
////            
////        }
//    }
//    
//    
//    return result;
//}


@end
