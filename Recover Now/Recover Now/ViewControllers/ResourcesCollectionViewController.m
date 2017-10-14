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

#import "Recover_Now-Swift.h"   ///<------------------------------------------------------

@interface ResourcesCollectionViewController ()

@end

@implementation ResourcesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
bool requestingLocation = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FirebaseStorage.shared retrieveProfilePictureForCurrentUser: ^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Could not retrieve profile picture %@", error);
        } else {
            Accounts.userImageData = data;
            self.profileImageView.image = [[UIImage alloc] initWithData:data];
        }
    }];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Requesting");
        requestingLocation = true;
        [[LocationManager locationManager] requestWhenInUseAuthorization];
    }
    
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    [self.activityIndicator setHidesWhenStopped:true];
    
    
    
    if ([LocationManager currentUserLocation] || true) {
        [self.activityIndicator startAnimating];
        
        [LoadData retrieveResourcesForLocation:@"USA-GA-Atlanta" withCompletion:^(NSArray<RNResource *> * res) {
            [self.resources addObjectsFromArray:res];
            [LoadData retrieveResourcesForLocation:@"USA-GA-Atlanta" withCompletion:^(NSArray<RNResource *> * res) {
                [self.resources addObjectsFromArray:res];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Reloading collectionView");
                    [self.collectionView reloadData];
                    [self.activityIndicator stopAnimating];
                });
            }];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LocationManager.locationManager.delegate = self;
    CLLocation* userLocation = [LocationManager currentUserLocation];
    if (!userLocation && !requestingLocation) {
        [self showSimpleAlert:@"Current Location Unknown" message:@"Please visit Settings to allow access to your location." handler:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.activityIndicator startAnimating];
        
        CLLocation* userLocation = [LocationManager currentUserLocation];
        if (!userLocation) { return; }
        [LoadData retrieveResourcesForLocation:@"USA-GA-Atlanta" withCompletion:^(NSArray<RNResource *> * res) {
            [self.resources addObjectsFromArray:res];
            [LoadData retrieveResourcesForLocation:@"USA-GA-Atlanta" withCompletion:^(NSArray<RNResource *> * res) {
                [self.resources addObjectsFromArray:res];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Reloading collectionView");
                    [self.collectionView reloadData];
                    [self.activityIndicator stopAnimating];
                });
            }];
        }];
    }
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
