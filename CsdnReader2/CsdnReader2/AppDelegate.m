//
//  AppDelegate.m
//  CsdnReader2
//
//  Created by Fan Lv on 14-10-14.
//  Copyright (c) 2014年 Fanlv. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mainQueue;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //---------------------------------------------Init HTTP NSOperationQueue
    mainQueue = [[NSOperationQueue alloc] init] ;
    [self.mainQueue setMaxConcurrentOperationCount:30];
    //---------------------------------------------Keyboard Init
//    [self initKeyboard:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [MUser saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - init KeyBoard

- (void)initKeyboard:(BOOL)b
{
    //------------------------------------------------------------------Keyboard Init
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:b];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:b];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:b];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:b];
    //---------------------------------------------------------------------------------
}


@end
