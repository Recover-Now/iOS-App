//
//  LocationManager.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@implementation LocationManager

static CLLocationManager* locationManager;

+ (CLLocationManager *)locationManager {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    return locationManager;
}

+ (CLLocation *) currentUserLocation {
    return locationManager.location;
}

+ (void) addressForLocation: (CLLocation*) location withCompletion: (void (^) (NSDictionary<NSString*, id>* _Nullable, NSError*)) completion {
    
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error || !placemarks.count) {
            completion(nil, error);
            return;
        }
        
        CLPlacemark* placemark = placemarks[0];
        NSDictionary<NSString*, id> * address = placemark.addressDictionary;
        if (!address.count) { return; }
        completion(address, nil);
        
    }];
}

@end
