//
//  ArticleViewController.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-12.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleTitleCell.h"
#import "CustomPullToRefresh.h"

@interface ArticleViewController : UITableViewController <CustomPullToRefreshDelegate>


@property (strong, nonatomic) IBOutlet ArticleTitleCell *articleTitleCell;

@end
