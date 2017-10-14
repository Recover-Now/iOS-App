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

static NSString * const reuseIdentifier = @"resourceCell";
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
    
    
    LocationManager.locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        requestingLocation = true;
        [[LocationManager locationManager] requestWhenInUseAuthorization];
    }
    
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.activityIndicator setColor:MAIN_COLOR];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator setHidesWhenStopped:true];
    
    NSString* currentLocation = [LocationManager currentUserLocation];
    if (currentLocation) {
        [self loadData:currentLocation];
    } else {
        NSLog(@"No location on load, showing no data state");
        [self.activityIndicator setHidden:true];
        [self showNoDataState];
    }
}

- (void)showNoDataState {
    
}

- (void)hideNoDataState {
    
}

- (void)loadData:(NSString*) location {
    [self.activityIndicator startAnimating];
    
    [LoadData retrieveResourcesForLocation:location withCompletion:^(NSArray<RNResource *> * res) {
        [self.resources addObjectsFromArray:res];
        [LoadData retrieveResourcesForLocation:location withCompletion:^(NSArray<RNResource *> * res) {
            [self.resources addObjectsFromArray:res];
            if (self.resources.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                    [self showNoDataState];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideNoDataState];
                    [self.collectionView reloadData];
                    [self.activityIndicator stopAnimating];
                });
            }
        }];
    }];
}

#pragma mark <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Location update!");
    CLLocation* loc = locations[0];
    [LocationManager addressForLocation:loc withCompletion:^(NSDictionary<NSString *,id> * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error during geocoding: %@", error);
            return;
        }
        NSString* identifier = [NSString stringWithFormat:@"%@-%@-%@", [data objectForKey:@"CountryCode"], [data objectForKey:@"State"], [data objectForKey:@"City"]];
        bool shouldReload = ![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsLocationKey] isEqualToString:identifier];
        [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kUserDefaultsLocationKey];
        if (shouldReload) {
            NSLog(@"Reloading data with new location of %@", identifier);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator setHidden:FALSE];
                [self.activityIndicator startAnimating];
                [self loadData:identifier];
            });
        }
    }];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.activityIndicator startAnimating];
        
        [LocationManager currentUserLocation];
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
    ResourceCollectionViewCell *cell = (ResourceCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [cell decorateForResource:[self.resources objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView* reusable = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    return reusable;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RNResource* resource = [self.resources objectAtIndex:indexPath.row];
    ResourceDetailTableViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailVC"];
    detailVC.resource = resource;
    [self presentViewController:detailVC animated:true completion:nil];
}

@end
