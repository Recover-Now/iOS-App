//
//  AccountTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNUser.h"

@interface AccountTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* emailLabel;
@property (nonatomic, strong) IBOutlet UILabel* location;
@property (nonatomic, strong) IBOutlet UITableViewCell* safeAndSoundCell;
@property (nonatomic, strong) IBOutlet UITableViewCell* inNeedCell;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;

- (IBAction)onDoneButtonPress:(id)sender;

@end
