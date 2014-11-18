//
//  AppDelegate.m
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"

@interface AppDelegate ()

@property BOOL nymiProvisioned;


@end

@implementation AppDelegate
@synthesize myNcl, nymiProvisioned;

- (NSString *)permaStorageFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"butts.archive"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Find stored credentials
    NSString *filePath = [self permaStorageFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.provisionDetails = [unarchiver decodeObjectForKey:@"provisionDetails"];
        NSLog(@"Got provisioning details.");
        NSLog(@"%@, %@)", [self.provisionDetails objectForKey:@"id"], [self.provisionDetails objectForKey:@"key"]);
    }

    self.myNcl = [[NclWrapper alloc] init];
    [self.myNcl setNclDelegate:self];
    
    return YES;
}

-(void)incomingNclEvent:(NclEvent *)nclEvent
{
    NclEvent currentEvent = *nclEvent;
        switch (currentEvent.type) {
            case NCL_EVENT_INIT:
                if (self.provisionDetails) {
                    [myNcl findNymi];
                    [myNcl setEventTypeToWaitFor:NCL_EVENT_FIND];
                    [myNcl waitNclForEvent];
                    
                    // Set delegate to appdelegate
//                    [myNcl setNclDelegate:self];
                    [self displayViewControllerForNymiStatus:NymiStatusProvisioned];
                } else {
                    [self displayViewControllerForNymiStatus:NymiStatusNone];
                }
                break;
            
            case NCL_EVENT_FIND:
                NSLog(@"Found, about to validate nymi");
                [myNcl validateNymi:(currentEvent.find.nymiHandle)];
                [myNcl setEventTypeToWaitFor:NCL_EVENT_VALIDATION];
                [myNcl waitNclForEvent];
                [myNcl stopScan];
                break;
                
            case NCL_EVENT_VALIDATION:
                [myNcl disconnectNymi:(currentEvent.validation.nymiHandle)];
                NSLog(@"Validated and disconnected");
                if (nymiProvisioned)
                    [self displayViewControllerForNymiStatus:NymiStatusValidation];
            default:
                break;
        }
    }

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

- (void)displayViewControllerForNymiStatus:(NymiStatus)statusCode
{
    if (statusCode == NymiStatusProvisioned) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
        
        self.window.rootViewController = navVC;
        [self.window makeKeyAndVisible];
    } else if (statusCode == NymiStatusValidation) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
        
        self.window.rootViewController = navVC;
        [self.window makeKeyAndVisible];
    } else if (statusCode == NymiStatusNone) {
        // Refresh token failed to get new token - get her to log in again using modal. SignInVC
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignInViewController *signInVC = [storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
        [myNcl setNclDelegate:signInVC];
        self.window.rootViewController = signInVC;
        [self.window makeKeyAndVisible];
    }
}


@end
