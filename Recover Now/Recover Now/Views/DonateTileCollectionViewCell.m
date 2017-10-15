//
//  DonateTileCollectionViewCell.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "DonateTileCollectionViewCell.h"
#import <SafariServices/SafariServices.h>

@implementation DonateTileCollectionViewCell

int myNumber = 0;

- (void)decorateCellWithID:(int)number {
    myNumber = number;
    NSArray<NSString*>* names = @[@"California Wildfires", @"Las Vegas Shooting", @"Hurricanes Maria and Pinta", @"Hurrican Irma", @"Hurricane Harvey"];
    self.titleLabel.text = names[number];
}

- (void)onDonateButtonPress:(UIButton*)sender {
    NSArray<NSString*>* urls = @[];
    
    SFSafariViewController* vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urls[myNumber]]];
    [self.myContainer presentViewController:vc animated:true completion:nil];
}

@end
