//
//  PhotoViewController.m
//  Photomania
//
//  Created by Maria on 23.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *noPhotoLabel;
@property (nonatomic) BOOL stopZooming;
@property (retain, nonatomic) UIPopoverController *popover;
@end

@implementation PhotoViewController

-(void)setPhotoTitle:(NSString *)photoTitle
{
    _photoTitle = photoTitle;
    self.title = _photoTitle;
    
}

-(UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(UIImage *)image
{
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image
{
    self.noPhotoLabel.hidden = YES;
    self.imageView.image = image;
    
    if (image)
    {
        self.scrollView.zoomScale = 1.0;
        self.imageView.frame = CGRectMake(0,0, image.size.width, image.size.height);
        
        self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
        self.stopZooming = NO;
        
        [self.activityIndicator stopAnimating];
        [self hideMaster];
    }
}

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}


-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.stopZooming = YES;
}

- (void)scaleToFillFreeSpace
{
    if (self.image && !self.stopZooming)
    {
        float wScale = self.image.size.width/self.view.bounds.size.width;
        float hScale = self.image.size.height/self.view.bounds.size.height;
        self.scrollView.zoomScale = MAX(wScale, hScale);
    }
}

-(void)viewDidLayoutSubviews
{
    [self scaleToFillFreeSpace];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self scaleToFillFreeSpace];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self scaleToFillFreeSpace];
}

-(void)setPhotoURL:(NSURL *)photoURL
{
    _photoURL = photoURL;
    [self startDownloadPhoto];
}

-(void)startDownloadPhoto
{
    self.image = nil;
    if (self.photoURL)
    {
        [self.activityIndicator startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.photoURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                if (!error)
                    if ([request.URL isEqual:self.photoURL])
                    {
                        NSData *imageData = [NSData dataWithContentsOfURL:localFile];
                        UIImage *image = [UIImage imageWithData:imageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.image = image;
                        });
                    }
        }];
        [task resume];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
    [self.scrollView addSubview:self.imageView];
    
}

-(void)awakeFromNib
{
   //self.splitViewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISplitViewControllerDelegate
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    self.popover = pc;
    
    UIViewController *master = aViewController;
    if ([master isKindOfClass:[UITabBarController class]])
    {
        master = ((UITabBarController *)master).selectedViewController;
    }
    if ([master isKindOfClass:[UINavigationController class]])
    {
        master = [((UINavigationController *)master).viewControllers lastObject];
    }
    barButtonItem.title = master.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
    self.popover = nil;
}

-(void)hideMaster
{
    if (self.popover)
    {
        [self.popover dismissPopoverAnimated:YES];
    }
}

//-(void)dealloc
//{
//    [super dealloc];
//    self.popover = nil;
//}
@end
