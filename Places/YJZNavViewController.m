//
//  YJZNavViewController.m
//  Places
//
//  Created by Yiwen Zhan on 7/22/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZNavViewController.h"
#import "YJZPlaceAnim.h"

@interface YJZNavViewController ()

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;


@end

@implementation YJZNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
//    UIView* view = self.navigationController.view;
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint location = [recognizer locationInView:view];
//        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
//            self.interactionController = [UIPercentDrivenInteractiveTransition new];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [recognizer translationInView:view];
//        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
//        [self.interactionController updateInteractiveTransition:d];
//    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        if ([recognizer velocityInView:view].x > 0) {
//            [self.interactionController finishInteractiveTransition];
//        } else {
//            [self.interactionController cancelInteractiveTransition];
//        }
//        self.interactionController = nil;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        YJZPlaceAnim *anim = [[YJZPlaceAnim alloc] initWithAction:@"open"];
        return anim;
    }
    else if (operation == UINavigationControllerOperationPop) {
        YJZPlaceAnim *anim = [[YJZPlaceAnim alloc] initWithAction:@"close"];
        return anim;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
