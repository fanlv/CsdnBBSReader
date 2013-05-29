//
//  ReplyViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-2-1.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "ReplyViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "HTMLParser.h"
#import "ConstParameterAndMethod.h"

@interface ReplyViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *topBar;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;

@end

@implementation ReplyViewController

@synthesize topicId = _topicId;

- (IBAction)replyTopic:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在回复..."];
    
    //self.topicId = @"asd";

    [self.textViewContent resignFirstResponder];
    NSString *urlString = [NSString stringWithFormat:@"http://bbs.csdn.net/posts?topic_id=%@",self.topicId];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    
    
    [requestForm setPostValue:self.textViewContent.text forKey:@"post[body]"];
    [requestForm startAsynchronous];
    
   
}


//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{ //Keyboard becomes visible
//    
//    self.textViewContent.frame = CGRectMake(self.textViewContent.frame.origin.x, self.textViewContent.frame.origin.y,
//                                  self.textViewContent.frame.size.width, self.textViewContent.frame.size.height - 215 + 50); //resize
//    return YES;
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{ //keyboard will hide
//    self.textViewContent.frame = CGRectMake(self.textViewContent.frame.origin.x, self.textViewContent.frame.origin.y,
//                                  self.textViewContent.frame.size.width, self.textViewContent.frame.size.height + 215 - 50); //resize
//    return YES;
//
//}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    
    NSError *error = nil;
    //NSLog(@"%d",requestForm.responseStatusCode);
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        
        [SVProgressHUD dismissWithError:@"回复失败，网络错误"];
        return;
    }
    NSString *errorCode = [ConstParameterAndMethod isErrorPageWithHtml:responseString];
    if (errorCode != nil)
    {
        [self.textViewContent resignFirstResponder];
        NSString *errorString = [NSString stringWithFormat:@"服务器发生错误%@",errorCode];
        
        [SVProgressHUD dismissWithError:errorString afterDelay:3];

        return;
    }

    
    HTMLNode *body = [parser body];
    
    HTMLNode *flashMessages = [body findChildOfClass:@"flash_messages"];
    
    if (flashMessages == nil)
    {
        
        [SVProgressHUD dismissWithError:@"账号信息错误，请重新登录。" afterDelay:3];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"" forKey:COOKIE_USERNAME];
        [ud setObject:@"" forKey:COOKIE_USERINFO];
        [ud setObject:@"" forKey:COOKIE_USERNICK];
        [ud synchronize];
        [self dismissModalViewControllerAnimated:YES];
        return;

    }
    
    
    NSString *content = [flashMessages.allContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (content.length == 0)
    {
        [SVProgressHUD dismissWithSuccess:@"回复成功！" afterDelay:2];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        
        [SVProgressHUD dismissWithError:content afterDelay:3];
    }
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    NSString *errorDetail = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"Error: %@", errorDetail);
    [SVProgressHUD dismissWithError:@"网络异常，回复失败。"];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textViewContent becomeFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.topBar.tintColor != [ConstParameterAndMethod getUserSaveColor])
    {
        self.topBar.tintColor = [ConstParameterAndMethod getUserSaveColor];
    }
}


- (void)viewDidUnload
{
    [self setTopBar:nil];
    [self setTextViewContent:nil];
    [super viewDidUnload];
}
@end
