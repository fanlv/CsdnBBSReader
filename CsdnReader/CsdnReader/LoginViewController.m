//
//  LoginViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-22.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "HTMLParser.h"
#import "ConstParameterAndMethod.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation LoginViewController
@synthesize userNameTextField = _userNameTextField;
@synthesize passWordTextField = _passWordTextField;

- (void)viewDidLoad
{
  
    [super viewDidLoad];
    
    _userNameTextField.delegate = self;
    _passWordTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return NO;
}


- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setPassWordTextField:nil];
    [super viewDidUnload];
}


- (IBAction)login:(id)sender
{
    [SVProgressHUD showWithStatus:@"Doing Stuff"];
    [self.userNameTextField resignFirstResponder ];
    [self.passWordTextField resignFirstResponder];
    [ConstParameterAndMethod loginCsdnBbsWithUserName:self.userNameTextField.text
                                          andPassWord:self.passWordTextField.text
                                       andSetDelegate:self];
}




#pragma mark - 解析获取的HTML数据




- (void)requestFinished:(ASIHTTPRequest *)request
{
    // 获得本地 cookies 集合（在第一次请求时服务器已返回 cookies，
    NSArray *cookies = [request responseCookies];
    NSHTTPCookie *cookie = nil ;
    for (cookie in cookies)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([cookie.name isEqualToString:@"UserName"] || [cookie.name isEqualToString:@"UserInfo"])
        {
            if (![cookie.value isEqualToString:@""])
            {
                [ud setObject:cookie.value forKey:cookie.name];
            }
        }
    }
    

    NSString *responseString = [request responseString];
    NSDictionary *data = [responseString objectFromJSONString];
//    for(id key in data)
//    {
//        NSLog(@"key: %@,value: %@",key,[data objectForKey:key]);
//    }

    NSString *statusString =[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    
    if (statusString != nil && [statusString isEqualToString:@"1"])
    {
        [SVProgressHUD dismissWithSuccess:@"帐号登录成功！"];
    }
    else
    {
        [SVProgressHUD dismissWithError:@"帐号登录失败！"];
        
    }
    
       

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size.height = fittingSize.height;
    frame.size.width = 320;
    webView.frame = frame;
    //NSLog(@"%f",frame.size.height);
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSString *errorDetail = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"Error: %@", errorDetail);
    [SVProgressHUD dismissWithError:[NSString stringWithFormat:@"网络异常: %@",errorDetail]];


}



@end

















