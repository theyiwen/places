//
//  YJZPanTransition.h
//  Places
//
//  Created by Yiwen Zhan on 7/23/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJZPanTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign, getter=isInteractive) BOOL interactive;

- (void)addInteractionToViewController:(UIViewController *)viewController;

@end
