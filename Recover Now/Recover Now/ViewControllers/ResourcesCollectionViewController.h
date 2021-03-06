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

@interface ResourcesCollectionViewController : UICollectionViewController <CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate>

@property (nonatomic, strong) NSMutableArray<RNResource*>* resources;

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@end
