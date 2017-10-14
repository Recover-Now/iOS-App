//
//  AccountTableViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "AccountTableViewController.h"
#import "Recover_Now-Swift.h"

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
    self.location.text = [Accounts userLocation];
    if ([Accounts userInNeed]) {
        self.inNeedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.safeAndSoundCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (IBAction)onDoneButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section >= 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 3) {
        [[Accounts shared] logoutWithCompletion:^(NSError* error){}];
    } else if (indexPath.section == 2) {
        UITableViewCell* currentCell = indexPath.row == 0 ? self.safeAndSoundCell : self.inNeedCell;
        UITableViewCell* otherCell = indexPath.row != 0 ? self.safeAndSoundCell : self.inNeedCell;
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        otherCell.accessoryType = UITableViewCellAccessoryNone;
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
