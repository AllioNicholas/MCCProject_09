//
//  ContactsDetailViewController.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "ContactsDetailViewController.h"

@import AddressBook;

@interface ContactsDetailViewController ()
@end

@implementation ContactsDetailViewController

@synthesize contact = _contact;
@synthesize nameLabel = _nameLabel;
@synthesize surnameLabel = _surnameLabel;
@synthesize idLabel = _idLabel;
@synthesize phoneLabel = _phoneLabel;

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.contact) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", self.contact.name];
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.contact.name];
        self.surnameLabel.text = [NSString stringWithFormat:@"%@", self.contact.surname];
        self.idLabel.text = [NSString stringWithFormat:@"%@", self.contact.contactID];
        self.phoneLabel.text = [NSString stringWithFormat:@"%@", self.contact.phoneNumbers[0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveToAddressBook:(id)sender {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //Add to the local address book
        ABAddressBookRef addrBook = ABAddressBookCreateWithOptions(NULL, nil);
        ABRecordRef contact = ABPersonCreate();
        
        ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.contact.name), NULL);
        ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.contact.surname), NULL);
        ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)self.contact.phoneNumbers[0], kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumbers, nil);
        ABAddressBookAddRecord(addrBook, contact, nil);
        ABAddressBookSave(addrBook, nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Added"
                                                        message:[NSString stringWithFormat:@"Added contact %@ %@", self.contact.name, self.contact.surname]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Add Contact"
                                                        message:@"You must give the app permission to add the contact first: go to Settings->MCCProject_09 and allow access."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
@end
