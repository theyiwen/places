//
//  YJZAddViewController.h
//  Places
//
//  Created by Yiwen Zhan on 7/24/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJZAddViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *overlay;
@property (weak, nonatomic) IBOutlet UIView *addView;



@end
