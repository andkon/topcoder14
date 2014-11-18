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
@property (nonatomic, strong) NSNumber *bitcoinAmount;
@property (nonatomic, strong) NSString *address;

@property (weak, nonatomic) IBOutlet UILabel *btcAmount;
@property (weak, nonatomic) IBOutlet UILabel *usdAmount;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *btcConfirmAmount;
@property (weak, nonatomic) IBOutlet UIButton *nymiButton;

- (IBAction)nymiConfirmPressed:(id)sender;

@end
