//
//  LoadData.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "LoadData.h"
#import "Recover_Now-Swift.h"

@implementation LoadData

+ (NSArray<RNResource*> *)retrieveResourcesForLocation:(NSString*)location {
    NSLog(@"Retrieving resources for %@", location);
    NSMutableArray<RNResource*>* resources = [[NSMutableArray<RNResource*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
    //dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/resources", location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        NSLog(@"Callback 1 null=%i", data == nil);
        /*dispatch_group_t dataGroup = dispatch_group_create();
        for (NSString* key in data.allKeys) {
            NSLog(@"Found resource identifier");
            dispatch_group_async(dataGroup, dispatch_get_main_queue(), ^{
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
                [fbService2 retrieveDataForIdentifier:[NSString stringWithFormat:@"%@/%@", kFirebaseEntityRNResource, key] completion:^(FirebaseObject * _Nonnull obj) {
                    [resources addObject:(RNResource*)obj];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            });
        }
        dispatch_group_wait(dataGroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));*/
        //dispatch_semaphore_signal(semaphore);
        NSLog(@"Callback 1 ended");
    }];
    NSLog(@"Wait 1");
    //dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    /*fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/recoveryAreas", location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        NSLog(@"Callback 2 null=%i", data == nil);
        dispatch_group_t dataGroup = dispatch_group_create();
        for (NSString* key in data.allKeys) {
            NSLog(@"Found recoveryArea identifiers");
            dispatch_group_async(dataGroup, dispatch_get_main_queue(), ^{
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNRecoveryArea];
                [fbService2 retrieveDataForIdentifier:[NSString stringWithFormat:@"%@/%@", kFirebaseEntityRNRecoveryArea, key] completion:^(FirebaseObject * _Nonnull obj) {
                    [resources addObject:(RNResource*)obj];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            });
        }
        dispatch_group_wait(dataGroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
        dispatch_semaphore_signal(semaphore);
        NSLog(@"Callback 2 ended");
    }];
    NSLog(@"Wait 2");
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));*/
    NSLog(@"Resources obtained; returning");
    return resources;
}


@end
