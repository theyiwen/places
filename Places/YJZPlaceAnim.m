//
//  YJZPlaceAnim.m
//  Places
//
//  Created by Yiwen Zhan on 7/22/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZPlaceAnim.h"
#import "YJZAddViewController.h"


@interface YJZPlaceAnim() <UIViewControllerAnimatedTransitioning>
@property NSString* action;
@property UIView* blackView;
@property CGRect screenRect;
@property BOOL debug;
@end

@implementation YJZPlaceAnim

-(instancetype)initWithAction:(NSString *)action
{
    self = [super init];
    if (self) {
        _action = action;
        _screenRect = [[UIScreen mainScreen] bounds];
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenRect.size.width, self.screenRect.size.height)];
        _debug = false;
        self.blackView.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.debug) {
        return 10.0;
    }
    if ([self.action isEqual:@"open"])
    {
        return 0.75;
    }
    else if ([self.action isEqual:@"close"]){
        return 0.4;
    }
    else if ([self.action isEqual:@"add"])
    {
        return 0;
    }
    else if ([self.action isEqual:@"addRev"])
    {
        return 0;
    }
    return 0;
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
         usingSpringWithDamping:0.8
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
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fromVC.view.frame = CGRectMake(0, self.screenRect.size.height, fromVC.view.bounds.size.width, fromVC.view.bounds.size.height);
                         self.blackView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         fromVC.view.backgroundColor = [UIColor blackColor];
                         [self.blackView removeFromSuperview];
                         if ([transitionContext transitionWasCancelled]) {
                             [transitionContext completeTransition:NO];
                         } else {
                             [transitionContext completeTransition:YES];
                             [fromVC.view removeFromSuperview];
                         }
                     }];
    

}

- (void)animateAddTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    YJZAddViewController *toVC = (YJZAddViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    toVC.view.backgroundColor = [UIColor clearColor];
    
    UIView *container = [transitionContext containerView];
    UIView *fromSnap = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    [container addSubview:toVC.view];
    
//    //not sure why they don't work here
//    [toVC.view insertSubview:fromSnap atIndex:0];
//    [transitionContext completeTransition:YES];

    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                     }
                     completion:^(BOOL finished) {
                         
                         if ([transitionContext transitionWasCancelled]) {
                             [transitionContext completeTransition:NO];
                         } else {
                             [transitionContext completeTransition:YES];
                             [toVC.view insertSubview:fromSnap atIndex:0];
//                             NSLog(@"post animation subviews:%i",[toVC.view.subviews count]);
                         }
                     }];
    
}

- (void)animateAddReverseTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    YJZAddViewController *fromVC = (YJZAddViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewControllerKey];

    
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];
    [container addSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

                     }
                     completion:^(BOOL finished) {
                         if ([transitionContext transitionWasCancelled]) {
                             [transitionContext completeTransition:NO];
                         } else {
                             [transitionContext completeTransition:YES];
                             [fromVC.view removeFromSuperview];
                         }
                     }];
    

}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.action isEqual:@"open"])
    {
        [self animateTransitionBounceUp:transitionContext];
    }
    else if ([self.action isEqual:@"close"]){
        [self animateTransitionBounceDown:transitionContext];
    }
    else if ([self.action isEqual:@"add"]){
        [self animateAddTransition:transitionContext];
    }
    else if ([self.action isEqual:@"addRev"])
        [self animateAddReverseTransition:transitionContext];
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
