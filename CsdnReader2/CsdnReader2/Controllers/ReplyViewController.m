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
#import "FLTextField.h"

@interface ReplyViewController ()
{
    UITextView *replyTextView;
    FLTextField *capchaTF;
}

@end


@implementation ReplyViewController


@synthesize captchaImg;
@synthesize captchaUrl;

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
    int dValue = 0;
    if ([self.captchaUrl length]>0)
    {
        
        if (self.captchaImg == nil)
        {
            NSString *url = [NSString stringWithFormat:@"http://bbs.csdn.net%@",self.captchaUrl];
            NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            self.captchaImg = [UIImage imageWithData:data];
        }
        
        
        dValue = 44;
        UIImageView *capchaImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, SCREEN_HEIGHT - 320  , 120, dValue)];
        capchaImgView.image = self.captchaImg;
        [self.view addSubview:capchaImgView];
        
        capchaTF = [[FLTextField alloc] initWithFrame:CGRectMake(130, SCREEN_HEIGHT - 320+5 , 160,dValue-10)];
        capchaTF.layer.borderWidth = 1;
        capchaTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        capchaTF.layer.cornerRadius = 5;
//        capchaTF.backgroundColor = [UIColor redColor];
        capchaTF.placeholderLabel.text = @"请输入验证码";
        capchaTF.placeholderLabel.textColor = [UIColor grayColor];
        [self.view addSubview:capchaTF];
        
        
        
    }
    
    
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 320 - dValue)];
    replyTextView.font = MID_FONT2;
    [self.view addSubview:replyTextView];
}



//authenticity_token	kx7ER7ZoEioE+6jicIy/iZb1LLtY4JxapBkqWzzBfnY=	69
//captcha	pxdfet	14
//captcha_key	2e1422bb74f46ce5a5498a8f82207e7a29832cc5	52
//commit	提交回复	43
//post[body]	Mark.关注一下。	65
//utf8	✓	14

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
    
    
    if ([self.userInfo.cookies count]>0)
    {
        [requestForm setUseCookiePersistence:NO];
        [requestForm setRequestCookies:[self.userInfo.cookies mutableCopy]];
    }
    
    if ([self.captchaUrl length]>0)
    {
//        NSLog(@"%@",captchaUrl);

        if ([capchaTF.text length]==0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        else
        {
            NSRange rang = [self.captchaUrl rangeOfString:@"code="];
            NSRange rang1 = [self.captchaUrl rangeOfString:@"&time="];
            NSString *captcha_key = [self.captchaUrl substringWithRange:NSMakeRange(rang.location+rang.length,rang1.location-rang.location-rang.length)];
            [requestForm setPostValue:capchaTF.text forKey:@"captcha"];
            [requestForm setPostValue:captcha_key forKey:@"captcha_key"];

        }
    }

    [requestForm setPostValue:@"提交回复" forKey:@"commit"];
    [requestForm setPostValue:replyTextView.text forKey:@"post[body]"];
    [requestForm startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSError *error = nil;
    
    if([responseString isEqualToString:@"验证码输入错误"])
    {
        [SVProgressHUD dismissWithError:@"验证码输入错误"];
        return;
    }
    
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
