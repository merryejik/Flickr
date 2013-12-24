//
//  PhotoParser.m
//  Photomania
//
//  Created by Maria on 25.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "FlickrPhotoParser.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoParser

+(NSString *)photoTitle:(NSDictionary *)flickrData
{
    NSString *title = [flickrData valueForKeyPath:FLICKR_PHOTO_TITLE];
   
    if (!title || [title isEqualToString:@""])
    {
        NSString *detail = [flickrData valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        if (!detail || [detail isEqualToString:@""]) {
            title = @"UNKNOW";
        } else title = detail;
    }
    
    return title;
}

+(NSString *)photoDetail:(NSDictionary *)flickrData
{
    return [flickrData valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

+(NSURL *)photoURL:(NSDictionary *)flickrData
{
    return [FlickrFetcher URLforPhoto:flickrData format:FlickrPhotoFormatLarge];
}
@end
