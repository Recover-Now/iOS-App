//
//  ResourceDetailTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourceDetailTableViewController.h"
#import "LocationManager.h"
#import "Recover_Now-Swift.h"
#import "LocationManager.h"

@interface ResourceDetailTableViewController ()

@end

@implementation ResourceDetailTableViewController

@synthesize nfcSession;

double distance = -1;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.shouldShowCloseButton = true;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.resource.title;
    self.descLabel.text = self.resource.content;
    if ([self.resource isKindOfClass:[RNRecoveryArea class]]) {
        self.navigationItem.title = @"Recovery Area";
    } else {
        self.navigationItem.title = self.resource.categoryDescription;
    }
    if (!self.shouldShowCloseButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    CLLocation* userLoc = [LocationManager currentCoordinateLocation];
    if ((self.resource.latitude != 0 || self.resource.longitude != 0) && userLoc) {
        NSLog(@"Setting up map");
        [self.mapView setShowsUserLocation:true];
        CLLocation* resourceLocation = [[CLLocation alloc] initWithLatitude:self.resource.latitude longitude:self.resource.longitude];
        distance = [resourceLocation distanceFromLocation:userLoc];
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.resource.latitude, self.resource.longitude), MKCoordinateSpanMake(distance / 111000 * 3, distance / 111000 * 3))];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:resourceLocation.coordinate];
        [self.mapView addAnnotation:annotation];
        self.mapView.userInteractionEnabled = false;
    } else {
        distance = -1;
    }
    
    FirebaseService *fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNUser];
    [fbService retrieveDataForIdentifier:self.resource.poster completion:^(FirebaseObject * _Nonnull obj) {
        RNUser* user = (RNUser*)obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.providerLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
            self.phoneLabel.text = user.phoneNumber;
        });
    }];
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section != 1) {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
    
    if (distance == -1) {
        return @"Location Unavailable";
    }
    
    int kmDistance = (int) distance / 1000;
    return [NSString stringWithFormat:@"%ikm from Your Location", kmDistance];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0 && distance == -1) {
        return 0;
    }
    if (indexPath.section == 1 && indexPath.row == 1 && ![self.resource isKindOfClass:[RNRecoveryArea class]]) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}

-(IBAction)onDonePressed: (id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 2) {
        if (![MFMessageComposeViewController canSendText]) {
            [self showSimpleAlert:@"Error" message:@"This device is not capable of sending text messages" handler:nil];
            return;
        }
        MFMessageComposeViewController* compose = [[MFMessageComposeViewController alloc] init];
        compose.messageComposeDelegate = self;
        [compose setRecipients:@[self.phoneLabel.text]];
        compose.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:compose animated:true completion:nil];
    } else if (indexPath.section == 1) {
        
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:true completion:nil];
}




# pragma begin NFC reading logic

-(IBAction)checkInPressed: (id)sender {
    self.nfcSession = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:true];
    if (@available(iOS 11.0, *)) {
        if (!NFCNDEFReaderSession.readingAvailable) {
            [self showSimpleAlert:@"Device Not Supported" message:@"This device does not support checking in via NFC Code." handler:nil];
            return;
        }
        self.nfcSession.alertMessage = @"Hold iPhone near a Recovery Location tag.";
        [self.nfcSession beginSession];
    } else {
        [self showSimpleAlert:@"Upgrade to iOS 11 to be able to check in via NFC tag." message:nil handler:nil];
    }
}

-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages {
    NSLog(@"NFC Reading returned something!!");
    NFCNDEFPayload* message = [[[messages objectAtIndex:0] records] objectAtIndex:0];
    NSData* data = message.payload;
    NSString* areaIdentifier = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!areaIdentifier) {
        [self showSimpleAlert:@"Unsuccessful Tag Read" message:@"Try to read the tag again. Tags must be NDEF encoded." handler:nil];
        return;
    }
    NSLog(areaIdentifier);
    
    if (![areaIdentifier isEqualToString:self.resource.identifier]) {
        [self showSimpleAlert:@"Invalid Location" message:@"The tag read does not correspond to this Recovery Area location." handler:nil];
            return;
    }
    FirebaseService* service = [[FirebaseService alloc] initWithEntity:@"RNCheckIn"];
    [[[[service reference] child:areaIdentifier] child:[Accounts userIdentifier]] setValue: [Accounts userName]];
    

}

-(void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error {
    if (!error) { return; }
    //[self showSimpleAlert:@"Unable to Check In via scan" message:@"An error occurred while trying to scan the information to check you in." handler:nil];
}


@end
