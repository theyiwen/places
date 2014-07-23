//
//  YJZPlaceAnim.m
//  Places
//
//  Created by Yiwen Zhan on 7/22/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZPlaceAnim.h"

@interface YJZPlaceAnim() <UIViewControllerAnimatedTransitioning>
@property NSString* action;
@property UIView* blackView;
@property CGRect screenRect;
@end

@implementation YJZPlaceAnim

-(instancetype)initWithAction:(NSString *)action
{
    self = [super init];
    if (self) {
        _action = action;
        _screenRect = [[UIScreen mainScreen] bounds];
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenRect.size.width, self.screenRect.size.height)];
        self.blackView.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.action isEqual:@"open"])
    {
        return 0.8;
    }
    else {
        return 0.4;
    }
}

- (void)animateTransitionBounceUp:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    //before
    toVC.view.backgroundColor = [UIColor clearColor];
    toVC.view.opaque = NO;
    toVC.view.frame = CGRectMake(0, self.screenRect.size.height, toVC.view.bounds.size.width, toVC.view.bounds.size.height);
    self.blackView.alpha = 0;
    
    UIView *container = [transitionContext containerView];
    
    [container addSubview:fromVC.view];
    [container addSubview:self.blackView];
    [container addSubview:toVC.view];

    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toVC.view.frame = CGRectMake(0, 0, toVC.view.bounds.size.width, toVC.view.bounds.size.height);
                         self.blackView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [fromVC.view removeFromSuperview];
                         toVC.view.backgroundColor = [UIColor blackColor];
                         [self.blackView removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    

}

- (void)animateTransitionBounceDown:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //before
    //note - using snapshot causes flicker that i can't figure out
    self.blackView.alpha = 1;
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];
    [container addSubview:self.blackView];
    [container addSubview:fromVC.view];
    
    fromVC.view.backgroundColor = [UIColor clearColor];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromVC.view.frame = CGRectMake(0, self.screenRect.size.height, fromVC.view.bounds.size.width, fromVC.view.bounds.size.height);
                         self.blackView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.blackView removeFromSuperview];
                         [fromVC.view removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    

}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.action isEqual:@"open"])
    {
        [self animateTransitionBounceUp:transitionContext];
    }
    else {
        [self animateTransitionBounceDown:transitionContext];
    }
}

# pragma mark - misc old animations

//in animation - springy version

//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        toViewSnap.frame = CGRectMake(0, 0, toViewSnap.bounds.size.width, toViewSnap.bounds.size.height);
//    } completion:^(BOOL finished) {
//        [toViewSnap removeFromSuperview];
//        [container addSubview:toVC.view];
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];

// out animations

//    [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                          delay:0
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:0.0f
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         fromViewSnap.frame = CGRectMake(0, screenRect.size.height, fromViewSnap.bounds.size.width, fromViewSnap.bounds.size.height);
//                     }
//                     completion:^(BOOL finished) {
//                         [fromViewSnap removeFromSuperview];
//                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//                     }];

//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.0f options:0 animations:^{
//        fromViewSnap.frame = CGRectMake(0, screenRect.size.height, fromViewSnap.bounds.size.width, fromViewSnap.bounds.size.height);
//    } completion:^(BOOL finished) {
//        [fromViewSnap removeFromSuperview];
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];

@end
