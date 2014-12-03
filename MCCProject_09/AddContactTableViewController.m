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

- (void)importContact:(Contact *)contact fromController:(LocalContactsTableViewController *)controller {
    if (contact) {
        self.nameTextField.text = contact.name;
        self.surnameTextField.text = contact.surname;
        self.phoneTextField.text = contact.phoneNumbers[0];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Contact Error"
                                                        message:@"Error during import"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

}

- (void)importContactDidCancel:(LocalContactsTableViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"importContactSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        LocalContactsTableViewController *importContactViewController = [navigationController viewControllers][0];
        importContactViewController.delegate = self;
    }
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
