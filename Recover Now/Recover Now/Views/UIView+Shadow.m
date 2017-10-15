//
//  UIView+Shadow.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

-(void) shadow {
    self.layer.masksToBounds = false;
    self.layer.cornerRadius = 7;
    self.layer.shadowColor = UIColor.lightGrayColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 9;
    self.layer.shadowOpacity = 0.6;
}

@end
