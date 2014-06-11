//
//  moviesAppDelegate.m
//  movies
//
//  Created by piyush shah on 6/10/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "moviesAppDelegate.h"
#import "MoviesViewController.h"

@implementation moviesAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MoviesViewController *vc = [[MoviesViewController alloc] init];
    
    UINavigationController *uvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    uvc.navigationBar.barTintColor = [UIColor purpleColor];
    uvc.navigationBar.translucent = NO;
    
    self.window.rootViewController = uvc;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //http://blog.originate.com/blog/2014/02/20/afimagecache-vs-nsurlcache/
    //
    //
    //Here we declare a shared NSURLCache with 2mb of memory and 100mb of disk space
    
    //For Image caching that is used by AFNetworking
    // NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
    //                                                         diskCapacity:200 * 1024 * 1024
    //                                                         diskPath:nil];
    //[NSURLCache setSharedURLCache:URLCache];
        
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
