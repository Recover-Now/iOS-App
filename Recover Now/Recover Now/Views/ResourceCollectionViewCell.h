//
//  ResourceCollectionViewCell.h
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"

@interface ResourceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel* typeLabel;
@property (nonatomic, strong) UILabel* distanceLabel;
@property (nonatomic, strong) UIImageView* imageView;

- (void) decorateForResource: (RNResource*) resource;

@end
