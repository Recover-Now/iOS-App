//
//  RNLocation.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseObject.h"
#import "RNResource.h"

@interface RNLocation : FirebaseObject

@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* country;

@property (nonatomic, strong) NSArray<NSString*>* resources;
@property (nonatomic, strong) NSArray<NSString*>* recoveryAreas;

@end
