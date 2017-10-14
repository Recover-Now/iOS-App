//
//  ResourcesCollectionViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RNResource.h"

@interface ResourcesCollectionViewController : UICollectionViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray<RNResource*>* resources;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (nonatomic, strong) IBOutlet UIImageView* profileImageView;

@end
