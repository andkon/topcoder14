//
//  StartTransactionViewController.h
//  Chainlock
//
//  Created by AK on 2014-11-18.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartTransactionViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSNumber *btcSent;
@property (strong, nonatomic) NSString *addressSent;
@property (weak, nonatomic) IBOutlet UILabel *error;

@property (weak, nonatomic) IBOutlet UITextField *bitcoinTextField;
@property (weak, nonatomic) IBOutlet UILabel *usdLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarButton;
- (IBAction)btcEditingChanged:(id)sender;

- (IBAction)sendBarButtonPressed:(id)sender;
@end
