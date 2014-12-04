//
//  AddContactTableViewController.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 18/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "AddContactViewController.h"
#import "Contact.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddContactViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

@implementation AddContactViewController

@synthesize nameTextField = _nameTextField;
@synthesize surnameTextField = _surnameTextField;
@synthesize phoneTextField = _phoneTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameTextField setDelegate:self];
    [self.nameTextField setReturnKeyType:UIReturnKeyDone];
    [self.nameTextField addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.surnameTextField setDelegate:self];
    [self.surnameTextField setReturnKeyType:UIReturnKeyDone];
    [self.surnameTextField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.phoneTextField setDelegate:self];
    [self.phoneTextField setReturnKeyType:UIReturnKeyDone];
    [self.phoneTextField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [self.delegate addContactViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
    [self.view endEditing:YES];
    Contact *contact = [[Contact alloc] initWithName:self.nameTextField.text surname:self.surnameTextField.text andPhone:self.phoneTextField.text];
    [self.delegate addContactViewController:self didAddContact:contact];
}

- (IBAction)importFromAddressBook:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;

    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    self.nameTextField.text = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    self.surnameTextField.text = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *phoneNumber  = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    
    self.phoneTextField.text = phoneNumber;
}

@end
