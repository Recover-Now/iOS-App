//
//  ResourceTableViewCell.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourceTableViewCell.h"
#import "RNResource.h"
#import "RNRecoveryArea.h"

@implementation ResourceTableViewCell

- (void)decorateForResource: (RNResource*)resource {
    self.descriptionLabel.text = resource.content;
    NSInteger categoryNum = resource.category;
    NSString* strRand = [NSString stringWithFormat:@"RNIcon%i", categoryNum];
    self.iconImageView.image = [UIImage imageNamed:strRand];
    
    if ([resource isKindOfClass:[RNRecoveryArea class]]) {
        self.resourceTitleLabel.text = [NSString stringWithFormat:@"Recovery Area: %@", resource.title];
        self.iconImageView.image = [UIImage imageNamed:@"RNIconRecovery"];
    } else {
        self.resourceTitleLabel.text = resource.title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
