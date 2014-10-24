//
//  MUser.h
//  Droponto
//
//  Created by Fan Lv on 14-4-8.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "BaseData.h"
#import "GlobalData.h"


@interface MUser : BaseData

+(MUser *)getInstance;

@property (nonatomic,assign) BOOL      isLogin;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userNick;
@property (nonatomic,strong) NSArray  *cookies;
@property (nonatomic,strong) NSDictionary  *userDataArray;
@property (nonatomic,strong) NSMutableDictionary *bbsUrlList;


+ (void) saveData;
- (void)resetData;
- (void)loginCsdnBbsWithUserName:(NSString *)userNameStr andPassWord:(NSString *)passWordStr;

@end
