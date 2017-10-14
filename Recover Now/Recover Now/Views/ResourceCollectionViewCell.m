//
//  ResourceCollectionViewCell.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourceCollectionViewCell.h"
#import <Foundation/Foundation.h>
#import "LocationManager.h"

@implementation ResourceCollectionViewCell

- (void) decorateForResource: (RNResource*) resource {
    self.typeLabel.text = resource.categoryDescription;
    self.imageView.image = [UIImage imageNamed:@"Water"];
    self.distanceLabel.text = @"—";
    
    CLLocation* userLocation = [LocationManager currentCoordinateLocation];

    if (resource.longitude && resource.latitude && userLocation) {
        CLLocation* resourceLocation = [[CLLocation alloc] initWithLatitude:resource.latitude longitude:resource.longitude];
        double distance = [resourceLocation distanceFromLocation:userLocation];
        int kmDistance = (int) distance / 1000;
        self.distanceLabel.text = [NSString stringWithFormat:@"%ikm", kmDistance];
    }
}

@end
