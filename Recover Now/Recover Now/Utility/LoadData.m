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
    NSMutableArray<RNResource*>* resources = [[NSMutableArray<RNResource*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/%@/resources", kFirebaseEntityRNLocation, location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t dataGroup = dispatch_group_create();
        for (NSString* key in data.allKeys) {
            dispatch_group_async(dataGroup, queue, ^{
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                [fbService retrieveDataForIdentifier:[NSString stringWithFormat:@"%@/%@", kFirebaseEntityRNResource, key] completion:^(FirebaseObject * _Nonnull obj) {
                    [resources addObject:(RNResource*)obj];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            });
        }
        dispatch_group_wait(dataGroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    }];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/%@/recoveryAreas", kFirebaseEntityRNLocation, location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t dataGroup = dispatch_group_create();
        for (NSString* key in data.allKeys) {
            dispatch_group_async(dataGroup, queue, ^{
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                [fbService retrieveDataForIdentifier:[NSString stringWithFormat:@"%@/%@", kFirebaseEntityRNRecoveryArea, key] completion:^(FirebaseObject * _Nonnull obj) {
                    [resources addObject:(RNResource*)obj];
                    dispatch_semaphore_signal(sema);
                }];
                dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            });
        }
        dispatch_group_wait(dataGroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    }];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    return resources;
}


@end
