//
//  Place+Create.m
//  Photomania
//
//  Created by Maria on 23.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "Place+Create.h"
#import "DatabaseAvailability.h"
#import "FlickrFetcher.h"
#import "Country.h"

@implementation Place (Create)

+(Place *)placeWithFlickrData:(NSDictionary *)flickrData InManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = [NSEntityDescription insertNewObjectForEntityForName:PlaceEntry inManagedObjectContext:context];
    place.id = [flickrData valueForKey:FLICKR_PLACE_ID];
    
    NSString *placeDescription = [flickrData valueForKey:FLICKR_PLACE_NAME];
    NSRange firstComma = [placeDescription rangeOfString:@","];
    NSRange lastComma = [placeDescription rangeOfString:@"," options:NSBackwardsSearch];
    
    place.name = [placeDescription substringWithRange:NSMakeRange(0, firstComma.location)];
    
    NSInteger detailsLength = lastComma.location - firstComma.location - 2;
    if (detailsLength < 0)
    {
        detailsLength = placeDescription.length - firstComma.location - 2;
    }
    place.details = [placeDescription substringWithRange:NSMakeRange(firstComma.location+2, detailsLength)];
    
    if (lastComma.location != NSNotFound && lastComma.location + 2 < placeDescription.length)
    {
        NSString *countryName = [placeDescription substringFromIndex:lastComma.location+2];
        Country *country = [NSEntityDescription insertNewObjectForEntityForName:CountryEntry inManagedObjectContext:context];
        
        country.name = countryName;
        place.country = country;
    }
    
    return place;
}
@end
