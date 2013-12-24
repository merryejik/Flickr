//
//  FlickrDataTVC.h
//  Photomania
//
//  Created by Maria on 24.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAvailability.h"
#import "FlickrFetcher.h"

@interface FlickrDataTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedContext;

- (NSDictionary *)dataFromFlickrURL:(NSURL *)url;
-(void)loadDataFromFlicker;
- (void)startRefreshing;
- (void)stopRefreshing;

@end
