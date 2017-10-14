//
//  FirstViewController.m
//  Recover Now
//
//  Created by Cliff Panos on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "CDImageView.h"

@implementation CDImageView

@end

@implementation CDCircularImageView

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
}

@end
