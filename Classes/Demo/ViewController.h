//
//  ViewController.h
//  EfunSDK_IOS
//
//  Created by czf on 13-7-31.
//  Copyright (c) 2013年 fengjiada. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *buttonsTable;
@property (nonatomic,retain) NSArray *buttonsArray;

@end
