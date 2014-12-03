//
//  LocalContactsTableViewController.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 25/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "LocalContactsTableViewController.h"
#import "Contact.h"

#import <AddressBook/AddressBook.h>


@interface LocalContactsTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating> {
    Contact *_importContact;
}

@property (nonatomic, strong) UISearchController *searchController;


@end

@implementation LocalContactsTableViewController

@synthesize contactsArray = _contactsArray;
@synthesize filteredContactsArray = _filteredContactsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef _people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFRelease(addressBook);
    
    self.contactsArray = [[NSArray alloc] initWithArray:(__bridge NSArray*)_people];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
    
    self.filteredContactsArray = [[NSMutableArray alloc] initWithArray:self.contactsArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchController isActive]) {
        return self.filteredContactsArray.count;
    } else {
        return self.contactsArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"localContactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ABRecordRef pers;
    if ([self.searchController isActive]) {
        pers = (__bridge ABRecordRef)([self.filteredContactsArray objectAtIndex:indexPath.row]);
    } else {
        pers = CFArrayGetValueAtIndex((__bridge CFArrayRef)self.contactsArray, indexPath.row);
    }
    
    cell.textLabel.text = (__bridge NSString *)(ABRecordCopyCompositeName(pers));
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//TODO:
    ABRecordRef cont;
    if ([self.searchController isActive]) {
        cont = (__bridge ABRecordRef)([self.filteredContactsArray objectAtIndex:indexPath.row]);
    } else {
        cont = CFArrayGetValueAtIndex((__bridge CFArrayRef)self.contactsArray, indexPath.row);
    }
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(cont, kABPersonPhoneProperty);
    NSString *numb = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    
    Contact *contact = [[Contact alloc] initWithName:CFBridgingRelease(ABRecordCopyValue(cont, kABPersonFirstNameProperty)) surname:CFBridgingRelease(ABRecordCopyValue(cont, kABPersonLastNameProperty)) andPhone:numb];
    
    [self.delegate importContact:contact fromController:self];
    [self dismissViewControllerAnimated:YES completion:^{
        // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }];
    
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.contactsArray mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchContacts = nil;
    if (strippedStr.length > 0) {
        searchContacts = [strippedStr componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchContacts) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchContactsPredicate = [NSMutableArray array];
        
        // name field matching
        NSExpression *nameLHS = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *nameRHS = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalNamePredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:nameLHS
                                       rightExpression:nameRHS
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchContactsPredicate addObject:finalNamePredicate];
        
        // surname field matching
        NSExpression *surnameLHS = [NSExpression expressionForKeyPath:@"surname"];
        NSExpression *surnameRHS = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalSurnamePredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:surnameLHS
                                       rightExpression:surnameRHS
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchContactsPredicate addObject:finalSurnamePredicate];
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = (NSCompoundPredicate *)[NSCompoundPredicate orPredicateWithSubpredicates:searchContactsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = nil;
    
    // match up the fields of the Product object
    finalCompoundPredicate = (NSCompoundPredicate *)[NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    self.filteredContactsArray = searchResults;
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
