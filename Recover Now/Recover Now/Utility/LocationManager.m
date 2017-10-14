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

+ (CLLocationCoordinate2D) currentUserLocation {
    return locationManager.location
}

@end
