//
//  BaseViewController.h
//  Droponto
//
//  Created by Fan Lv on 14-3-19.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNavigationBar.h"
#import "HttpTask.h"
#import "RequestHelper.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "MUser.h"
#import "HttpTask.h"
#import "FLTableView.h"

@interface BaseViewController : UIViewController
{
    HttpTask *task;
}

@property (nonatomic,strong) FLNavigationBar          *navigationBar;
@property (nonatomic,strong) UITapGestureRecognizer   *singleTap;
@property (nonatomic,strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic,strong) MUser                    *userInfo;


- (void)initViews;


@end
