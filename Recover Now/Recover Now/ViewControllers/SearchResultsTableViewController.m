//
//  SearchResultsTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "ResourceDetailTableViewController.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

@synthesize results;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RNResource* resource = self.results[indexPath.row];
    ResourceDetailTableViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailVC"];
    detailVC.resource = resource;
    [self presentViewController:detailVC animated:true completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.results[indexPath.row].title;
    
    return cell;
}

@end
