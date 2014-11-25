//
//  ContactsViewController.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "AddContactTableViewController.h"

@interface ContactsViewController : UITableViewController <NSURLSessionDelegate, AddContactViewControllerDelegate> 

-(void)parseJSONWithData:(NSData*)data;
- (IBAction)mergeContacts:(id)sender;

@end

