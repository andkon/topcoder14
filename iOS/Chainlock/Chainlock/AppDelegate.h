//
//  AppDelegate.h
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NclWrapper.h"

typedef enum _NymiStatus : NSUInteger {
    NymiStatusNone = 0,
    NymiStatusProvisioned = 1,
    NymiStatusValidation = 2,
} NymiStatus;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(NSString *)permaStorageFilePath;
- (void)displayViewControllerForNymiStatus:(NymiStatus)statusCode;
@end

