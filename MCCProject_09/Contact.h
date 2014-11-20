//
//  Contact.h
//  MCCProject_09
//
//  Created by Nicholas Allio on 14/11/14.
//  Copyright (c) 2014 Nicholas Allio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, retain) NSString *contactID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSMutableArray *phoneNumbers;

-(id)initWithJSONDictionary:(NSDictionary*)dict;
-(id)initWithName:(NSString*)name surname:(NSString*)surname andPhone:(NSString*)phone;

@end
