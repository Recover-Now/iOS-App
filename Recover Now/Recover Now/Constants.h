//
//  Constants.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kUserDefaultsUserKey                @"RNUserDefaultsUserKey"

#define kFirebaseEntityRNUser               @"RNUser"
#define kFirebaseEntityRNUserResourceList   @"RNUserResourceList"
#define kFirebaseEntityRNLocation           @"RNLocation"
#define kFirebaseEntityRNRecoveryArea       @"RNRecoveryArea"
#define kFirebaseEntityRNResource           @"RNResource"

#define IS_LOGGED_IN ([[NSUserDefaults standardUserDefaults] objectForKey:@"TPUDkUserIdenfitier"] != nil)

#define MAIN_COLOR RGB(1.0, 0.177, 0.334)
#define RGB(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


typedef void (^ CallbackBlock)(void);

#endif /* Constants_h */
