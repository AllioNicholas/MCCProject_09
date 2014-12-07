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


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.contact) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", self.contact.name];
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.contact.name];
        self.surnameLabel.text = [NSString stringWithFormat:@"%@", self.contact.surname];

        NSMutableString *phoneNumbers = [[NSMutableString alloc] initWithString:@""];
        if ([self.contact.phoneNumbers count] > 1) {
            for (int i=0; i<self.contact.phoneNumbers.count; i++) {
                [phoneNumbers appendFormat:@"\u2022 %@\n",self.contact.phoneNumbers[i]];
            }
        } else {
            [phoneNumbers appendString:self.contact.phoneNumbers[0]];
        }
        
        self.phoneLabel.text = [NSString stringWithFormat:@"%@",phoneNumbers];
        [self.phoneLabel setNumberOfLines:0];
        self.phoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [self.phoneLabel sizeThatFits:self.phoneLabel.frame.size];
        CGRect newFrame = CGRectMake(self.phoneLabel.frame.origin.x, self.phoneLabel.frame.origin.y, size.width, size.height);
        [self.phoneLabel setFrame:newFrame];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

/*
 * Save current contact to the local Address Book with error and authorization handling
 */
- (IBAction)saveToAddressBook:(id)sender {
    UIAlertView *alert;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //Add to the local address book
        ABAddressBookRef addrBook = ABAddressBookCreateWithOptions(NULL, nil);
        ABRecordRef contact = ABPersonCreate();
        
        ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.contact.name), NULL);
        ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.contact.surname), NULL);
        ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)self.contact.phoneNumbers[0], kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumbers, nil);
        
        Boolean exists = FALSE;
        NSArray *allContacts = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addrBook);
        for (id record in allContacts){
            ABRecordRef thisContact = (__bridge ABRecordRef)record;
            if (CFStringCompare(ABRecordCopyCompositeName(thisContact), ABRecordCopyCompositeName(contact), 0) == kCFCompareEqualTo){
                exists = TRUE;
            }
        }
        
        if (!exists) {
            ABAddressBookAddRecord(addrBook, contact, nil);
            ABAddressBookSave(addrBook, nil);
        
            alert = [[UIAlertView alloc] initWithTitle:@"Contact Added"
                                                            message:[NSString stringWithFormat:@"Added contact %@ %@", self.contact.name, self.contact.surname]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"Contact Already Exists"
                                               message:@"This contact already exists in your Address Book"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles: nil];
            [alert show];
        }
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Cannot Add Contact"
                                                        message:@"You must give the app permission to add the contact first: go to Settings->MCCProject_09 and allow access."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
@end
