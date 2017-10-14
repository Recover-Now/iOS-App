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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Resources & recovery areas";
    self.searchController.searchResultsUpdater = self;
    
    //UISearchBar* searchBar = (UISearchBar*) self.tableView.tableHeaderView;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = false;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.results removeAllObjects];
    for (RNResource* res in self.resources) {
        if ([[res.title lowercaseString] containsString:[searchText lowercaseString]]
            || [[res.content lowercaseString] containsString: [searchText lowercaseString]]) {
            [self.results addObject:res];
        }
    }
    [self.tableView reloadData];
}

@end
