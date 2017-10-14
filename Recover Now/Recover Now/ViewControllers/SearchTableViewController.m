//
//  SearchTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "SearchTableViewController.h"
#import "LoadData.h"
#import "LocationManager.h"
#import "Recover_Now-Swift.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    self.results = [[NSMutableArray<RNResource*> alloc] init];
    [self.activityIndicator setHidesWhenStopped:true];
    [self.activityIndicator startAnimating];
    
    CLLocation* userLocation = [LocationManager currentUserLocation];
    if (!userLocation) {
        [self showSimpleAlert:@"Current Location Unknown" message:@"Please visit Settings to allow access to your location." handler:nil];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.resources = [[LoadData retrieveResourcesForLocation:[LocationManager currentUserLocation]] mutableCopy];
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.results removeAllObjects];
    for (RNResource* res in self.resources) {
        if ([res.title containsString:searchText] || [res.content containsString:searchText]) {
            [self.results addObject:res];
        }
    }
    [self.tableView reloadData];
}

@end
