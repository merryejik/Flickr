//
//  PlacePhotosTVCViewController.m
//  Photomania
//
//  Created by Maria on 23.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "PlacePhotosTVC.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "FlickrPhotoParser.h"

@interface PlacePhotosTVC ()

@end

@implementation PlacePhotosTVC

-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

-(void)setPlaceName:(NSString *)placeName
{
    _placeName = placeName;
    self.title = placeName;
}

-(void)useFlickrData:(NSDictionary *)flickrData
{
    [super useFlickrData:flickrData];
    self.photos = [flickrData valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [FlickrPhotoParser photoTitle:self.photos[indexPath.row]];
    cell.detailTextLabel.text = [FlickrPhotoParser photoDetail:self.photos[indexPath.row]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show photo"])
        if ([segue.destinationViewController isKindOfClass:[PhotoViewController class]])
        {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            PhotoViewController *photoVC = (PhotoViewController *)segue.destinationViewController;
            [self setPhotoView:self.photos[indexPath.row] title:cell.textLabel.text ToController:photoVC];
        }
}

-(void)setPhotoView:(NSDictionary *)photo title:(NSString *)title ToController:(PhotoViewController *)photoVC
{
    NSURL *photoURL = [FlickrPhotoParser photoURL:photo];
    photoVC.photoURL = photoURL;
    photoVC.photoTitle = title;
    
    [self savePhotoToRecent:photo];
}

-(void)savePhotoToRecent:(NSDictionary *)photo
{
    NSMutableArray* recentPhotos = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:RECENT_PHOTOS_KEY];
    
    if ([recentPhotos containsObject:photo]) return;

    [recentPhotos insertObject:photo atIndex:0];
    if (recentPhotos.count>20)
    {
        [recentPhotos removeObjectAtIndex:20];
        NSLog(@"recent photos count %d", recentPhotos.count);
    }
    [[NSUserDefaults standardUserDefaults] setValue:recentPhotos forKey:RECENT_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
