//
//  TopPlacesTVC.m
//  Photomania
//
//  Created by Maria on 21.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "DatabaseAvailability.h"

@interface TopPlacesTVC ()

@end

@implementation TopPlacesTVC

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         self.managedContext = notification.userInfo[DatabaseAvailabilityContext];
         [self parsePlacesByCountries];
         [self.tableView reloadData];
     }];
}

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

    self.places = [topPlacesData valueForKeyPath:FLICKR_RESULTS_PLACES];
}

-(void)setPlaces:(NSArray *)places
{
    _places = places;
   // [self parsePlacesByCountries];
   // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parsePlacesByCountries
{
    NSMutableDictionary *countries = [[NSMutableDictionary alloc] init];
    for (NSDictionary *placeFlickr in self.places)
    {
        Place *place = [Place placeWithFlickrData:placeFlickr InManagedObjectContext:self.managedContext];
        NSString *countryName = place.country.name;
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
    Place *place = countyPlaces[indexPath.row];
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.details;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *allKeys = [self.placesByCountry allKeys];
    return allKeys[section];
}
@end
