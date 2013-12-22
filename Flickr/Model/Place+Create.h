//
//  Place+Create.h
//  Photomania
//
//  Created by Maria on 23.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+(Place *)placeWithFlickrData:(NSDictionary *)flickrData InManagedObjectContext:(NSManagedObjectContext *)context;

@end
