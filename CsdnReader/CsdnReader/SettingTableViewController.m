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
#import <MessageUI/MFMailComposeViewController.h>
#import <ShareSDK/ShareSDK.h>




@interface SettingTableViewController ()<MFMailComposeViewControllerDelegate>

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
    return 5;
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
            case 3:
                cell.detailTextLabel.text = @"";
                break;
            case 4:
            {

                NSString *version = [ConstParameterAndMethod GetAppVersion];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"程序版本号：%@",version];
                break;
            }
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

#pragma mark - Mail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row < 3)
        {
            [self performSegueWithIdentifier:@"ConfigBBSBoard" sender:self];
        }
        else if (indexPath.row == 3)
        {
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
              if (mc != nil)
            {     
                mc.mailComposeDelegate = self;                
                NSString *emailAddress = @"fanlvlgh@gmail.com";
                [mc setToRecipients:[NSArray arrayWithObject:emailAddress]];
                NSString *version = [ConstParameterAndMethod GetAppVersion];
                [mc setSubject:[NSString stringWithFormat:@"CSDN论坛阅读器%@意见反馈",version] ];
                [self presentModalViewController:mc animated:YES];
            }
            else
            {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
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
- (IBAction)share:(UIBarButtonItem *)sender
{
    

    

    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"Csdn阅读器" shareViewDelegate:nil];
    


    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"IOS上的#CSDN阅读器#，让你浏览CSDN更方便。https://itunes.apple.com/cn/app/csdnreader/id599235208"
                                       defaultContent:@""
                                                image:nil//[ShareSDK imageWithPath:imagePath]
                                                title:@"CSDN阅读器"
                                                  url:@""
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
                                }
                            }];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"" forKey:COOKIE_USERNAME];
        [ud setObject:@"" forKey:COOKIE_USERINFO];
        [ud synchronize];
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
