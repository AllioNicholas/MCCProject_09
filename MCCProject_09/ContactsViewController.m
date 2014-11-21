//
//  ContactsViewController.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsDetailViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"


NSString *_masterURL = @"http://130.233.42.182:8080";

@interface ContactsViewController () {
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addContactButton;
@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ContactsViewController

@synthesize contacts = _contacts;
@synthesize session = _session;
@synthesize addContactButton = _addContactButton;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        config.timeoutIntervalForRequest = 10.0;
        config.timeoutIntervalForResource = 15.0;
        config.HTTPMaximumConnectionsPerHost = 1;
        config.allowsCellularAccess = YES;
        
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self downloadContactList];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Request authorization to Address Book
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // Check whether we are authorized to access the user's address book data
    [self checkAuthorization];
    
}

-(void)checkAuthorization {
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            NSLog(@"User authorized");
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess {
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                                                 if (granted) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         NSLog(@"Access granted");
                                                         [self addGroup:@"MCCGroup09" fromAddressBook:self.addressBook];
                                                     });
                                                 }
                                             });
}

// Create and add a new group to the address book database
- (void)addGroup:(NSString *)name fromAddressBook:(ABAddressBookRef)myAddressBook {
    ABRecordRef newGroup = ABGroupCreate();
    CFStringRef newName = CFBridgingRetain(name);
    ABRecordSetValue(newGroup,kABGroupNameProperty,newName,NULL);
    
    // Add the new group
    ABAddressBookAddRecord(myAddressBook,newGroup, NULL);
    ABAddressBookSave(myAddressBook, NULL);
    CFRelease(newName);
}

- (void)downloadContactList {
    NSString *contactString = [NSString stringWithFormat:@"%@/contacts", _masterURL];
    NSURL *contactURL = [NSURL URLWithString:contactString];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:contactURL
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
                                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                     if (!error) {
                                                         NSLog(@"%d", httpResp.statusCode);
                                                         if (httpResp.statusCode == 200) {
                                                             [self parseJSONWithData:data];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                 [self.tableView reloadData];
                                                             });
                                                         } else if (httpResp.statusCode == 500) {
                                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internal Server Error"
                                                                                                             message:[NSString stringWithFormat:@"HTTP Response Code: %d", httpResp.statusCode]
                                                                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles: nil];
                                                             [alert show];
                                                         }
                                                     } else {
                                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                        message:[NSString stringWithFormat:@"HTTP Response Code: %d", httpResp.statusCode]
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                                                        [alert show];
                                                     }
                                                 }];
    
    [dataTask resume];
}

- (void)parseJSONWithData:(NSData*)data {
    NSError *jsonError;
    NSArray *rawContacts = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    self.contacts = [[NSMutableArray alloc] init];
    
    if (!jsonError) {
        for (NSDictionary *dict in rawContacts) {
            Contact *c = [[Contact alloc] initWithJSONDictionary:dict];
            [self.contacts addObject:c];
        }
    }
}

- (IBAction)mergeContacts:(id)sender {
    //TODO: implement merging of contacts
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showContactDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactsDetailViewController *segueViewController = segue.destinationViewController;
        segueViewController.contact = self.contacts[indexPath.row];
    }
    
    if ([segue.identifier isEqualToString:@"NewContact"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddContactTableViewController *addContactViewController = [navigationController viewControllers][0];
        addContactViewController.delegate = self;
    }

}

#pragma mark - AddContactViewControllerDelegate

- (void)addContactViewControllerDidCancel:(AddContactTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addContactViewController:(AddContactTableViewController *)controller didAddContact:(Contact *)contact {
    NSError *error;
    //Add contact to the server in a JSON form
    NSDictionary *rawContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                contact.name, @"name",
                                contact.surname, @"surname",
                                contact.phoneNumbers[0], @"phone",
                                nil];
        
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rawContact options:kNilOptions error:&error];
    if(!jsonData) {
        NSLog(@"Error in creating json");
    } else {
        NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/contacts", _masterURL]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postURL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSURLSessionUploadTask *uploadContact = [self.session uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                if (!error && httpResp.statusCode == 201) {
                    NSLog(@"Contact correctly created and pushed");
                    //parse response data to extract contact id of the newly created one
                    NSError *jsonError;
                    NSArray *rawContact = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                    if(!jsonError) {
                        contact.contactID = [(NSDictionary*)rawContact objectForKey:@"_id"];
                    }
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Creating Contact Error"
                                                                    message:[NSString stringWithFormat:@"HTTP Response Code: %d", httpResp.statusCode]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
        }];
        [uploadContact resume];
    }
    //Update current "local list" on the app
    [self.contacts addObject:contact];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.contacts indexOfObject:contact] inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];

    Contact *person = _contacts[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", person.surname, person.name];
    cell.contactImage.image = [UIImage imageNamed:@"user.png"];
    cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2;
    cell.contactImage.clipsToBounds = YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Handle the deletion of a contact
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Send DELETE to the server and delet contact
        NSURL *deleteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/contacts/%@", _masterURL, [[self.contacts objectAtIndex:indexPath.row] contactID]]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:deleteURL];
        [request setHTTPMethod:@"DELETE"];
        NSURLSessionDataTask *deleteContact = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode != 204 || error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error on delete"
                                                                message:[NSString stringWithFormat:@"HTTP Response Code: %d", httpResp.statusCode]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            } else {
                NSLog(@"Contact deleted");
            }
        }];
        
        [deleteContact resume];
        
        [self.contacts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        [self.addContactButton setEnabled:NO];
    } else {
        [self.addContactButton setEnabled:YES];
    }
}

- (void)refreshTable {
    [self downloadContactList];
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
