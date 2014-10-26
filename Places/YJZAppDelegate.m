//
//  YJZAppDelegate.m
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZAppDelegate.h"
#import "YJZPlace.h"
#import "YJZPlacesViewController.h"
#import "YJZPlaceStore.h"
#import "YJZPlaceAnim.h"
#import "YJZNavViewController.h"
#import "YJZMapViewController.h"
#import "YJZConstants.h"



@implementation YJZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // controller set up

    YJZMapViewController *mvc = [[YJZMapViewController alloc] init];
    YJZNavViewController *nav0 = [[YJZNavViewController alloc] initWithRootViewController:mvc];
    nav0.tabBarItem.title = @"search";
    nav0.tabBarItem.image = [UIImage imageNamed:@"search.png"];
    
    YJZPlacesViewController *pvc = [[YJZPlacesViewController alloc] init];
    YJZNavViewController *nav1 = [[YJZNavViewController alloc] initWithRootViewController:pvc];
    nav1.tabBarItem.title = @"try";
    nav1.tabBarItem.image = [UIImage imageNamed:@"bookmark.png"];

    
    UITabBarController *tvc = [[UITabBarController alloc] init];
    tvc.viewControllers = @[nav0, nav1];
    tvc.tabBar.barTintColor = [UIColor whiteColor];
    tvc.tabBar.tintColor = BLUE_COLOR;
    self.window.rootViewController = tvc;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    BOOL success = [[YJZPlaceStore sharedStore] saveChanges];
    
    [[YJZPlaceStore sharedStore] saveChanges];

//    if (success) {
//        NSLog(@"saved all of the places");
//    } else {
//        NSLog(@"couldn't save any of the items");
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
