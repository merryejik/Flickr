//
//  PhotoParser.h
//  Photomania
//
//  Created by Maria on 25.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoParser : NSObject

+(NSString *)photoTitle:(NSDictionary *)flickrData;
+(NSString *)photoDetail:(NSDictionary *)flickrData;
+(NSURL *)photoURL:(NSDictionary *)flickrData;
@end
