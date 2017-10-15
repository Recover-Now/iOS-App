//
//  LoadData.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "LoadData.h"
#import "Recover_Now-Swift.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@implementation LoadData

+ (void)retrieveResourcesForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNResource*> *))completion {
    NSMutableArray<RNResource*>* resources = [[NSMutableArray<RNResource*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/resources", location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        if (data.allKeys.count == 0) {
            completion(resources);
            return;
        }
        for (NSString* key in data.allKeys) {
            FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
            [fbService2 retrieveDataForIdentifier:key completion:^(FirebaseObject * _Nonnull obj) {
                [resources addObject:(RNResource*)obj];
                if (resources.count == data.allKeys.count) {
                    completion(resources);
                }
            }];
        }
    }];
}

+ (void)retrieveRecoveryAreasForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNRecoveryArea*> *))completion {
    NSMutableArray<RNRecoveryArea*>* resources = [[NSMutableArray<RNRecoveryArea*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/recoveryAreas", location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        if (data.allKeys.count == 0) {
            completion(resources);
            return;
        }
        for (NSString* key in data.allKeys) {
            FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNRecoveryArea];
            [fbService2 retrieveDataForIdentifier:key completion:^(FirebaseObject * _Nonnull obj) {
                [resources addObject:(RNRecoveryArea*)obj];
                if (resources.count == data.allKeys.count) {
                    completion(resources);
                }
            }];
        }
    }];
}

+ (void)retrieveResourcesForUser:(NSString*)userID withCompletion:(void (^)(NSArray<RNResource*> *))completion {
    NSMutableArray<RNResource*>* resources = [[NSMutableArray<RNResource*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNUserResourceList];
    [fbService retrieveListForIdentifier:userID completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        if (data.allKeys.count == 0) {
            completion(resources);
            return;
        }
        for (NSString* key in data.allKeys) {
            NSLog(@"Resource Key: %@", key);
            FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
            [fbService2 retrieveDataForIdentifier:key completion:^(FirebaseObject * _Nonnull obj) {
                [resources addObject:(RNResource*)obj];
                if (resources.count == data.allKeys.count) {
                    completion(resources);
                }
            }];
        }
    }];
}

+ (void)retrieveRecoveryAreasForUser:(NSString*)userID withCompletion:(void (^)(NSArray<RNRecoveryArea*> *))completion {
    NSMutableArray<RNRecoveryArea*>* resources = [[NSMutableArray<RNRecoveryArea*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNUserRecoveryAreaList];
    [fbService retrieveListForIdentifier:userID completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        if (data.allKeys.count == 0) {
            completion(resources);
            return;
        }
        for (NSString* key in data.allKeys) {
            FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNRecoveryArea];
            [fbService2 retrieveDataForIdentifier:key completion:^(FirebaseObject * _Nonnull obj) {
                [resources addObject:(RNRecoveryArea*)obj];
                if (resources.count == data.allKeys.count) {
                    completion(resources);
                }
            }];
        }
    }];
}


@end
