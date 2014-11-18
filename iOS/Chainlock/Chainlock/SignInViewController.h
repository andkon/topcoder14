//
//  ViewController.h
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NclWrapper.h"

@interface SignInViewController : UIViewController <NclEventProtocol>

@property (strong, nonatomic) AppDelegate *appDelegate;


@end

