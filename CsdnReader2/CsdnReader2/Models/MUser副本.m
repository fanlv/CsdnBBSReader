//
//  MUser.m
//  Droponto
//
//  Created by Fan Lv on 14-4-8.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "MUser.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HttpTask.h"
#import "HTMLParser.h"


static MUser *mUser = nil;


@interface MUser ()<MyHandleDelegate>

@end


@implementation MUser

#pragma mark - Static Method
@synthesize userName,password,isLogin,userNick,cookies,userDataArray;
@synthesize bbsUrlList = _bbsUrlList;


- (NSMutableDictionary *)bbsUrlList
{
    if (_bbsUrlList == nil)
    {
        _bbsUrlList = [[NSMutableDictionary alloc] init];
        if(self.isLogin)
        {
            NSString *tmpUrl = [NSString stringWithFormat:@"http://bbs.csdn.net/users/%@/topics",self.userName];
            [_bbsUrlList setObject:tmpUrl                                       forKey:@"00_我发布的帖子"];
            [_bbsUrlList setObject:@"http://bbs.csdn.net/user/pointed_topics"   forKey:@"01_我得分的帖子"];
            [_bbsUrlList setObject:@"http://bbs.csdn.net/user/replied_topics"   forKey:@"02_我回复的帖子"];
        }
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/DotNET"         forKey:@"03_.NET"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Java"           forKey:@"04_JAVA"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/WebDevelop"     forKey:@"05_WEB开发"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/MSSQL"          forKey:@"06_MS-SQL"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/VC"             forKey:@"07_VC/MFC"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/VB"             forKey:@"08_VB"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Delphi"         forKey:@"09_Delphi"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Cpp"            forKey:@"10_C/C++"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/BCB"            forKey:@"11_C++ Builder"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/PowerBuilder"   forKey:@"12_PowerBuilder"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Oracle"         forKey:@"13_Oracle"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/OtherDatabase"  forKey:@"14_其他数据库开发"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Embedded"       forKey:@"15_嵌入式开发"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Mobile"         forKey:@"16_移动平台"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/CAREER"         forKey:@"17_挨踢职涯"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Other"          forKey:@"18_扩充话题"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Support"        forKey:@"19_社区支持"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/Windows"        forKey:@"20_Windows社区"];
        [_bbsUrlList setObject:@"http://bbs.csdn.net/forums/PHP"            forKey:@"21_PHP"];
    }
    return _bbsUrlList;
}


+(MUser *)getInstance
{
    if (!mUser)
    {
        mUser = [self loadUserData];
    }
    return mUser;
}




#pragma mark - LoginCsdnBbsWithUserName



- (void)loginCsdnBbsWithUserName:(NSString *)userNameStr andPassWord:(NSString *)passWordStr
{

    NSString *requestURL = @"http://passport.csdn.net/account/login";
    NSURL *urltmp = [NSURL URLWithString:requestURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urltmp];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; WOW64; Trident/4.0; SLCC1)"];
    [request addRequestHeader:@"Host" value:@"passport.csdn.net"];
    [request setRequestMethod:@"GET"];
    
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = request.responseString;//[request responseString];
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:response error:&error];
        if (error)
        {
            return;
        }
        
        
        NSString *ltValue =@"";
        NSString *executionValue = @"";
        NSString *actionUrl = @"";
        
        
        HTMLNode *bodyNode = [parser body];
        HTMLNode *formNode = [bodyNode findChildTag:@"form"];
        actionUrl = [formNode getAttributeNamed:@"action"];
        
        
        
        NSArray *inputNodes = [bodyNode findChildTags:@"input"];
        
        for (HTMLNode *node in inputNodes)
        {
            NSString *name = [node getAttributeNamed:@"name"];
            if ([[name lowercaseString] isEqualToString:@"lt"])
            {
                ltValue = [node getAttributeNamed:@"value"];
            }
            else if ([[name lowercaseString] isEqualToString:@"execution"])
            {
                executionValue = [node getAttributeNamed:@"value"];
            }
        }
        
        NSMutableArray *responseCookies1 = [[request responseCookies] mutableCopy];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            userName = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *urlString = [NSString stringWithFormat:@"https://passport.csdn.net%@",actionUrl];
            ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            requestForm.delegate = self;
            [request setRequestMethod:@"POST"];

//            [requestForm setValidatesSecureCertificate:NO];//请求https的时候，就要设置这个属性
            
            [requestForm addRequestHeader:@"User-Agent" value:@"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; WOW64; Trident/4.0; SLCC1)"];
            [requestForm addRequestHeader:@"Referer" value:@"https://passport.csdn.net/account/login"];
            [requestForm addRequestHeader:@"Host" value:@"passport.csdn.net"];

            
            
            [requestForm setPostValue:userNameStr forKey:@"username"];
            [requestForm setPostValue:passWordStr forKey:@"password"];
            [requestForm setPostValue:ltValue forKey:@"lt"];
            [requestForm setPostValue:executionValue forKey:@"execution"];
            [requestForm setPostValue:@"submit" forKey:@"_eventId"];
            [requestForm setRequestCookies:responseCookies1];
            [requestForm startAsynchronous];
            
        });

        
    }
    
    
    
    
    
    
}



#pragma mark  解析获取的HTML数据

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
//    NSDictionary *data = [responseString JSONValue];
//    NSString *statusString =[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    NSArray *responseCookies1 = [request responseCookies];
    
//    if (statusString != nil && [statusString isEqualToString:@"1"])
    {
        MUser *user = [MUser getInstance];
        
//        user.userDataArray = [data objectForKey:@"data"];
//        
//        // 获得本地 cookies 集合（在第一次请求时服务器已返回 cookies，
//        NSArray *responseCookies = [request responseCookies];
//        user.cookies = responseCookies;
////        NSMutableArray *tmpCookieArray = [[NSMutableArray alloc] init];
//        NSHTTPCookie *cookie = nil;
//        for (cookie in responseCookies)
//        {
////            if (![cookie.value isEqualToString:@""])
//            {
//                NSLog(@"name: %@, vaule : %@",cookie.name ,cookie.value);
//            }
//
//            if ([cookie.name isEqualToString:COOKIE_USERNICK])
//            {
//                user.userNick = cookie.value;
//            }
//            if ([cookie.name isEqualToString:COOKIE_USERNAME])
//            {
//                user.userName = cookie.value;
//            }
//            
//        }

        user.cookies =responseCookies1;
        user.isLogin = YES;
        [MUser saveData];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_SUCCEED object:nil];

    }
//    else
//    {
//        NSString *errorString =[NSString stringWithFormat:@"%@",[data objectForKey:@"error"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:errorString];
//
//    }
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSString *errorDetail = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"Error: %@", errorDetail);
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:[NSString stringWithFormat:@"网络异常: %@",errorDetail]];

    
}



#pragma mark - Save & Load UserData

- (void)resetData;
{
    isLogin =  NO;
    NSDictionary *dict = [[NSDictionary alloc] init];
    userName           = [dict objectForKey:@"UserName"];
    password           = [dict objectForKey:@"Password"];
    userNick           = [dict objectForKey:@"userNick"];
    cookies            = [dict objectForKey:@"cookies"];
    userDataArray      = [dict objectForKey:@"userDataArray"];
    _bbsUrlList = nil;
    [self setUpNilString];
    [MUser saveData];
}

+ (void) saveData
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    MUser *user = [MUser getInstance];
    [dataDict setObject:user forKey:@"user"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"userData"];
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
}


+ (MUser *)loadUserData
{
    MUser *user;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"userData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([savedData objectForKey:@"user"] != nil) {
            user =[savedData objectForKey:@"user"];
        }
    }
    if (!user)
        user = [[MUser alloc] init];
    return  user;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:isLogin       forKey:@"isLogin"];
    [coder encodeObject:userName    forKey:@"UserName"];
    [coder encodeObject:password    forKey:@"Password"];
    [coder encodeObject:userNick    forKey:@"userNick"];
    [coder encodeObject:cookies     forKey:@"cookies"];
    [coder encodeObject:userDataArray     forKey:@"userDataArray"];

}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self)
    {
        isLogin            = [coder decodeBoolForKey:@"isLogin"];
        userName           = [coder decodeObjectForKey:@"UserName"];
        password           = [coder decodeObjectForKey:@"Password"];
        userNick           = [coder decodeObjectForKey:@"userNick"];
        cookies            = [coder decodeObjectForKey:@"cookies"];
        userDataArray            = [coder decodeObjectForKey:@"userDataArray"];


    }
    return self;
}





@end
