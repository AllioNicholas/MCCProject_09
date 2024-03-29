//
//  AddContactTableViewController.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 18/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddContactViewController;
@class Contact;

/*
 * Add new contact delegate
 */
@protocol AddContactViewControllerDelegate <NSObject>
- (void)addContactViewControllerDidCancel:(AddContactViewController *)controller;
- (void)addContactViewController:(AddContactViewController *)controller didAddContact:(Contact *)contact;
@end

@interface AddContactViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <AddContactViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)importFromAddressBook:(id)sender;

@end
