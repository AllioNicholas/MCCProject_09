//
//  DetailViewController.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactsDetailViewController : UIViewController

@property (weak, nonatomic) Contact *contact;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *surnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)saveToAddressBook:(id)sender;

@end

