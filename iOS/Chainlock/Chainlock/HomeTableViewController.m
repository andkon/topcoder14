//
//  HomeTableViewController.m
//  Chainlock
//
//  Created by AK on 2014-11-17.
//  Copyright (c) 2014 Chainlock. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.wrapper =self.appDelegate.myNcl;
    [self uiForState:self.appDelegate.nymiStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiForState:(NymiStatus)state
{
    if (state == NymiStatusProvisioned) {
        NSMutableArray *colors = [@[] mutableCopy];
        UIColor *red = [UIColor greenColor];
        UIColor *purple = [UIColor whiteColor];
        struct CGColor *cgColRed = [red CGColor];
        struct CGColor *cgColPurple = [purple CGColor];
        [colors addObject:(__bridge id)(cgColRed)];
        [colors addObject:(__bridge id)(cgColPurple)];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.frame;
        gradient.colors = colors;
        [gradient setStartPoint:CGPointMake(0.0, 0.5)];
        [gradient setEndPoint:CGPointMake(1.0, 0.5)];
        
        [self loadingBG];
    } else if (state == NymiStatusValidation) {
        
    }
}

- (void)loadingBG;
{
    UIColor *green = [UIColor greenColor];
    UIColor *white = [UIColor whiteColor];
    NSMutableArray *colors = [@[] mutableCopy];
    struct CGColor *cg1 = [green CGColor];
    struct CGColor *cg2 = [white CGColor];
    [colors addObject:(__bridge id)(cg1)];
    [colors addObject:(__bridge id)(cg2)];
    [UIView animateWithDuration:0.1f animations:^{
        self.gradient.colors = colors;
    } completion:^(BOOL finished) {
        if (finished == YES) {
            if (self.appDelegate.nymiStatus == NymiStatusProvisioned) {
                // move where the first index is
                dispatch_time_t delay = dispatch_time(0, (int64_t)(0.8 * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:@[colors[0], colors[1]]];
                    [UIView animateWithDuration:0.1f animations:^{
                        self.gradient.colors = colors;
                    } completion:^(BOOL finished) {
                        [self loadingBG];
                    }];
                });
            } else {
                // uhhh get rid of gradient
                [self.gradient removeFromSuperlayer];
            }
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
