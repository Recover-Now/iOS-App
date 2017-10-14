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
    
    // Do any additional setup after loading the view.
    self.resources = [[NSMutableArray<RNResource*> alloc] init];
    [self.activityIndicator startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


#pragma mark - Database Connection

- (void)loadData:(CallbackBlock)cbk {
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/%@/resources", kFirebaseEntityRNLocation, [Accounts userLocation]] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t dataGroup = dispatch_group_create();
        for (NSString* key in data.allKeys) {
            dispatch_group_async(dataGroup, queue, ^{
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                [fbService retrieveDataForIdentifier:[NSString stringWithFormat:@"%@/%@", kFirebaseEntityRNResource, key] completion:^(FirebaseObject * _Nonnull obj) {
                    [self.resources addObject:(RNResource*)obj];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            });
        }
        dispatch_group_wait(dataGroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    }];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/%@/recoveryAreas", kFirebaseEntityRNLocation, [Accounts userLocation]] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t dataGroup = dispatch_group_create();
        for (NSString* key in data.allKeys) {
            dispatch_group_async(dataGroup, queue, ^{
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                [fbService retrieveDataForIdentifier:[NSString stringWithFormat:@"%@/%@", kFirebaseEntityRNRecoveryArea, key] completion:^(FirebaseObject * _Nonnull obj) {
                    [self.resources addObject:(RNResource*)obj];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            });
        }
        dispatch_group_wait(dataGroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    }];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
