//
//  RNResource.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseObject.h"

@class RNUser;

typedef NS_ENUM(NSInteger, RNResourceCategory) {
    RNResourceCategoryHousing,
    RNResourceCategoryFoodWater,
    RNResourceCategoryMedicine,
    RNResourceCategoryClothing,
    RNResourceCategoryRides
};

@interface RNResource : FirebaseObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* poster;
@property (nonatomic) NSInteger category;

-(NSString *)categoryDescription;

@end
