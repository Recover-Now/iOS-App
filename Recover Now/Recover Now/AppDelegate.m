//
//  AppDelegate.m
//  Recover Now
//
//  Created by Cliff Panos on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "AppDelegate.h"
#import "RNUser.h"
#import "Constants.h"
#import "Recover_Now-Swift.h"
#import "ResourceDetailTableViewController.h"
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    
    if (![Accounts userIsLoggedIn]) {
        UIStoryboard* loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:NSBundle.mainBundle];
        self.window.rootViewController = [loginStoryboard instantiateInitialViewController];
    }
    
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"Opening URL %@", [url absoluteString]);
    if ([[url host] isEqualToString:@"resource"]) {
        NSString* identifier = [url pathComponents][1];
        NSLog(@"Parsed identifier %@ from URL", identifier);
        FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
        [fbService retrieveDataForIdentifier:identifier completion:^(FirebaseObject * _Nonnull obj) {
            RNResource* res = (RNResource*)obj;
            UINavigationController* navVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"resourceDetailVCNav"];
            navVC.modalPresentationStyle = UIModalPresentationPageSheet;
            ((ResourceDetailTableViewController*)navVC.viewControllers[0]).resource = res;
            [self.window.rootViewController presentViewController:navVC animated:true completion:nil];
        }];
        return YES;
    }
    return NO;
}


@end
