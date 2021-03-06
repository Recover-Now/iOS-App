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
#import "RNRecoveryArea.h"

@implementation ResourceCollectionViewCell

- (void) decorateForResource: (RNResource*) resource {
    if ([resource isKindOfClass:[RNRecoveryArea class]]) {
        self.typeLabel.text = @"Recovery Area";
    } else {
        self.typeLabel.text = resource.categoryDescription;
    }
    
    NSInteger categoryNum = resource.category;
    int rand = arc4random_uniform(2);
    NSString* strRand = [NSString stringWithFormat:@"RN%i%i", categoryNum, rand];
    self.imageView.image = [UIImage imageNamed:strRand];
    
    if ([resource isKindOfClass:[RNRecoveryArea class]]) {
        self.imageView.image = [UIImage imageNamed:@"RNRecovery"];
    }
    
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
