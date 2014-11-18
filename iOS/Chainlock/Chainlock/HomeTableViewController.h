//
//  HomeTableViewController.h
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomeTableViewController : UITableViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NclWrapper *wrapper;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (nonatomic) NSInteger gradCount;


@end
