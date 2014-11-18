//
//  ConfirmTransactionViewController.m
//  Chainlock
//
//  Created by AK on 2014-11-18.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "ConfirmTransactionViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Credentials.h"

@interface ConfirmTransactionViewController ()

@end

@implementation ConfirmTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the
    self.navigationItem.title = @"Confirm Send";
    
    self.btcAmount.text = [NSString stringWithFormat:@"%@ BTC", self.bitcoinAmount];
    
    CGFloat usd = [self.bitcoinAmount floatValue] * 378.09;
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", usd];
    NSString *usdString = [NSString stringWithFormat:@"That's $%@ USD.", formattedNumber];
    self.usdAmount.text = usdString;
    
    self.addressLabel.text = self.address;
    
    self.btcConfirmAmount.text = [NSString stringWithFormat:@"%@ bitcoin?", self.bitcoinAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmTransactionId:(NSNumber *)transactionId withPin:(NSString *)secretPin
{
    NSString *urlEnding = [NSString stringWithFormat:@"api/confirm?transaction_id=%@&secret_pin=%@", transactionId, secretPin];
    // Begin API call
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:urlEnding parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Successfully confirmed transaction: %@", responseObject);
        [self.nymiButton setImage:[UIImage imageNamed:@"Success.png"] forState:UIControlStateNormal];
        dispatch_time_t delay = dispatch_time(0, (int64_t)(1.2 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [self.navigationController popToRootViewControllerAnimated:YES];
        });

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Couldn't confirm transaction.");
        NSLog(@"Error: %@", error.description);
        [self.navigationItem setRightBarButtonItem:nil animated:YES];

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

- (IBAction)nymiConfirmPressed:(id)sender {
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    activityView.color = [[UIColor alloc] initWithWhite:0 alpha:1.0];
    [activityView sizeToFit];
    [activityView startAnimating];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView animated:YES];

    [self confirmTransactionId:self.transactionId withPin:BtKey];
}
@end
