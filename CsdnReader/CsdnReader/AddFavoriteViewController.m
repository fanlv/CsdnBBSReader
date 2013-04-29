//
//  AddFavoriteViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-4-7.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "AddFavoriteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "HTMLParser.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"
#import "ConstParameterAndMethod.h"

@interface AddFavoriteViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *topBar;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfWebSite;
@property (weak, nonatomic) IBOutlet UITextField *tfTag;
@property (weak, nonatomic) IBOutlet UITextView *tfDescription;

@property (strong,nonatomic) SSCheckBoxView *cbv;

@end

@implementation AddFavoriteViewController

@synthesize strTitle = _strTitle;
@synthesize strwebSite = _strwebSite;
@synthesize cbv = _cbv;


- (SSCheckBoxView *)cbv
{
    if(_cbv == nil)
    {
        
        CGRect frame = CGRectMake(66, 320, 240, 30);
        SSCheckBoxViewStyle style = (7 % kSSCheckBoxViewStylesCount);
        _cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                               style:style
                                             checked:YES];
        [_cbv setText:@"公共，和大家一起分享"];
    }
    return _cbv;
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
	[keyBoardController addToolbarToKeyboard];
    if (self.topBar.tintColor != [ConstParameterAndMethod getUserSaveColor])
    {
        self.topBar.tintColor = [ConstParameterAndMethod getUserSaveColor];
    }
    
}



-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    keyBoardController = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tfDescription.layer.borderColor = [UIColor grayColor].CGColor;
    self.tfDescription.layer.borderWidth =1.0;
    self.tfDescription.layer.cornerRadius =5.0;
    
    self.tfWebSite.text = self.strwebSite;
    self.tfTitle.text = self.strTitle;
    
    
    

    [self.view addSubview:self.cbv];


}
- (IBAction)saveBtnClick:(id)sender
{
    //string postData = "title=biaoti&url=http://bbs.csdn.net/topics/390416892&txt_tag=123&description=456&share=1";
    [SVProgressHUD showWithStatus:@"正在提交..."];

    NSString *urlString = @"http://my.csdn.net/index.php/my/favorite/do_add/1";
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.delegate = self;
    [requestForm setPostValue:self.tfTitle.text forKey:@"title"];
    [requestForm setPostValue:self.tfWebSite.text forKey:@"url"];
    [requestForm setPostValue:self.tfTag.text forKey:@"txt_tag"];
    [requestForm setPostValue:self.tfDescription.text forKey:@"description"];
    if (self.cbv.checked)
    {
        [requestForm setPostValue:@"1" forKey:@"share"];
    }

    [requestForm startAsynchronous];
}

#pragma mark - 解析获取的HTML数据


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSError *error = nil;
    //NSLog(@"%d",requestForm.responseStatusCode);
    HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
    if (error)
    {
        [SVProgressHUD dismissWithError:@"操作失败，网络错误"];
        return;
    }
    
    HTMLNode *body = [parser body];

    NSString *content = [body allContents];
    
    NSLog(@"%@",content);
    
    if ([content rangeOfString:@"收藏成功"].location == NSNotFound)
    {
        [SVProgressHUD dismissWithError:@"操作失败"];
    } else
    {
        [SVProgressHUD dismissWithSuccess:@"收藏成功"];
        [self dismissModalViewControllerAnimated:YES];

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

- (void)viewDidUnload {
    [self setTopBar:nil];
    [self setTfTitle:nil];
    [self setTfWebSite:nil];
    [self setTfTag:nil];
    [self setTfDescription:nil];
    [super viewDidUnload];
}
@end
