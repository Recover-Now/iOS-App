//
//  CreateResourceTableViewController.h
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateResourceTableViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)onDoneButtonPress:(id)sender;
- (IBAction)onCancelButtonPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@end
