//
//  HomeTableViewController.h
//  Chainlock
//
//  Created by AK on 2014-11-18.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;

- (IBAction)refreshControlAction:(id)sender;


@end
