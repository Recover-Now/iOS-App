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

+ (void)retrieveResourcesForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNResource*> *))completion {
    NSLog(@"Retrieving resources for %@", location);
    NSMutableArray<RNResource*>* resources = [[NSMutableArray<RNResource*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/resources", location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        NSLog(@"Callback 1 null=%i", data == nil);
        for (NSString* key in data.allKeys) {
            NSLog(@"Found resource identifier");
            FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
            [fbService2 retrieveDataForIdentifier:key completion:^(FirebaseObject * _Nonnull obj) {
                NSLog(@"Got data");
                [resources addObject:(RNResource*)obj];
                if (resources.count == data.allKeys.count) {
                    completion(resources);
                }
            }];
        }
    }];
}

+ (void)retrieveRecoveryAreaForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNRecoveryArea*> *))completion {
    NSLog(@"Retrieving resources for %@", location);
    NSMutableArray<RNRecoveryArea*>* resources = [[NSMutableArray<RNRecoveryArea*> alloc] init];
    FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
    [fbService retrieveListForIdentifier:[NSString stringWithFormat:@"%@/resources", location] completion:^(NSDictionary<NSString *,id> * _Nonnull data) {
        NSLog(@"Callback 1 null=%i", data == nil);
        for (NSString* key in data.allKeys) {
            NSLog(@"Found resource identifier");
            FirebaseService* fbService2 = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
            [fbService2 retrieveDataForIdentifier:key completion:^(FirebaseObject * _Nonnull obj) {
                NSLog(@"Got data");
                [resources addObject:(RNRecoveryArea*)obj];
                if (resources.count == data.allKeys.count) {
                    completion(resources);
                }
            }];
        }
    }];
}


@end
