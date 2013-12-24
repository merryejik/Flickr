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
#import "PlacePhotosTVC.h"

@interface TopPlacesTVC ()

@property (strong, nonatomic) NSArray *sortedCountryDictionaryKeys; // of NSString
@end

@implementation TopPlacesTVC

- (IBAction)refresh:(id)sender {
    [self loadDataFromFlicker];
}

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

- (NSDictionary *)dataFromFlickrURL:(NSURL *)topPlacesUrl
{
    NSData *topPlacesJSONData = [NSData dataWithContentsOfURL:topPlacesUrl];
    
    NSError *error;
    NSDictionary *topPlacesData = [NSJSONSerialization JSONObjectWithData:topPlacesJSONData
                                                                  options:0 error:&error];
    return topPlacesData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startRefreshing];
    [self loadDataFromFlicker];
    
}

-(void)startRefreshing
{
    self.tableView.bounds = CGRectMake(0, -self.refreshControl.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    [self.refreshControl beginRefreshing];
}

-(void)stopRefreshing
{
    self.tableView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    [self.refreshControl endRefreshing];
}


-(void)loadDataFromFlicker
{
    NSURL *topPlacesUrl = [FlickrFetcher URLforTopPlaces];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:topPlacesUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
        completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error)
        {
            NSDictionary *topPlacesData = [self dataFromFlickrURL:localFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.places = [topPlacesData valueForKeyPath:FLICKR_RESULTS_PLACES];
            });
        }];
    [task resume];
}

-(void)setPlaces:(NSArray *)places
{
    _places = places;
    [self parsePlacesByCountries];
    [self.tableView reloadData];
    [self stopRefreshing];
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
    
    self.sortedCountryDictionaryKeys = [self createSortedDictionaryKeysArray:countries];
    for (int i=0; i<self.sortedCountryDictionaryKeys.count; i++)
    {
        NSArray *arrayForSort = [self dictionary:countries ValueByKeyIndex:i];
        arrayForSort = [arrayForSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *place1 = ((Place *)obj1).name;
            NSString *place2 = ((Place *)obj2).name;
            return [place1 compare:place2 options:NSCaseInsensitiveSearch];
        }];
        countries[self.sortedCountryDictionaryKeys[i]] = arrayForSort;
    };
    

    self.placesByCountry = countries;
}


-(NSArray *)createSortedDictionaryKeysArray:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    return sortedKeys;
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
    id keyAtIndex = self.sortedCountryDictionaryKeys[index];
    return [dictionary valueForKey:keyAtIndex];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Place *place = [self placeByIndexPath:indexPath];
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.details;
    return cell;
}

-(Place *)placeByIndexPath:(NSIndexPath *)indexPath
{
    NSArray *countyPlaces = [self dictionary:self.placesByCountry ValueByKeyIndex:indexPath.section];
    return countyPlaces[indexPath.row];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sortedCountryDictionaryKeys[section];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Photo by Place"])
        if ([segue.destinationViewController isKindOfClass:[PlacePhotosTVC class]])
             {
                 PlacePhotosTVC *photosTVC = (PlacePhotosTVC *)segue.destinationViewController;
                 
                 NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                 Place *place = [self placeByIndexPath:indexPath];
                 photosTVC.placeName = place.name;
                 
                 NSURL *url = [FlickrFetcher URLforPhotosInPlace:place.id maxResults:50];
                 NSDictionary *photoDictionary = [self dataFromFlickrURL:url];
                 photosTVC.photos = [photoDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
                 NSLog(@"%@", photosTVC.photos);
             }
}

@end
