//
//  ResourceTableViewCell.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourceTableViewCell.h"
#import "RNResource.h"

@implementation ResourceTableViewCell

- (void)decorateForResource: (RNResource*)resource {
    self.titleLabel.text = resource.title;
    self.descriptionLabel.text = resource.description;
    NSString* categoryName = resource.categoryDescription;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
