//
//  StartTransactionViewController.h
//  Chainlock
//
//  Created by AK on 2014-11-18.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartTransactionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startTransactionButton;
- (IBAction)startTransactionPressed:(id)sender;
@end