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
    self.places = [topPlacesData valueForKeyPath:FLICKR_RESULTS_PLACES];
}

-(void)setPlaces:(NSArray *)places
{
    _places = places;
   // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.places count];
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.places[indexPath.row] valueForKey:FLICKR_PLACE_NAME];
    cell.detailTextLabel.text = @"Bye";
    return cell;
}
@end
