//
//  ReplyViewController.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-17.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "ReplyViewController.h"
#import "HTMLParser.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"

@interface ReplyViewController ()
{
    UITextView *replyTextView;
}

@end

@implementation ReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = @"用户信息";
    self.navigationBar.backBtnTitle = @"";
    [self.navigationBar setRightButtonWithTitle:@"提交" btnBG:nil action:self selector:@selector(gotoReply)];

    [self initViews];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [replyTextView becomeFirstResponder];
}

- (void)initViews
{
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 320)];
    replyTextView.font = MID_FONT2;
    [self.view addSubview:replyTextView];
}

- (void)gotoReply
{
    if ([replyTextView.text length]==0)
    {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在回复..."];
    
    [replyTextView resignFirstResponder];
    NSString *urlString = [NSString stringWithFormat:@"http://bbs.csdn.net/posts?topic_id=%@",self.topicId];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    
    [requestForm setPostValue:replyTextView.text forKey:@"post[body]"];
    [requestForm startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        [SVProgressHUD dismissWithError:@"回复失败，网络错误"];
        return;
    }
    NSString *errorString = [GlobalData isErrorPageWithHtml:responseString];
    if (errorString != nil)
    {
        [replyTextView resignFirstResponder];
        [SVProgressHUD dismissWithError:errorString afterDelay:3];
        return;
    }
    
    
    HTMLNode *body = [parser body];
    HTMLNode *flashMessages = [body findChildOfClass:@"flash_messages"];
    if (flashMessages == nil)
    {
        [SVProgressHUD dismissWithError:@"账号信息错误，请重新登录。" afterDelay:3];
        [self.userInfo resetData];
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *vc= [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
        return;
        
    }
    NSString *content = [flashMessages.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0)
    {
        [SVProgressHUD dismissWithSuccess:@"回复成功！" afterDelay:3];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD dismissWithError:content afterDelay:3];
    }
    
    
    
}


@end
