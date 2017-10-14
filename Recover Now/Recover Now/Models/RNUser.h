//
//  RNUser.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "FirebaseObject.h"
#import "RNResource.h"

@interface RNUser : FirebaseObject

@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* resourceListIdentifier;
@property (strong, nonatomic) NSString* locationIdentifier;
@property (nonatomic) bool inNeed;
@property (strong, nonatomic) NSData* imageData;

@end
