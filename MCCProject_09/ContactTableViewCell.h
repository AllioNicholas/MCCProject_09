//
//  ContactTableViewCell.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 16/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;

@end
