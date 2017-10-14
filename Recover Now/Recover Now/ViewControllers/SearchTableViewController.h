//
//  SearchTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"

@interface SearchTableViewController : UITableViewController

@property (strong, nonatomic) NSArray<RNResource*>* results;

@end
