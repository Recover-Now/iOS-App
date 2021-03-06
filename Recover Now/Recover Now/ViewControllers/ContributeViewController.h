//
//  ContributeViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContributeViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView* embedView;
@property (strong, nonatomic) UIBarButtonItem *addButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)onSegmentedControlChange:(id)sender;

@end
