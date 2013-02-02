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
#import "JYTextField.h"

@interface LoginViewController ()<UITextFieldDelegate,UIWebViewDelegate>
{
    JYTextField *userNameTextField;
	JYTextField *passWordTextField;
}
@end

@implementation LoginViewController


- (void)viewDidLoad
{
  
    [super viewDidLoad];
    
    userNameTextField = [[JYTextField alloc]initWithFrame:CGRectMake(80, 50, 180, 38)
								  cornerRadio:5
								  borderColor:RGB(166, 166, 166)
								  borderWidth:2
								   lightColor:RGB(55, 154, 255)
									lightSize:8
							 lightBorderColor:RGB(235, 235, 235)];
	//[userNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[userNameTextField setPlaceholder:@"用户名"];
	[self.view addSubview:userNameTextField];
    
	passWordTextField = [[JYTextField alloc]initWithFrame:CGRectMake(80, 115, 180, 38)
								  cornerRadio:5
								  borderColor:RGB(166, 166, 166)
								  borderWidth:2
								   lightColor:RGB(55, 154, 255)
									lightSize:8
							 lightBorderColor:RGB(235, 235, 235)];
	//[passWordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[passWordTextField setPlaceholder:@"密码"];
	[passWordTextField setSecureTextEntry:YES];
	[self.view addSubview:passWordTextField];
    
    userNameTextField.delegate = self;
    passWordTextField.delegate = self;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (IBAction)login:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [userNameTextField resignFirstResponder ];
    [passWordTextField resignFirstResponder];
    [ConstParameterAndMethod loginCsdnBbsWithUserName:userNameTextField.text
                                          andPassWord:passWordTextField.text
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
        if ([cookie.name isEqualToString:COOKIE_USERNAME] || [cookie.name isEqualToString:COOKIE_USERINFO])
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
        //[self dismissModalViewControllerAnimated:YES];
        //[self.navigationController popToViewController:viewController animated:YES];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
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

















