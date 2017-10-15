//
//  ContributeViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ContributeViewController.h"
#import "MyResourcesTableViewController.h"
#import "DonateCollectionViewController.h"

@interface ContributeViewController ()

@end

@implementation ContributeViewController

MyResourcesTableViewController* myResourcesVC;
DonateCollectionViewController* donateVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    myResourcesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myResourcesVC"];
    donateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"donateVC"];
    
    [self addChildViewController:myResourcesVC];
    [self.embedView addSubview:myResourcesVC.view];
    [myResourcesVC didMoveToParentViewController:self];
    
    self.navigationItem.titleView = self.segmentControl;
    self.segmentControl.frame = self.navigationItem.titleView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSegmentedControlChange:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl* segmentedControl = sender;
        if (segmentedControl.selectedSegmentIndex == 0) {
            [donateVC willMoveToParentViewController:nil];
            [self addChildViewController:myResourcesVC];
            [self transitionFromViewController:donateVC toViewController:myResourcesVC duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                [donateVC removeFromParentViewController];
                [myResourcesVC didMoveToParentViewController:self];
            }];
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            [myResourcesVC willMoveToParentViewController:nil];
            [self addChildViewController:donateVC];
            [donateVC didMoveToParentViewController:self];
            [self transitionFromViewController:myResourcesVC toViewController:donateVC duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                [myResourcesVC removeFromParentViewController];
                [donateVC didMoveToParentViewController:self];
            }];
            
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEmbeddedResources"]) {
        
    } else if ([segue.identifier isEqualToString:@"showEmbeddedDonate"]) {
        
    }
}

@end
