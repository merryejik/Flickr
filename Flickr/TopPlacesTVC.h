//
//  TopPlacesTVC.h
//  Photomania
//
//  Created by Maria on 21.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "FlickrDataTVC.h"

@interface TopPlacesTVC : FlickrDataTVC

@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSDictionary *placesByCountry; //of Place by CountryName

@end
