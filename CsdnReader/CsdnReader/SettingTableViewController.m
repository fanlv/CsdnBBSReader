//
//  SettingTableViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-30.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "SettingTableViewController.h"
#import "ConstParameterAndMethod.h"
#import "BBSBoardConfigViewController.h"

@interface SettingTableViewController ()

@end


@implementation SettingTableViewController



static bool isUserLoginTemp = NO;

- (void)viewWillAppear:(BOOL)animated
{
    //if ([ConstParameterAndMethod isUserLogin] != isUserLoginTemp)
    {
        [self.tableView reloadData];
        [ConstParameterAndMethod RefreshTabBarController:self.tabBarController];
    }


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    self.navigationItem.title = @"设置";
    isUserLoginTemp = [ConstParameterAndMethod isUserLogin];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        if ([ConstParameterAndMethod isUserLogin])
            return 2;
        else
            return 1;
    
    }
    return 3;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.detailTextLabel.text = [ConstParameterAndMethod FirstBBSBoard];
                break;
            case 1:
                cell.detailTextLabel.text = [ConstParameterAndMethod SecondBBSBoard];
                break;
            case 2:
                cell.detailTextLabel.text = [ConstParameterAndMethod ThridBBSBoard];
                break;
        }
    }
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                if ([ConstParameterAndMethod isUserLogin])
                {
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSString *userName = [ud objectForKey:COOKIE_USERNAME];
                    cell.textLabel.text = [NSString stringWithFormat:@"当前账号：%@",userName];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    cell.textLabel.text = @"登录";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                break;
            }
            case 1:
                cell.textLabel.text = @"退出登录";
                break;
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConfigBBSBoard"])
    {
        BBSBoardConfigViewController *bbsBoardConfigViewController = [segue destinationViewController];
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        [bbsBoardConfigViewController setConfigIndex:selectedRowIndex.row];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"ConfigBBSBoard" sender:self];
    }
    
    if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0)
        {
            if (![ConstParameterAndMethod isUserLogin])
            {
                [self performSegueWithIdentifier:@"Login" sender:self];
            }
        }
        
        if (indexPath.row == 1)
        {
            //创建对话框 
            UIAlertView * alertA= [[UIAlertView alloc] initWithTitle:@"" message:@"退出登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //添加取消按钮
            [alertA addButtonWithTitle:@"取消"];
            alertA.delegate = self;
            //将这个UIAlerView 显示出来
            [alertA show];
        }
        
   
      
    }

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"" forKey:COOKIE_USERNAME];
        [ud setObject:@"" forKey:COOKIE_USERINFO];
        [self.tableView reloadData];
        isUserLoginTemp = NO;
    }
    else
    {
        NSIndexPath *cancle = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView deselectRowAtIndexPath:cancle animated:NO];
    }
}


@end
