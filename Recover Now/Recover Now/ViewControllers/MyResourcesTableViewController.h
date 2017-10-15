//
//  MyResourcesTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"

@interface MyResourcesTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<RNResource*>* resources;

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@end
