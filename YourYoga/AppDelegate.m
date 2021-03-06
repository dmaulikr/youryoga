//
//  AppDelegate.m
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <NanigansSDK/NanigansSDK.h>

#import "AppDelegate.h"

NSString* S_NotifyImportFile = @"ImportFile";
//NSString* S_NotifyImportFile = @"ImportFile";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if (url != nil && [url isFileURL]) {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc]init];
        NSString* file = [url absoluteString];
        [userInfo setObject:file forKey:S_NotifyImportFile];
                                         
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ImportFile" object:nil userInfo:userInfo];
        
        if ([[url pathExtension] isEqualToString:@"yytraining"]) {
            
            NSLog(@"URL:%@", [url absoluteString]);
            
        }
        return YES;
    }
   
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
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
    [FBSDKAppEvents activateApp];
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
