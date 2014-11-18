//
//  ConfirmTransactionViewController.h
//  Chainlock
//
//  Created by AK on 2014-11-18.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmTransactionViewController : UIViewController

@property (nonatomic, strong) NSNumber *transactionId;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)confirmButtonPressed:(id)sender;

@end
