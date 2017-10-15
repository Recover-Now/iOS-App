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
#import "SearchResultsTableViewController.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SearchResultsTableViewController* searchResultsDisplay = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultsController"];
    searchResultsDisplay.presentingController = self;   //Used for transitions later
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsDisplay];
    self.definesPresentationContext = true;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Resources & recovery areas";
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.tintColor = MAIN_COLOR;
    
    //UISearchBar* searchBar = (UISearchBar*) self.tableView.tableHeaderView;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = false;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.activityIndicator setColor:MAIN_COLOR];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator setHidesWhenStopped:true];
    
    NSString* userLocation = [LocationManager currentUserLocation];
    if (!userLocation) {
        NSLog(@"WARNING -- No location to use for search results");
        return;
    }
    
    [self loadData:userLocation];
    
}

- (void)loadData:(NSString*) location {
    [self.activityIndicator startAnimating];
    
    [LoadData retrieveResourcesForLocation:location withCompletion:^(NSArray<RNResource *> * res) {
        [self.resources addObjectsFromArray:res];
        [LoadData retrieveRecoveryAreasForLocation:location withCompletion:^(NSArray<RNRecoveryArea *> * res2) {
            [self.resources addObjectsFromArray:res2];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
            });
        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    SearchResultsTableViewController* resultsVC = (SearchResultsTableViewController*)searchController.searchResultsController;
    [resultsVC.results removeAllObjects];
    for (RNResource* res in self.resources) {
        if ([[res.title lowercaseString] containsString:[searchController.searchBar.text lowercaseString]]
            || [[res.content lowercaseString] containsString: [searchController.searchBar.text lowercaseString]]) {
            [resultsVC.results addObject:res];
        }
    }
    [resultsVC.tableView reloadData];
}

@end
