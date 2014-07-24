//
//  YJZPanTransition.m
//  Places
//
//  Created by Yiwen Zhan on 7/23/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZPanTransition.h"

@interface YJZPanTransition () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic) float panPercent;

@end

@implementation YJZPanTransition

- (void)addInteractionToViewController:(UIViewController *)viewController
{
    self.navController = viewController.navigationController;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [viewController.view addGestureRecognizer:panRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer
{
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES;
            self.panPercent = 0;
            [self.navController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint trans = [panRecognizer translationInView:self.navController.view];
            self.panPercent = trans.y / self.navController.view.bounds.size.height;
            [self updateInteractiveTransition:self.panPercent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            self.interactive = NO;
            [self cancelInteractiveTransition];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            self.interactive = NO;
            if (self.panPercent > 0.25) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
            break;
    }
}
@end
