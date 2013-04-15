//
//  AddFavoriteViewController.h
//  CsdnReader
//
//  Created by Fan Lv on 13-4-7.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"

@interface AddFavoriteViewController : UIViewController<UIKeyboardViewControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
}

@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strwebSite;

@end
