//
//  LoadData.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNResource.h"

@interface LoadData : NSObject

+ (void)retrieveResourcesForLocation:(NSString*)location withCompletion:(void (^)(NSArray<RNResource*> *))completion;

@end
