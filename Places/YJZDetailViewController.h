//
//  YJZDetailViewController.h
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJZPlace;

@interface YJZDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) YJZPlace *place;

- (instancetype)initWithPlace:(YJZPlace *)place;
@end
