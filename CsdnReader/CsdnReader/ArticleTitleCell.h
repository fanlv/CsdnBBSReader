//
//  ArticleTitleCell.h
//  CsdnReader
//
//  Created by Fan Lv on 13-1-11.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorAndDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@end
