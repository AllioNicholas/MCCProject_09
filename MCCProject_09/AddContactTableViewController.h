//
//  AddContactTableViewController.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 18/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddContactTableViewController;
@class Contact;

@protocol AddContactViewControllerDelegate <NSObject>
- (void)addContactViewControllerDidCancel:(AddContactTableViewController *)controller;
- (void)addContactViewController:(AddContactTableViewController *)controller didAddContact:(Contact *)contact;
@end

@interface AddContactTableViewController : UITableViewController

@property (nonatomic, weak) id <AddContactViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
