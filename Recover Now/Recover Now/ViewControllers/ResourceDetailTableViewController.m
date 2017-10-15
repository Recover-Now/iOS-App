//
//  ResourceDetailTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourceDetailTableViewController.h"
#import "LocationManager.h"

@interface ResourceDetailTableViewController ()

@end

@implementation ResourceDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.resource.title;
    self.descLabel.text = self.resource.content;
    self.navigationItem.title = self.resource.categoryDescription;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section != 1) {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
    
    CLLocation* userLoc = [LocationManager currentCoordinateLocation];
    
    if (self.resource.latitude == 0 && self.resource.longitude == 0 && userLoc) {
        return @"Location Unavailable";
    }
    
    
    CLLocation* resourceLocation = [[CLLocation alloc] initWithLatitude:self.resource.latitude longitude:self.resource.longitude];
    double distance = [resourceLocation distanceFromLocation:userLoc];
    int kmDistance = (int) distance / 1000;
    return [NSString stringWithFormat:@"%ikm from Your Location", kmDistance];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(IBAction)onDonePressed: (id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
