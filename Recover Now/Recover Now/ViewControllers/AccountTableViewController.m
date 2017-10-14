//
//  AccountTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "AccountTableViewController.h"
#import "Recover_Now-Swift.h"
#import "LocationManager.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "ResourcesCollectionViewController.h"

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.nameLabel.text = [Accounts userName];
    self.emailLabel.text = [Accounts userEmail];
    self.imageView.image = [Accounts userImage];
    
    NSString* currentLocation = [LocationManager currentUserLocation];
    if (currentLocation) {
        NSArray* parts = [currentLocation componentsSeparatedByString:@"-"];
        self.location.text = [NSString stringWithFormat:@"%@, %@", parts[2], parts[1]];
    } else {
        self.location.text = @"Unknown";
    }

    if ([Accounts userInNeed]) {
        self.inNeedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.safeAndSoundCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.safeAndSoundCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.inNeedCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (IBAction)onDoneButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath.section >= 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row");
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Sign Out" message:@"Are you sure you want to sign out?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[Accounts shared] logoutWithCompletion:^(NSError* error){
                Accounts.userIdentifier = nil;
                Accounts.userImageData = nil;
                UIStoryboard* loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:NSBundle.mainBundle];
                UIApplication.sharedApplication.keyWindow.rootViewController = [loginStoryboard instantiateInitialViewController];
            }];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    } else if (indexPath.section == 2) {
        UITableViewCell* currentCell = indexPath.row == 0 ? self.safeAndSoundCell : self.inNeedCell;
        UITableViewCell* otherCell = indexPath.row != 0 ? self.safeAndSoundCell : self.inNeedCell;
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        otherCell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 1) {
            FirebaseService* fbService = [[FirebaseService alloc] initWithEntity:kFirebaseEntityRNUser];
            [[[fbService.reference child:Accounts.userIdentifier] child:@"helpRequest"] setValue:@(NSTimeIntervalSince1970 * 1000)];
            [Accounts setUserInNeed:true];
        } else {
            [Accounts setUserInNeed:false];
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
