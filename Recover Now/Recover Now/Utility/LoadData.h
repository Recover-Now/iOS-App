//
//  LoadData.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNResource.h"
#import "RNRecoveryArea.h"

@interface LoadData : NSObject

+ (void)retrieveResourcesForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNResource*> *))completion;
+ (void)retrieveRecoveryAreasForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNRecoveryArea*> *))completion;
+ (void)retrieveResourcesForUser:(NSString*)userID withCompletion:(void (^)(NSArray<RNResource*> *))completion;
+ (void)retrieveRecoveryAreasForUser:(NSString*)userID withCompletion:(void (^)(NSArray<RNRecoveryArea*> *))completion;

@end
