//
//  UserInfoViewController.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-17.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    FLTableView *_tableView;
    
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = @"用户信息";
    self.navigationBar.backBtnTitle = @"";
    [self.navigationBar setRightButtonWithTitle:@"退出" btnBG:nil action:self selector:@selector(loginOut)];

    [self initViews];

}

- (void)initViews
{
    _tableView = [[FLTableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
    
}

- (void)loginOut
{
    UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertA addButtonWithTitle:@"取消"];
    [alertA show];

}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.userInfo.userDataArray allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    NSString *keyName = [[self.userInfo.userDataArray allKeys]  objectAtIndex:indexPath.row];
    NSString *value = [self.userInfo.userDataArray objectForKey:keyName];
    
    
//    keyName = [self getChineseStringWithStr:keyName];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@",keyName,value];
    
    return cell; //记录为0则直接返回，只显示数据加载中…
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}




- (NSString *)getChineseStringWithStr:(NSString *)keyName
{
    NSString *str = @"";
    if([keyName isEqualToString:@"dt_inst_time"])
    {
        str = @"交易发生时间";
    }
    else if([keyName isEqualToString:@"vc_sname"])
    {
        str = @"商户名称";
    }
    else if([keyName isEqualToString:@"dt_conf_time"])
    {
        str = @"交易确认时间";
    }
    else if([keyName isEqualToString:@"num_term_id"])
    {
        str = @"终端编号";
    }
    else if([keyName isEqualToString:@"num_charge_money"])
    {
        str = @"交易金额";
    }
    else if([keyName isEqualToString:@"vc_prdct_price_name"])
    {
        str = @"交易类型";
    }
    else if([keyName isEqualToString:@"vc_record_state"])
    {
        str = @"交易状态";
    }
    else if([keyName isEqualToString:@"vc_rec_status"])
    {
        str = @"记录类型";
    }
    else if([keyName isEqualToString:@"vc_merct_name"])
    {
        str = @"终端名称 ";
    }
    else if([keyName isEqualToString:@"vc_th_water_no"])
    {
        str = @"交易流水";
    }
    else if([keyName isEqualToString:@"vc_th_card_no"])
    {
        str = @"逻辑卡号";
    }
    else if([keyName isEqualToString:@"int_sell_count"])
    {
        str = @"交易笔数";
    }
    else if([keyName isEqualToString:@"dt_trade_date"])
    {
        str = @"交易时间";
    }
    else if([keyName isEqualToString:@"num_trade_count"])
    {
        str = @"交易笔数";
    }
    else if([keyName isEqualToString:@"num_trade_fee"])
    {
        str = @"交易金额";
    }
    else if([keyName isEqualToString:@"deal_time"])
    {
        str = @"交易时间";
    }
    else if([keyName isEqualToString:@"vc_card_user_id"])
    {
        str = @"身份证号";
    }
    else if([keyName isEqualToString:@"vc_card_user_name"])
    {
        str = @"持卡人姓名";
    }
    
    return str;
}



@end
