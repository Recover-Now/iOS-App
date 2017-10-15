//
//  MyResourcesTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "MyResourcesTableViewController.h"
#import "ResourceDetailTableViewController.h"
#import "ResourceTableViewCell.h"
#import "Recover_Now-Swift.h"
#import "LoadData.h"

@interface MyResourcesTableViewController ()

@end

@implementation MyResourcesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.activityIndicator setColor:MAIN_COLOR];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator setHidesWhenStopped:true];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self.activityIndicator startAnimating];
    
    [LoadData retrieveResourcesForUser:Accounts.userIdentifier withCompletion:^(NSArray<RNResource *> * res) {
        [self.resources addObjectsFromArray:res];
        [LoadData retrieveRecoveryAreasForUser:Accounts.userIdentifier withCompletion:^(NSArray<RNRecoveryArea *> * res2) {
            [self.resources addObjectsFromArray:res2];
            if (self.resources.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.activityIndicator stopAnimating];
                });
            }
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RNResource* resource = self.resources[indexPath.row];
    ResourceDetailTableViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailVC"];
    detailVC.resource = resource;
    detailVC.shouldShowCloseButton = false;
    [[self.parentViewController navigationController] pushViewController:detailVC animated:true];
    //[self presentViewController:navVC animated:true completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [((ResourceTableViewCell *) cell) decorateForResource:self.resources[indexPath.row]];
    
    return cell;
}

@end
