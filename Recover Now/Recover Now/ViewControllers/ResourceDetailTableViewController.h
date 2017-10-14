//
//  ResourceDetailTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"

@interface ResourceDetailTableViewController : UITableViewController

@property (nonatomic, strong) RNResource* resource;

-(IBAction)onDonePressed: (id)sender;

@end
