//
//  DonateTileCollectionViewCell.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateTileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView* backgroundImageView;

- (IBAction)onDonateButtonPress:(id)sender;

- (void)decorateCellWithID:(int)number;

@end
