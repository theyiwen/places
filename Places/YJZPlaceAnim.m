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
@end

@implementation YJZPlaceAnim

-(instancetype)initWithAction:(NSString *)action
{
    self = [super init];
    if (self) {
        _action = action;
    }
    return self;
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.action isEqual:@"open"])
    {
        //spring version - return 0.70;
        return 0.40;
    }
    else {
        return 0.40;
    }
}

- (void)animateTransitionBounceUp:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //before
    UIView *toViewSnap = [toVC.view snapshotViewAfterScreenUpdates:YES];
    UIView *container = [transitionContext containerView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    toViewSnap.frame = CGRectMake(0, screenRect.size.height, toViewSnap.bounds.size.width, toViewSnap.bounds.size.height);
    [container addSubview:toViewSnap];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewSnap.frame = CGRectMake(0, 0, toViewSnap.bounds.size.width, toViewSnap.bounds.size.height);
                     } completion:^(BOOL finished) {
                         [toViewSnap removeFromSuperview];
                         [container addSubview:toVC.view];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
    //springy version
    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        toViewSnap.frame = CGRectMake(0, 0, toViewSnap.bounds.size.width, toViewSnap.bounds.size.height);
//    } completion:^(BOOL finished) {
//        [toViewSnap removeFromSuperview];
//        [container addSubview:toVC.view];
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
}

- (void)animateTransitionBounceDown:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //before
    //note - using snapshot causes flicker that i can't figure out
//    UIView *fromViewSnap = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    UIView *container = [transitionContext containerView];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [container addSubview:toVC.view];
    [container addSubview:fromVC.view];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromVC.view.frame = CGRectMake(0, screenRect.size.height, fromVC.view.bounds.size.width, fromVC.view.bounds.size.height);

//                         fromViewSnap.frame = CGRectMake(0, screenRect.size.height, fromViewSnap.bounds.size.width, fromViewSnap.bounds.size.height);
                     }
                     completion:^(BOOL finished) {
//                         [fromViewSnap removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
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

@end
