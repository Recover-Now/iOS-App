//
//  ContributeViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ContributeViewController.h"

@interface ContributeViewController ()

@end

@implementation ContributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSegmentedControlChange:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl* segmentedControl = sender;
        if (segmentedControl.selectedSegmentIndex == 0) {
            [self performSegueWithIdentifier:@"showEmbeddedResources" sender:self];
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            [self performSegueWithIdentifier:@"showEmbeddedDonate" sender:self];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
