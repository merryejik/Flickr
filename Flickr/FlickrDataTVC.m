//
//  FlickrDataTVC.m
//  Photomania
//
//  Created by Maria on 24.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "FlickrDataTVC.h"

@interface FlickrDataTVC ()

@end

@implementation FlickrDataTVC

- (IBAction)refresh:(id)sender {
    [self loadDataFromFlicker];
}

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         self.managedContext = notification.userInfo[DatabaseAvailabilityContext];
         [self loadDataToDB];
         [self.tableView reloadData];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startRefreshing];
    [self loadDataFromFlicker];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadDataToDB
{
    
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
                                              [self useFlickrData:topPlacesData];
                                          });
                                      }];
    [task resume];
}

-(void)useFlickrData:(NSDictionary *)flickrData
{
    
}

- (NSDictionary *)dataFromFlickrURL:(NSURL *)url
{
    NSData *JSONData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                  options:0 error:&error];
    return data;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
