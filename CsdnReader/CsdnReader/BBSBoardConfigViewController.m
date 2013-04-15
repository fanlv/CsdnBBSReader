//
//  BBSBoardConfigViewController.m
//  CsdnReader
//
//  Created by Fan Lv on 13-2-1.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "BBSBoardConfigViewController.h"
#import "ConstParameterAndMethod.h"

@interface BBSBoardConfigViewController ()
{
    NSString *bbsBoardName;
    NSString *bbsIndexName;
    NSArray *dataSourceArray;
    BOOL isFirstLoad;
}

@end

@implementation BBSBoardConfigViewController

@synthesize configIndex = _configIndex;

- (void)setConfigIndex:(NSInteger)configIndex
{
    _configIndex = configIndex;
    if (self.configIndex == 0)
    {
        bbsBoardName = [ConstParameterAndMethod FirstBBSBoard];
        bbsIndexName = FIRST_BBS_BOARD;
    }
    else if (self.configIndex == 1)
    {
        bbsBoardName = [ConstParameterAndMethod SecondBBSBoard];
        bbsIndexName = SECOND_BBS_BOARD;
    }
    else
    {
        bbsBoardName = [ConstParameterAndMethod ThridBBSBoard];
        bbsIndexName = THRID_BBS_BOARD;

    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstLoad = YES;
    NSDictionary *bbsBoardList = [ConstParameterAndMethod BBSUrlList];
    NSArray *myKeys = [bbsBoardList allKeys];
    dataSourceArray = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ConstParameterAndMethod BBSUrlList] count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        int index = 0;
        for (NSString *key in dataSourceArray)
        {
            if ([key isEqualToString:bbsBoardName])
            {
                break;
            }
            index++;
        }
        NSLog(@"%d",index);
        NSIndexPath* scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }    
    cell.textLabel.text = [dataSourceArray objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:bbsBoardName])
    {
        currentIndex =indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor=RGB(81, 102, 145);
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor=[UIColor blackColor];
    }
    return cell;
}


#pragma mark - Table view delegate

int currentIndex = 0;

////初始化时调用
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == currentIndex)
//        return UITableViewCellAccessoryCheckmark;
//    else
//        return UITableViewCellAccessoryNone;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if(indexPath.row == currentIndex){
//        return;
//    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone)
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor=RGB(81, 102, 145);
        [ud setObject:newCell.textLabel.text forKey:bbsIndexName];
        [ud synchronize];
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor=[UIColor blackColor];
    }
    currentIndex = indexPath.row;
    [self dismissModalViewControllerAnimated:YES];
}

@end
