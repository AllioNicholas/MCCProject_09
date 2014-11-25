//
//  LocalContactsTableViewController.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 25/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalContactsTableViewController;
@class Contact;

@protocol ImportContactDelegate <NSObject>
- (void)importContactDidCancel:(LocalContactsTableViewController *)controller;
- (void)importContact:(Contact *)contact toController:(LocalContactsTableViewController *)controller;
@end

@interface LocalContactsTableViewController : UITableViewController

@property (nonatomic, weak) id <ImportContactDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
