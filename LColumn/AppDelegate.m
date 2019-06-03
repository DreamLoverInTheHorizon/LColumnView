//
//  AppDelegate.m
//  LColumn
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    firstVC.title = @"效果一";
    firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"效果一" image:[UIImage imageNamed:@"shouye"] selectedImage:[UIImage imageNamed:@"shouye_"]];
    //
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.title = @"效果二";
    secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"效果二" image:[UIImage imageNamed:@"wode"] selectedImage:[UIImage imageNamed:@"wode_"]];
    //
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:firstVC];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:secondVC];
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    [tabVC addChildViewController:nav1];
    [tabVC addChildViewController:nav2];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
