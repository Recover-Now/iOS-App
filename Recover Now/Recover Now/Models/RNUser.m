//
//  RNUser.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "RNUser.h"

@implementation RNUser

@synthesize firstName, lastName, resources;

static RNUser* currentUser;

+ (RNUser*)currentUser {
    return currentUser;
}

+ (void)setCurrentUser:(RNUser*)user {
    currentUser = user;
}

@end
