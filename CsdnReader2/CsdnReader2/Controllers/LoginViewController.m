//
//  LoginViewController.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-17.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "LoginViewController.h"
#import "FLTextField.h"
#import "ASIHTTPRequest.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface LoginViewController ()<MFMailComposeViewControllerDelegate>
{
    FLTextField *userName;
    FLTextField *password;
}

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = @"登录";
    self.navigationBar.backBtnTitle = @"";
    [self initViews];
}

- (void)initViews
{
    userName = [[FLTextField alloc] initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH - 40, 40)];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.placeholderLabel.text = @"用户名";
    userName.placeholderLabel.textColor = [UIColor grayColor];
    userName.layer.borderColor = [Orange_Color CGColor];
    userName.layer.borderWidth = 1;
    userName.font = MID_FONT;
    [self.view addSubview:userName];
    
    password = [[FLTextField alloc] initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH - 40, 40)];
    password.textAlignment = NSTextAlignmentCenter;
    password.placeholderLabel.text = @"密码";
    password.placeholderLabel.textColor = [UIColor grayColor];
    password.layer.borderColor = [Orange_Color CGColor];
    password.layer.borderWidth = 1;
    password.font = MID_FONT;
    password.secureTextEntry = YES;
    [self.view addSubview:password];
    
    
    FLImageTitleButton *loginBtn = [[FLImageTitleButton alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 40, 40)];
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_bg"] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = MID_FONT;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    
    FLImageTitleButton *feedBackBtn = [[FLImageTitleButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 40, 40)];
    feedBackBtn.backgroundColor = [UIColor orangeColor];;
    feedBackBtn.layer.cornerRadius = 3;
    [feedBackBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [feedBackBtn setTitle:@"问题反馈" forState:UIControlStateNormal];
    feedBackBtn.titleLabel.font = MID_FONT;
    [feedBackBtn addTarget:self action:@selector(feedBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedBackBtn];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginsucceed:)
                                                 name:USER_LOGIN_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed:)
                                                 name:USER_LOGIN_FAILED object:nil];
}

#pragma mark - Action


- (void)loginBtnClick
{
    if ([userName.text length] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"];
        return;
    }
    if ([password.text length] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在登录"];
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [self.userInfo loginCsdnBbsWithUserName:userName.text andPassWord:password.text];

}

- (void)feedBackBtnClick
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc != nil)
    {
        mc.mailComposeDelegate = self;
        NSString *emailAddress = @"fanlvlgh@gmail.com";
        [mc setToRecipients:[NSArray arrayWithObject:emailAddress]];
        [mc setSubject:[NSString stringWithFormat:@"CSDN论坛阅读器%@反馈",APP_VERSION] ];
        [self presentViewController:mc animated:YES completion:nil];// presentModalViewController:mc animated:YES];
    }
 
}

#pragma mark - NSNotificationCenter

- (void)userLoginsucceed:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userInfo.userName = userName.text;
        self.userInfo.password = password.text;
        [MUser saveData];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)userLoginFailed:(NSNotification *)note
{
    [SVProgressHUD showErrorWithStatus:note.object];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end



















