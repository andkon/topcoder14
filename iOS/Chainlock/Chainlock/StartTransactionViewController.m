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

@interface StartTransactionViewController ()

@end

@implementation StartTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        self.startTransactionButton.backgroundColor = [UIColor greenColor];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Couldn't post new transaction.");
        NSLog(@"Error: %@", error.description);
        self.startTransactionButton.backgroundColor = [UIColor redColor];
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

- (IBAction)startTransactionPressed:(id)sender {
    [self sendTransactionAmount:[NSNumber numberWithFloat:0.0001] toBitcoinAddress:@"2MuDfMJAp7m3aatV1bDnrPZMzpRb3t3QMfB"];
}
@end
