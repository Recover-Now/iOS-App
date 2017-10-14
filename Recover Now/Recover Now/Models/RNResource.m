//
//  RNResource.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "RNResource.h"

@implementation RNResource

@synthesize title, content, poster, category;

-(NSString *)categoryDescription {
    switch (self.category) {
        case RNResourceCategoryHousing:
            return @"Housing"
            break;
        case RNResourceCategoryRides:
            return @"Ride Sharing"
            break;
        case RNResourceCategoryClothing:
            return @"Clothing"
            break;
        case RNResourceCategoryMedicine:
            return @"Medicine"
            break;
        case RNResourceCategoryFoodWater:
            return @"Food & Water"
            break;
        default:
            break;
    }
}

@end
