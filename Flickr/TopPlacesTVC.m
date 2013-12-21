//
//  TopPlacesTVC.m
//  Photomania
//
//  Created by Maria on 21.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"

@interface TopPlacesTVC ()

@end

@implementation TopPlacesTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSURL *topPlacesUrl = [FlickrFetcher URLforTopPlaces];
    NSData *topPlacesJSONData = [NSData dataWithContentsOfURL:topPlacesUrl];

    NSError *error;
    NSDictionary *topPlacesData = [NSJSONSerialization JSONObjectWithData:topPlacesJSONData
                                                            options:0 error:&error];
    NSLog(@"%@", topPlacesData);
    NSArray *places = [topPlacesData valueForKeyPath:@"places.place"];
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
