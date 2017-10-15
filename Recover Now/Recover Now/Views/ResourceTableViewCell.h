//
//  ResourceTableViewCell.h
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"
#import "CDCircularImageView.h"

@interface ResourceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CDCircularImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)decorateForResource: (RNResource*)resource;

@end
