//
//  ContactTableViewCell.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 16/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize contactImage = _contactImage;

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
