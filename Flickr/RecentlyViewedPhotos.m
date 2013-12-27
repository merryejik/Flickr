//
//  RecentlyViewedPhotos.m
//  Photomania
//
//  Created by Maria on 24.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "RecentlyViewedPhotos.h"
#import "FlickrPhotoParser.h"
#import "DatabaseAvailability.h"
#import "PhotoViewController.h"

@interface RecentlyViewedPhotos ()

@end

@implementation RecentlyViewedPhotos

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.title = @"Recentle viewed";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
    NSLog(@"photo count %d", self.photos.count);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadData
{
     self.photos = [[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_KEY];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [FlickrPhotoParser photoTitle:self.photos[indexPath.row]];
    cell.detailTextLabel.text = [FlickrPhotoParser photoDetail:self.photos[indexPath.row]];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Flickr Photo"])
        if ([segue.destinationViewController isKindOfClass:[PhotoViewController class]])
        {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSURL *photoURL = [FlickrPhotoParser photoURL:self.photos[indexPath.row]];
            
            PhotoViewController *phototVC = (PhotoViewController *)segue.destinationViewController;
            phototVC.photoURL = photoURL;
            phototVC.photoTitle = cell.textLabel.text;
        }
}

#pragma mark - for UISplitViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.splitViewController) return;
    
    UIViewController *detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[UINavigationController class]])
    {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    
    if ([detail isKindOfClass:[PhotoViewController class]])
    {
        NSString *photoTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self setPhotoView:self.photos[indexPath.row] title:photoTitle ToController:(PhotoViewController *)detail];
    }
}

-(void)setPhotoView:(NSDictionary *)photo title:(NSString *)title ToController:(PhotoViewController *)photoVC
{
    NSURL *photoURL = [FlickrPhotoParser photoURL:photo];
    photoVC.photoURL = photoURL;
    photoVC.photoTitle = title;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
