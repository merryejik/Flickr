//
//  Place.h
//  Photomania
//
//  Created by Maria on 22.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) Country *country;

@end
