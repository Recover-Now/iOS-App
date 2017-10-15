//
//  CreateResourceTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "CreateResourceTableViewController.h"
#import "Recover_Now-Swift.h"
#import "LocationManager.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface CreateResourceTableViewController ()

@end

@implementation CreateResourceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.typePicker.delegate = self;
    self.typePicker.dataSource = self;
}


- (IBAction)onDoneButtonPress:(id)sender {
    if ([self.titleTextField.text isEqualToString:@""]) {
        [self showSimpleAlert:@"Error" message:@"Please fill out all of the fields" handler:nil];
        return;
    }
    
    CLLocation* userLoc = [LocationManager currentCoordinateLocation];
    NSString* locationKey = [LocationManager currentUserLocation];
    if (!userLoc) {
        return;
    }
    int pickerVal = [self.typePicker selectedRowInComponent:0];
    if (pickerVal < 5) {
        RNResource* res = [[RNResource alloc] init];
        res.title = self.titleTextField.text;
        res.content = self.descriptionTextView.text;
        res.poster = Accounts.userIdentifier;
        res.category = pickerVal;
        res.latitude = userLoc.coordinate.latitude;
        res.longitude = userLoc.coordinate.longitude;
        FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNResource];
        NSString* resourceID = [fbService newIdentifierKey];
        res.identifier = resourceID;
        [fbService enterDataForIdentifier:resourceID data:res];
        fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
        [[[[fbService.reference child:locationKey] child:@"resources"] child:resourceID] setValue:@true];
        fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNUserResourceList];
        [fbService addChildDataForIdentifier:Accounts.userIdentifier key:resourceID value:@true];
        [self.presentingViewController dismissViewControllerAnimated:true completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameDidCreateResource object:nil];
        }];
    } else {
        RNRecoveryArea* recovery = [[RNRecoveryArea alloc] init];
        recovery.title = self.titleTextField.text;
        recovery.content = self.descriptionTextView.text;
        recovery.poster = Accounts.userIdentifier;
        recovery.category = 0;
        recovery.latitude = userLoc.coordinate.latitude;
        recovery.longitude = userLoc.coordinate.longitude;
        FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNRecoveryArea];
        NSString* resourceID = [fbService newIdentifierKey];
        recovery.identifier = resourceID;
        [fbService enterDataForIdentifier:resourceID data:recovery];
        fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNLocation];
        [[[[fbService.reference child:locationKey] child:@"recoveryAreas"] child:resourceID] setValue:@true];
        fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNUserRecoveryAreaList];
        [fbService addChildDataForIdentifier:Accounts.userIdentifier key:resourceID value:@true];
        [self.presentingViewController dismissViewControllerAnimated:true completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameDidCreateResource object:nil];
        }];
    }
}

- (IBAction)onCancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Picker

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @[@"Housing", @"Food and Water", @"Medicine", @"Clothing", @"Rides", @"Recovery Area"][row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

@end
