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
    // Do any additional setup after loading the view.
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Couldn't confirm transaction.");
        NSLog(@"Error: %@", error.description);
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

- (IBAction)confirmButtonPressed:(id)sender {
    [self confirmTransactionId:[NSNumber numberWithInt:8] withPin:@"4QwS5xSnzgyV"];
}
@end
