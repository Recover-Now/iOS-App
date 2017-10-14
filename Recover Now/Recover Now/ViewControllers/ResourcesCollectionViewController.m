//
//  ResourcesCollectionViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourcesCollectionViewController.h"
#import "AccountTableViewController.h"
#import "Recover_Now-Swift.h"
#import "Constants.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "LoadData.h"
#import "ResourceDetailTableViewController.h"
#import "ResourceCollectionViewCell.h"

@interface ResourcesCollectionViewController ()

@end

@implementation ResourcesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [[LocationManager locationManager] requestWhenInUseAuthorization];
    }
    
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:true];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resources = [[LoadData retrieveResourcesForLocation:[Accounts userLocation]] mutableCopy];
        [self.collectionView reloadData];
        [self.activityIndicator stopAnimating];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ResourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [cell decorateForResource:[self.resources objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RNResource* resource = [self.resources objectAtIndex:indexPath.row];
    ResourceDetailTableViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailVC"];
    detailVC.resource = resource;
    [self presentViewController:detailVC animated:true completion:nil];
}

@end
