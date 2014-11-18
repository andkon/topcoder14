//
//  AppDelegate.m
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "ConfirmTransactionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *settings = @{
                               UITextAttributeFont                 :  [UIFont fontWithName:@"Courier New" size:20.0],
                               UITextAttributeTextColor            :  [UIColor darkGrayColor],
                               UITextAttributeTextShadowColor      :  [UIColor whiteColor],
                               UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetZero]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:settings];

    
    // Override point for customization after application launch.
    application.applicationIconBadgeNumber = 0;
    
    UIMutableUserNotificationAction *approveAction = [[UIMutableUserNotificationAction alloc] init];
    approveAction.identifier = @"APPROVE_IDENTIFIER";
    approveAction.title = @"Approve";
    approveAction.activationMode = UIUserNotificationActivationModeForeground;
    approveAction.destructive = NO;
    approveAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
    approveAction.identifier = @"REJECT_IDENTIFIER";
    approveAction.title = @"Reject";
    approveAction.activationMode = UIUserNotificationActivationModeForeground;
    approveAction.destructive = YES;
    approveAction.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *messageCategory = [[UIMutableUserNotificationCategory alloc] init];
    messageCategory.identifier = @"MESSAGE_CATEGORY";
    [messageCategory setActions:@[approveAction, rejectAction] forContext:UIUserNotificationActionContextDefault];
    [messageCategory setActions:@[approveAction, rejectAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObject:messageCategory];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    if(launchOptions!=nil){
        NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
        NSLog(@"%@",msg);
        [self createAlert:msg];
    }
    return YES;
}

#pragma mark - Notifications
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSLog(@"deviceToken: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    NSLog(@"Failed to register with error : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // For handling the notifications you received, either while the app was open or closed.
    application.applicationIconBadgeNumber = 0;
    NSString *msg = [NSString stringWithFormat:@"%@", userInfo];
    NSLog(@"Butts: %@",msg);
    if ([self.window.rootViewController class] == [UINavigationController class]) {
        ConfirmTransactionViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmVC"];
        vc.bitcoinAmount = userInfo[@"btc"];
        vc.transactionId = userInfo[@"id"];
        vc.address = userInfo[@"to_address"];
        UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
        [navVC pushViewController:vc animated:YES];
    } else {
        [self createAlert:@"Your Nymi hasn't verified you."];
    }
}

- (void)application:(UIApplication *) application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)notification completionHandler:(void (^)())completionHandler{
    if ([identifier isEqualToString:@"APPROVE_IDENTIFIER"]){
        // if you approved it:
        // check your nymi status then
        // call the api
    } else if ([identifier isEqualToString:@"REJECT_IDENTIFIER"]){
        // if you rejected it:
        [self createAlert:@"You successfully canceled the transaction."];
    }
    completionHandler();
}

- (void)createAlert:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You can't do that yet." message:[NSString stringWithFormat:@"%@", msg]delegate:self cancelButtonTitle:@"Sign in with Nymi" otherButtonTitles:nil];
    [alertView show];}

#pragma mark - Boring ol' uiapplicationdelegate stuff
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
