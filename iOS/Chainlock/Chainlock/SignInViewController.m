//
//  ViewController.m
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"

@interface SignInViewController ()

@property BOOL nymiProvsioned, nclInitEventFailure;
@property NclWrapper* myNcl;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonPressed:(id)sender;


@end

@implementation SignInViewController

@synthesize myNcl, nymiProvsioned;


/*
 Nymi words:
 NCL: nymi communication library, for talking between app + nymi
 NCA: nymi companion app, for authenticating the nymi originally
 NEA: nymi enabled app, like our app
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    myNcl =self.appDelegate.myNcl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nymi

// Method called when NCL events are received
- (void) incomingNclEvent:(NclEvent *)nclEvent{
    
    NSLog(@"delegate called");
    
    NclEvent currentEvent = *nclEvent;
    if (!nymiProvsioned) {
        switch (currentEvent.type)
        {
            case NCL_EVENT_INIT:
                // initialized, event, have to check it if it was successful before we move to discovery
                if (currentEvent.init.success) {
                    [self.button setTitle:@"NCL Initialized, discovering Nymi..." forState:UIControlStateNormal];
                    [myNcl discoverNymi];
                    [myNcl setEventTypeToWaitFor:NCL_EVENT_DISCOVERY];
                    [myNcl waitNclForEvent];
                }
                else {
                    [self.button setTitle:@"NCL initilize event returned error" forState:UIControlStateNormal];
                    self.nclInitEventFailure=YES;
                    self.button.enabled=NO;
                }
                
                break;
                
            case NCL_EVENT_DISCOVERY:
                // normally, would display LED pattern to expect to user and ask for validation
                // here for simplicity we assume agreement
                [self.button setTitle:@"Nymi discovered, agreeing..." forState:UIControlStateNormal];
                [myNcl agreeNymi:(currentEvent.discovery.nymiHandle)];
                [myNcl setEventTypeToWaitFor:NCL_EVENT_AGREEMENT];
                [myNcl waitNclForEvent];
                break;
                
            case NCL_EVENT_AGREEMENT:
                [self.button setTitle:@"Agreed, now provisioning..." forState:UIControlStateNormal];
                [myNcl provisionNymi:(currentEvent.agreement.nymiHandle)];
                [myNcl setEventTypeToWaitFor:NCL_EVENT_PROVISION];
                [myNcl waitNclForEvent];
                break;
                
            case NCL_EVENT_PROVISION:
                [myNcl disconnectNymi:(currentEvent.provision.nymiHandle)];
                nymiProvsioned=YES;
                [self.button setTitle:@"Provisioned. Now press to validate it" forState:UIControlStateNormal];
//                 Permastorage of privision deets:
                [self permastoreProvisionDetails:currentEvent.provision.provision];
                // it is used to find the same nymi on subsequent calls
                //if (nymiProvsioned)
                if (nymiProvsioned)
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                                       [self.button setEnabled:YES];
                                   });
                
                break;
                
            default:
                break;
        }//end switch on event type
    }
    
    else {    // if already provisioned, we just have to find the nymi and validate
        
    }
}


- (IBAction)buttonPressed:(id)sender
{
    if (!nymiProvsioned) {
        
        myNcl = [[NclWrapper alloc] init];
        
        [myNcl setEventTypeToWaitFor:NCL_EVENT_INIT];
        [myNcl waitNclForEvent];
        
        // set the delegate to get things started and intialize NCL
        [myNcl setNclDelegate: (self)];
        
        [self.button setTitle:@"NCL Initialized, waiting for init event\n" forState:UIControlStateNormal];
    }
    else {
        NSString *string = @"Nymi already provisioned, in validate step -  Finding provisioned Nymi...";
        [self.button setTitle:string forState:UIControlStateNormal];
        [myNcl findNymi];
        [myNcl setEventTypeToWaitFor:NCL_EVENT_FIND];
        [myNcl waitNclForEvent];
        [self.appDelegate displayViewControllerForNymiStatus:NymiStatusProvisioned];
        self.appDelegate.myNcl = myNcl;
        [myNcl setNclDelegate:self.appDelegate];
    }
    
    
    
    self.button.enabled=NO;
    
}

- (void)permastoreProvisionDetails:(NclProvision)provision
{
    NSString *key = [NSString stringWithFormat:@"%@", provisionButtToString(provision.key)];
    NSLog(@"%@", key);
    NSString *id = [NSString stringWithFormat:@"%@", provisionButtToString(provision.id)];
    NSLog(@"%@", id);
    NSDictionary *provisions = @{
                                 @"id": id,
                                 @"key": key
                                 };
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:provisions forKey:@"provisionDetails"];
    [archiver finishEncoding];
    
    NSError *error = nil;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *filePath = [delegate permaStorageFilePath];
    BOOL success = [data writeToFile:filePath options:NSDataWritingAtomic error: &error];
    if (!success) {
        NSLog(@"writeToFile failed with error %@", error);
    } else {
        NSLog(@"Successfully wrote provisionDetails");
    }

}

NSString* provisionButtToString(NclProvisionId provisionId){
    NSMutableString* result=[[NSMutableString alloc] init];
    for(unsigned i=0; i<NCL_PROVISION_ID_SIZE; ++i)
        [result appendFormat: @"%x ", provisionId[i]];
    return result;
}
@end
