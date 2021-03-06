//
//  ViewController.m
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "SignInViewController.h"

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
                    [self.button setImage:[UIImage imageNamed:@"Provisioning.png"] forState:UIControlStateNormal];
                    [myNcl discoverNymi];
                    [myNcl setEventTypeToWaitFor:NCL_EVENT_DISCOVERY];
                    [myNcl waitNclForEvent];
                }
                else {
                    [self.button setTitle:@"error" forState:UIControlStateNormal];
                    self.nclInitEventFailure=YES;
                    self.button.enabled=NO;
                }
                
                break;
                
            case NCL_EVENT_DISCOVERY:
                // normally, would display LED pattern to expect to user and ask for validation
                // here for simplicity we assume agreement
                [myNcl agreeNymi:(currentEvent.discovery.nymiHandle)];
                [myNcl setEventTypeToWaitFor:NCL_EVENT_AGREEMENT];
                [myNcl waitNclForEvent];
                break;
                
            case NCL_EVENT_AGREEMENT:
                [myNcl provisionNymi:(currentEvent.agreement.nymiHandle)];
                [myNcl setEventTypeToWaitFor:NCL_EVENT_PROVISION];
                [myNcl waitNclForEvent];
                break;
                
            case NCL_EVENT_PROVISION:
                [myNcl disconnectNymi:(currentEvent.provision.nymiHandle)];
                nymiProvsioned=YES;
                [self.button setImage:[UIImage imageNamed:@"Connect nymi.png"] forState:UIControlStateNormal];

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
        switch (currentEvent.type) {
            case NCL_EVENT_FIND:
                [myNcl validateNymi:(currentEvent.find.nymiHandle)];
                [myNcl setEventTypeToWaitFor:NCL_EVENT_VALIDATION];
                [myNcl waitNclForEvent];
                [myNcl stopScan];
                break;
                
            case NCL_EVENT_VALIDATION:
                [myNcl disconnectNymi:(currentEvent.validation.nymiHandle)];
                if (nymiProvsioned)
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                                       // show sick ass new view controller
                                       [self.button setEnabled:(NO)];
                                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                       UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"NavVC"];
                                       AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                       appDelegate.window.rootViewController = navVC;
                                       [appDelegate.window makeKeyAndVisible];

                                   });
                
                
            default:
                break;
        }
        
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
        NSString *string = @"in validate step -  Finding provisioned Nymi...";
        [self.button setTitle:string forState:UIControlStateNormal];
        [myNcl findNymi];
        [myNcl setEventTypeToWaitFor:NCL_EVENT_FIND];
        [myNcl waitNclForEvent];
    }
    
    
    
    self.button.enabled=NO;
    
}

@end
