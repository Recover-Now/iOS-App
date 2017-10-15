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
    NSArray<NSString*>* names = @[@"California Wildfires", @"Las Vegas Shooting", @"Hurricanes Maria & Pinta", @"Hurricane  Irma", @"Hurricane Harvey"];
    self.titleLabel.text = names[number];
    NSString* imageName = [NSString stringWithFormat:@"C%i", number];
    self.backgroundImageView.image = [UIImage imageNamed:imageName];
}

- (void)onDonateButtonPress:(UIButton*)sender {
    NSArray<NSString*>* urls = @[
                                 @"http://www.youcaring.com/tubbsfirevictimssantarosacommunity-976726",
                                 @"http://www.gofundme.com/dr2ks2-las-vegas-victims-fund",
                                 @"http://www.unicefusa.org/donate/just-28-can-help-family-puerto-rico/33002?utm_campaign=2017_misc&utm_medium=cpc&utm_source=0178/2/_Google&utm_content=PuertoRico&ms=cpc_dig_2017_misc_0178/2/_Google_PuertoRico&initialms=cpc_dig_2017_misc_0178/2/_Google_PuertoRico",
                                 @"http://www.unicefusa.org/donate/disaster-relief-help-protect-children-harm/32787?utm_campaign=2017_misc&utm_medium=cpc&utm_source=0178/2/_Google&utm_content=irma&ms=cpc_dig_2017_misc_0178/2/_Google_irma&initialms=cpc_dig_2017_misc_0178/2/_Google_irma",
                                 @"http://www.redcross.org/donate/hurricane-harvey"
                                 ];
    
    SFSafariViewController* vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urls[myNumber]]];
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    [self.myContainer presentViewController:vc animated:true completion:nil];
}

@end
