//
//  Contact.m
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize contactID = _contactID;
@synthesize name = _name;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize surname = _surname;

/*
 * Contact initializer with dictionary
 */
-(id)initWithJSONDictionary:(NSDictionary*)dict {
    if(self = [self init]) {
        _name = [dict objectForKey:@"name"];
        _surname = [dict objectForKey:@"surname"];
        _contactID = [dict objectForKey:@"_id"];
        
        if([[dict objectForKey:@"phone"] isKindOfClass:[NSArray class]]) {
            _phoneNumbers = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"phone"]];
        } else
            _phoneNumbers = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"phone"], nil];
        
    }
    return self;
}

/*
 * Contact initializer with name, surname, phone number
 */
-(id)initWithName:(NSString*)name surname:(NSString*)surname andPhone:(NSString*)phone {
    if(self = [self init]) {
        _name = name;
        _surname = surname;
        _phoneNumbers = [[NSMutableArray alloc] initWithObjects:phone, nil];
    }
    
    return self;
}

@end
