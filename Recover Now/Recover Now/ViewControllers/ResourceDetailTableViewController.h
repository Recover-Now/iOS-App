//
//  ResourceDetailTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNResource.h"
#import <MapKit/MapKit.h>

@interface ResourceDetailTableViewController : UITableViewController

@property (nonatomic, strong) RNResource* resource;

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* descLabel;
@property (nonatomic, weak) IBOutlet UILabel* providerLabel;
@property (nonatomic, weak) IBOutlet UILabel* phoneLabel;
@property (nonatomic, weak) IBOutlet MKMapView* mapView;

-(IBAction)onDonePressed: (id)sender;

@end
