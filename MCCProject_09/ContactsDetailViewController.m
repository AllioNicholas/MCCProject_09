//
//  ContactsDetailViewController.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "ContactsDetailViewController.h"

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

@end
