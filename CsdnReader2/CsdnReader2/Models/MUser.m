//
//  MUser.m
//  Droponto
//
//  Created by Fan Lv on 14-4-8.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "MUser.h"
#import "ASIHTTPRequest.h"


static MUser *mUser = nil;


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
    
    userNameStr = [userNameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *getCookieUrl = [NSString stringWithFormat:
                              @"https://passport.csdn.net/ajax/accounthandler.ashx?t=log&u=%@&p=%@&remember=1&f=h&rand=0.6"
                              ,userNameStr,passWordStr];
    NSURL *url2 = [NSURL URLWithString:getCookieUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url2];
    [request setDelegate:self];
    [request setUseCookiePersistence:YES];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Referer" value:@"https://passport.csdn.net/account/loginbox"];
    [request startAsynchronous];
}


#pragma mark  解析获取的HTML数据




- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *data = [responseString JSONValue];
    NSString *statusString =[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    
    if (statusString != nil && [statusString isEqualToString:@"1"])
    {
        MUser *user = [MUser getInstance];
        
        user.userDataArray = [data objectForKey:@"data"];
        
        // 获得本地 cookies 集合（在第一次请求时服务器已返回 cookies，
        NSArray *responseCookies = [request responseCookies];
        user.cookies = responseCookies;
        NSHTTPCookie *cookie = nil ;
        for (cookie in responseCookies)
        {
//            if (![cookie.value isEqualToString:@""])
//            {
//                NSLog(@"vaule: %@, name : %@",cookie.value ,cookie.name);
//            }
            if ([cookie.name isEqualToString:COOKIE_USERNICK])
            {
                user.userNick = cookie.value;
            }
            if ([cookie.name isEqualToString:COOKIE_USERNAME])
            {
                user.userName = cookie.value;
            }
        }
        user.isLogin = YES;
        [MUser saveData];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_SUCCEED object:nil];

    }
    else
    {
        NSString *errorString =[NSString stringWithFormat:@"%@",[data objectForKey:@"error"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:errorString];

    }
    
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
