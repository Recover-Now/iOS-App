//
//  SearchResultsTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"

@interface SearchResultsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<RNResource*>* results;

@end
