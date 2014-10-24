//
//  FLTableView.h
//  Droponto
//
//  Created by Fan Lv on 14-4-29.
//  Copyright (c) 2014年 fanlv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class FLTableView;

@protocol FLTableViewDelegate <NSObject>

@optional
-(void)tableViewRefreshData:(FLTableView *)tableView;
-(void)tableViewLoadMoreData:(FLTableView *)tableView;

@end

@interface FLTableView : UITableView<MJRefreshBaseViewDelegate>
{
    UIActivityIndicatorView *updateData;
}
@property(nonatomic,weak)id<FLTableViewDelegate>baseDeleagte;


//------如果继承的TableView不需要上拉下拉刷新的功能，请勿使用以下属性。
//------默认不会添加上拉下拉效果
//------如果需要添加上拉下拉效果设置self.headerEnable = YES和self.footerEnable = YES即可
@property(nonatomic,strong) MJRefreshHeaderView *header;
@property(nonatomic,strong) MJRefreshFooterView *footer;
@property(nonatomic,assign) BOOL headerEnable;
@property(nonatomic,assign) BOOL footerEnable;



//如果要实现下拉刷新和上拉刷新，则子类需重写这两个方法
//刷新数据函数 - 下拉刷新执行的方法
-(void)refreshView;
//加载更多函数 - 上拉刷新时执行的方法
-(void)getNextPageView;



//停止显示刷新
- (void)finishReloadingData;
//
-(void)loadStartStatuesView;
-(void)loadFinishStatuesView;

@end
