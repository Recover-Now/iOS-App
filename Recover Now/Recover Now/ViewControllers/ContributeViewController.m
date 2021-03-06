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
#import "CreateResourceTableViewController.h"
#import "LocationManager.h"
#import "Recover_Now-Swift.h"

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
    self.navigationItem.title = @"Contributions";
    
    self.navigationItem.titleView = self.segmentControl;
    self.segmentControl.frame = self.navigationItem.titleView.frame;
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButtonTap)];
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResourceCreated) name:kNotificationNameDidCreateResource object:nil];
}

- (void)onResourceCreated {
    dispatch_async(dispatch_get_main_queue(), ^{
        myResourcesVC.resources = [[NSMutableArray<RNResource*> alloc] init];
        [myResourcesVC.tableView reloadData];
        [myResourcesVC loadData];
    });
}

- (void)onAddButtonTap {
    if (![LocationManager currentUserLocation]) {
        [self showSimpleAlert:@"Error" message:@"You must have location services enabled to contribute resources" handler:nil];
        return;
    }
    UINavigationController* createVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"createResourceVCNav"];
    createVCNav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:createVCNav animated:true completion:nil];
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
                self.navigationItem.rightBarButtonItem = self.addButton;
                self.navigationItem.title = @"Contributions";
            }];
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            [myResourcesVC willMoveToParentViewController:nil];
            [self addChildViewController:donateVC];
            [donateVC didMoveToParentViewController:self];
            [self transitionFromViewController:myResourcesVC toViewController:donateVC duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                [myResourcesVC removeFromParentViewController];
                [donateVC didMoveToParentViewController:self];
                self.navigationItem.rightBarButtonItem = nil;
                self.navigationItem.title = @"Donate";
            }];
            
        }
    }
}

@end
