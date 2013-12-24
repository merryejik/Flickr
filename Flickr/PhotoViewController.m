//
//  PhotoViewController.m
//  Photomania
//
//  Created by Maria on 23.12.13.
//  Copyright (c) 2013 Maria Naschanskaya. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
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
    self.imageView.image = image;
    
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0,0, image.size.width, image.size.height);
    
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
    [self.activityIndicator stopAnimating];
}

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
