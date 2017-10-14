//
//  ResourcesCollectionViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourcesCollectionViewController.h"
#import "AccountTableViewController.h"
#import "Constants.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "LoadData.h"
#import "ResourceDetailTableViewController.h"
#import "ResourceCollectionViewCell.h"
#import "CollectionReusableView.h"
#import "UIView+Shadow.h"

#import "Recover_Now-Swift.h"   ///<------------------------------------------------------

@interface ResourcesCollectionViewController ()

@property (nonatomic, strong) UIView* topBar;

-(CGFloat) spacingForCells;
-(void) orientationDidChange;

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
            [self.collectionViewLayout invalidateLayout];
        }
    }];
    
    CGFloat inset = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 24.0 : 16.0;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
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
    
    //Handle orientation change
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UICollectionViewFlowLayoutSectionInsetFromSafeArea;
        self.collectionView.insetsLayoutMarginsFromSafeArea = true;
        ((UICollectionViewFlowLayout *) self.collectionViewLayout).sectionInsetReference = UICollectionViewFlowLayoutSectionInsetFromSafeArea;
    }
    
    //Status bar management
    self.topBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    self.topBar.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.topBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CollectionReusableView* header = (CollectionReusableView*)[self.collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (Accounts.userInNeed) {
        header.profileImageView.layer.borderColor = MAIN_COLOR.CGColor;
        header.profileImageView.layer.borderWidth = 1.0f;
    } else {
        header.profileImageView.layer.borderWidth = 0.0f;
    }
}
     
 -(void) orientationDidChange {
     [self.collectionViewLayout invalidateLayout];
     [self.topBar removeFromSuperview];
     self.topBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
     self.topBar.backgroundColor = UIColor.whiteColor;
     [self.view addSubview:self.topBar];
 }

- (void)showNoDataState {
    
}

- (void)hideNoDataState {
    
}

- (void)loadData:(NSString*) location {
    [self.activityIndicator startAnimating];
    
    [LoadData retrieveResourcesForLocation:location withCompletion:^(NSArray<RNResource *> * res) {
        [self.resources addObjectsFromArray:res];
        [LoadData retrieveRecoveryAreasForLocation:location withCompletion:^(NSArray<RNRecoveryArea *> * res2) {
            [self.resources addObjectsFromArray:res2];
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
    cell.layer.masksToBounds = false;
    UIView* roundedView = [[cell subviews] firstObject];
    [roundedView shadow];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionReusableView* reusable = (CollectionReusableView*) [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    reusable.profileImageView.image = Accounts.userImage;
    if (Accounts.userInNeed) {
        reusable.profileImageView.layer.borderColor = MAIN_COLOR.CGColor;
        reusable.profileImageView.layer.borderWidth = 1.0f;
    } else {
        reusable.profileImageView.layer.borderWidth = 0.0f;
    }
    return reusable;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RNResource* resource = [self.resources objectAtIndex:indexPath.row];
    ResourceDetailTableViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailVC"];
    detailVC.resource = resource;
    [self presentViewController:detailVC animated:true completion:nil];
}




#pragma mark UICollectionViewFlowLayout methods

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self spacingForCells];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat spacing = [self spacingForCells];
    CGFloat height = self.collectionView.frame.size.height;
    CGFloat width = self.collectionView.frame.size.width;
    
    UIEdgeInsets insets = self.collectionView.contentInset;
//    if (@available(iOS 11.0, *)) {
//        NSLog(@"Safe Area");
//        insets = self.collectionView.safeAreaInsets;
//    }

    int numberOfCellsInRow = (int) width / 150;
    CGFloat availableWidth = width - ((numberOfCellsInRow - 1) * spacing) - 15.0 - insets.left - insets.right;
    CGFloat singleCellWidth = availableWidth / ((CGFloat) numberOfCellsInRow);
    CGFloat singleCellHeight = singleCellWidth * 1.3;
    return CGSizeMake(singleCellWidth, singleCellHeight);
}

-(CGFloat) spacingForCells {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 32.0 : 20.0;
}


@end
