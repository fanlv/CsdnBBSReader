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

@interface ReplyViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *topBar;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;

@end

@implementation ReplyViewController

@synthesize topicId = _topicId;

- (IBAction)replyTopic:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在回复..."];

    NSString *urlString = [NSString stringWithFormat:@"http://bbs.csdn.net/posts?topic_id=%@",_topicId];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    [requestForm setPostValue:self.textViewContent.text forKey:@"post[body]"];
    [requestForm startAsynchronous];
    
   
}


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
    
    HTMLNode *body = [parser body];
    
    HTMLNode *flashMessages = [body findChildOfClass:@"flash_messages"];
    
    if (flashMessages == nil)
    {
        
        [SVProgressHUD dismissWithError:@"账号信息错误，请重新登录。" afterDelay:3];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"" forKey:COOKIE_USERNAME];
        [ud setObject:@"" forKey:COOKIE_USERINFO];
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
    self.topBar.tintColor = [UIColor purpleColor];
    [self.textViewContent becomeFirstResponder];
    
}



- (void)viewDidUnload {
    [self setTopBar:nil];
    [self setTextViewContent:nil];
    [super viewDidUnload];
}
@end
