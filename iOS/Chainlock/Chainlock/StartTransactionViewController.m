//
//  StartTransactionViewController.m
//  Chainlock
//
//  Created by AK on 2014-11-18.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "StartTransactionViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Credentials.h"
#import "ConfirmTransactionViewController.h"

@interface StartTransactionViewController ()

@end

@implementation StartTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Send Bitcoin";
    [self.error setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendTransactionAmount:(NSNumber *)btc toBitcoinAddress:(NSString *)address
{
    NSString *urlEnding = [NSString stringWithFormat:@"api/initiate?amount=%@&send_to=%@", btc, address];
    
    // Begin API call
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:urlEnding parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Successfully posted new transaction: %@", responseObject);
        // Now push the confirm screen
        ConfirmTransactionViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmVC"];
        vc.bitcoinAmount = btc;
        vc.transactionId = responseObject[@"transaction_id"];
        vc.address = address;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Couldn't post new transaction.");
        NSLog(@"Error: %@", error.description);
        
        [self.navigationItem setRightBarButtonItem:self.sendBarButton animated:YES];
        [self.error setHidden:NO];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btcEditingChanged:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *btc = [f numberFromString:self.bitcoinTextField.text];
    CGFloat usd = [btc floatValue] * 378;
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", usd];
    NSString *usdString = [NSString stringWithFormat:@"That's $%@ USD.", formattedNumber];
    self.usdLabel.text = usdString;
}

- (IBAction)sendBarButtonPressed:(id)sender
{
    // Get the number of bitcoin and the address
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    if (f) {
        NSNumber * btc = [f numberFromString:self.bitcoinTextField.text];
        
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        activityView.color = [[UIColor alloc] initWithWhite:0 alpha:1.0];
        [activityView sizeToFit];
        [activityView startAnimating];
        [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
//        self.sendBarButton = self.navigationItem.rightBarButtonItem;
        [self.navigationItem setRightBarButtonItem:loadingView animated:YES];

        
        [self sendTransactionAmount:btc toBitcoinAddress:self.addressTextField.text];
    } else {
        NSLog(@"btc number was nil");
    }

}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//}

@end
