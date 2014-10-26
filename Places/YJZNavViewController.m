//
//  YJZNavViewController.m
//  Places
//
//  Created by Yiwen Zhan on 7/22/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZNavViewController.h"
#import "YJZPlaceAnim.h"
#import "YJZPanTransition.h"
#import "YJZDetailViewController.h"
#import "YJZAddViewController.h"

@interface YJZNavViewController ()

@property (strong, nonatomic) YJZPanTransition* panTransition;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[YJZDetailViewController class]]) {
        YJZPlaceAnim *anim = [[YJZPlaceAnim alloc] initWithAction:@"open"];
        return anim;
    }
    else if (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:[YJZDetailViewController class]]) {
        YJZPlaceAnim *anim = [[YJZPlaceAnim alloc] initWithAction:@"close"];
        return anim;
    }
    else if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[YJZAddViewController class]])
    {
        YJZPlaceAnim *anim = [[YJZPlaceAnim alloc] initWithAction:@"add"];
        return anim;
    }
    else if (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:[YJZAddViewController class]])
    {
        YJZPlaceAnim *anim = [[YJZPlaceAnim alloc] initWithAction:@"addRev"];
        return anim;
    }
    return nil;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
//    [self.tabBarController.tabBar setHidden:NO];
    return [super popToRootViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[YJZDetailViewController class]]) {
        if (!self.panTransition) {
            self.panTransition = [[YJZPanTransition alloc] init];
        }
        [self.panTransition addInteractionToViewController:viewController];
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.panTransition.isInteractive)
    {
        return self.panTransition;
    }
    return nil;
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
