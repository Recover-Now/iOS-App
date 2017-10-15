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
#import <MessageUI/MessageUI.h>
#import <CoreNFC/CoreNFC.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface ResourceDetailTableViewController : UITableViewController <MFMessageComposeViewControllerDelegate, NFCNDEFReaderSessionDelegate>

@property (nonatomic, strong) RNResource* resource;
@property (nonatomic) bool shouldShowCloseButton;

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* descLabel;
@property (nonatomic, weak) IBOutlet UILabel* providerLabel;
@property (nonatomic, weak) IBOutlet UILabel* phoneLabel;
@property (nonatomic, weak) IBOutlet MKMapView* mapView;

@property (nonatomic, strong) NFCNDEFReaderSession* nfcSession;

-(IBAction)onDonePressed: (id)sender;
-(IBAction)checkInPressed: (id)sender;
- (IBAction)onShareButtonPress:(UIBarButtonItem*)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;

@end
