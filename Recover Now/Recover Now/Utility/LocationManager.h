//
//  LocationManager.h
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (NSString * _Nullable) currentUserLocation;
+ (CLLocation *) currentCoordinateLocation;
+ (CLLocationManager * _Nonnull) locationManager;
+ (void) addressForLocation: (CLLocation* _Nonnull) location withCompletion: (void (^_Nonnull) (NSDictionary<NSString*, id>* _Nullable, NSError*_Nullable)) completion;


@end
