//
//  MainViewController.m
//  Droponto
//
//  Created by Fan Lv on 14-3-19.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "MainViewController.h"
#import "CategoryArticlesViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"


@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    FLTableView *_tableView;
}
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = @"CSDN阅读器";
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)initViews
{
    _tableView = [[FLTableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - DEVICE_STATUS_BAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed1:)
                                                 name:USER_LOGIN_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginsucceed1:)
                                                 name:USER_LOGIN_SUCCEED object:nil];

    
    if (self.userInfo.isLogin)
    {
        [self.userInfo loginCsdnBbsWithUserName:self.userInfo.userName andPassWord:self.userInfo.password];
    }
    else
    {
        [self.navigationBar setRightButtonWithTitle:@"登录" btnBG:nil action:self selector:@selector(gotoLogin)];
    }

}


#pragma mark - Action

- (void)gotoLogin
{
    if(self.userInfo.isLogin)
    {
        UserInfoViewController *vc= [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        LoginViewController *vc= [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - NSNotificationCenter

- (void)userLoginsucceed1:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationBar setRightButtonWithTitle:@"用户信息" btnBG:nil action:self selector:@selector(gotoLogin)];
        self.userInfo.bbsUrlList = nil;
        [_tableView reloadData];

    });
    
}

- (void)userLoginFailed1:(NSNotification *)note
{
    if ([self.navigationController.viewControllers count] == 1 &&note.object)
    {
            [SVProgressHUD showErrorWithStatus:note.object];
     }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userInfo resetData];
        [self.navigationBar setRightButtonWithTitle:@"登录" btnBG:nil action:self selector:@selector(gotoLogin)];
        [_tableView reloadData];
    });
}



#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.userInfo.bbsUrlList allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PlaceholderCellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:PlaceholderCellIdentifier];
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
    }
    
    NSArray *keyArray = [self.userInfo.bbsUrlList allKeys];
    NSArray *resultArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    NSString *keyName = [resultArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [keyName substringFromIndex:3];//[[bbsUrlList allKeys] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell; //记录为0则直接返回，只显示数据加载中…
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *keyName = [[bbsUrlList allKeys] objectAtIndex:indexPath.row];
    
    
    NSArray *keyArray = [self.userInfo.bbsUrlList allKeys];
    NSArray *resultArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *keyName = [resultArray objectAtIndex:indexPath.row];
    NSString *url = [self.userInfo.bbsUrlList objectForKey:keyName];
    
    CategoryArticlesViewController *vc = [[CategoryArticlesViewController alloc] init];
    vc.title = [keyName substringFromIndex:3];
    vc.bbsCatgoryUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



@end
