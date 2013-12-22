//
//  TopPlacesTVC.m
//  Photomania
//
//  Created by Maria on 21.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "Place.h"

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
    self.places = [topPlacesData valueForKeyPath:FLICKR_RESULTS_PLACES];
}

-(void)setPlaces:(NSArray *)places
{
    _places = places;
    [self parsePlacesByCountries];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parsePlacesByCountries
{
    NSMutableDictionary *countries = [[NSMutableDictionary alloc] init];
    for (NSDictionary *place in self.places)
    {
        NSString *placeName = [place valueForKey:FLICKR_PLACE_NAME];
        NSRange lastComma = [placeName rangeOfString:@"," options:NSBackwardsSearch];
        if (lastComma.location == NSNotFound) continue;
        if (lastComma.location + 2 >= placeName.length) continue;
        
        NSString *countryName = [placeName substringFromIndex:lastComma.location+2];
        if (![countries valueForKey:countryName])
        {
            countries[countryName] = [[NSMutableArray alloc] initWithObjects:place, nil];
        }
        else
        {
            [countries[countryName] addObject:place];
        }
    }
    NSLog(@"%@", countries);
    self.placesByCountry = countries;
}

-(Place *)parsePlaceDictionary:(NSDictionary *)place
{
    return nil;
}

#pragma mark - UITableViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.placesByCountry count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dictionary:self.placesByCountry ValueByKeyIndex:section] count];
}

-(id)dictionary:(NSDictionary *)dictionary ValueByKeyIndex:(NSInteger)index
{
    NSArray *allKeys = [dictionary allKeys];
    id keyAtIndex = allKeys[index];
    return [dictionary valueForKey:keyAtIndex];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *countyPlaces = [self dictionary:self.placesByCountry ValueByKeyIndex:indexPath.section];
    NSDictionary *place = countyPlaces[indexPath.row];
    
    cell.textLabel.text = [place valueForKey:FLICKR_PLACE_NAME];
    cell.detailTextLabel.text = @"Bye";
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *allKeys = [self.placesByCountry allKeys];
    return allKeys[section];
}
@end
