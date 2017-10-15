//
//  SearchResultsTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "ResourceDetailTableViewController.h"
#import "ResourceTableViewCell.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

@synthesize results, presentingController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.results = [[NSMutableArray<RNResource*> alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RNResource* resource = self.results[indexPath.row];
    ResourceDetailTableViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailVC"];
    detailVC.resource = resource;
    detailVC.shouldShowCloseButton = false;
    [[self.presentingController navigationController] pushViewController:detailVC animated:true];
    //[self presentViewController:navVC animated:true completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [((ResourceTableViewCell *) cell) decorateForResource:self.results[indexPath.row]];
    
    return cell;
}

@end
