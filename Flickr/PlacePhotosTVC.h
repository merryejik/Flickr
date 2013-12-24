//
//  PlacePhotosTVCViewController.h
//  Photomania
//
//  Created by Maria on 23.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrDataTVC.h"

@interface PlacePhotosTVC : FlickrDataTVC

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSString *placeName;

@end
