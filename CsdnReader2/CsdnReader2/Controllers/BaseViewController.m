//
//  BaseViewController.m
//  Droponto
//
//  Created by Fan Lv on 14-3-19.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"
@interface BaseViewController ()





@end

@implementation BaseViewController

@synthesize singleTap = _singleTap;
@synthesize leftSwipeGestureRecognizer = _leftSwipeGestureRecognizer;
@synthesize rightSwipeGestureRecognizer = _rightSwipeGestureRecognizer;
@synthesize navigationBar = _navigationBar;
@synthesize userInfo = _userInfo;

#pragma mark - Propety

- (FLNavigationBar *)navigationBar
{
    if (_navigationBar == nil)
    {
       _navigationBar = [[FLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT)];
        [self.view addSubview:_navigationBar];
    }
    return _navigationBar;
}

- (UITapGestureRecognizer *)singleTap
{
    if (_singleTap == nil)
    {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        [self.view addGestureRecognizer:_singleTap];
    }
    return _singleTap;
}
- (UISwipeGestureRecognizer *)leftSwipeGestureRecognizer
{
    if (_leftSwipeGestureRecognizer == nil)
    {
        _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
        _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
    }
    return _leftSwipeGestureRecognizer;
}

- (UISwipeGestureRecognizer *)rightSwipeGestureRecognizer
{
    if (_rightSwipeGestureRecognizer == nil)
    {
        _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
        _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:_rightSwipeGestureRecognizer];
    }
    return _rightSwipeGestureRecognizer;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = Light_White_Color;//RGB(238, 238, 238);
    self.userInfo = [MUser getInstance];
    // 修改在iOS7下视图与状态栏覆盖问题
    if (OS_VERSION >= 7.0)
        self.view.bounds = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    if (![self isKindOfClass:[MainViewController class]])
    {
        [task cancel];
    }
}


- (void)initViews
{
    NSLog(@"base View  initViews");
}

#pragma mark - UITapGestureRecognizer

- (void)viewDidTap:(UITapGestureRecognizer *)sender
{
    //------Do nothing 子类重新写可以覆盖改方法
    NSLog(@"viewDidTap--父类");
}

- (void)leftSwipe:(UITapGestureRecognizer *)sender
{
    //------Do nothing 子类重新写可以覆盖改方法
    NSLog(@"leftSwipe--父类");
}
- (void)rightSwipe:(UITapGestureRecognizer *)sender
{
    //------Do nothing 子类重新写可以覆盖改方法
    NSLog(@"rightSwipe--父类");
}


@end
