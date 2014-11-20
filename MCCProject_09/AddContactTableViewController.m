//
//  AddContactTableViewController.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 18/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "AddContactTableViewController.h"
#import "Contact.h"

@interface AddContactTableViewController ()

@end

@implementation AddContactTableViewController

@synthesize nameTextField = _nameTextField;
@synthesize surnameTextField = _surnameTextField;
@synthesize phoneTextField = _phoneTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)cancel:(id)sender {
    [self.delegate addContactViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
    Contact *contact = [[Contact alloc] initWithName:self.nameTextField.text surname:self.surnameTextField.text andPhone:self.phoneTextField.text];
    [self.delegate addContactViewController:self didAddContact:contact];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self.nameTextField becomeFirstResponder];
            break;
        case 1:
            [self.surnameTextField becomeFirstResponder];
            break;
        case 2:
            [self.phoneTextField becomeFirstResponder];
            break;            
        default:
            break;
    }

}

@end
