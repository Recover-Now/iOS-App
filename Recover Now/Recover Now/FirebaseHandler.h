//
//  FirebaseHandler.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNUser.h"
#import "RNLocation.h"
#import "RNResource.h"
#import "RNRecoveryArea.h"

@interface FirebaseHandler : NSObject

+ (RNUser*)retrieveUserWithIdentifier:(NSString*)identifier;
+ (RNLocation*)retrieveLocationWithIdentifier:(NSString*)identifier;
+ (RNResource*)retrieveResourceWithIdentifier:(NSString*)identifier;
+ (RNRecoveryArea*)retrieveRecoveryAreaWithIdentifier:(NSString*)identifier;

@end
