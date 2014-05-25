//
//  ViewController.m
//  ScrollViews
//
//  Created by Oleg Pochtovy on 17.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// ViewController - class for scrolling and zooming a large image

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation ViewController

@synthesize scrollView, imageView;

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
    
    // set up a scrollView programmatically
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    // set up the image we want to scroll & zoom and add it to the scroll view
    UIImage *image = [UIImage imageNamed:@"photo1.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    [self.scrollView addSubview:self.imageView];
    
    // set up content size of scroll view, so that it knows how far it can scroll horizontally and vertically
    self.scrollView.contentSize = image.size;
    
    // set up two gesture recognizers: one for the double-tap to zoom in, and one for the two-finger-tap to zoom out
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set up minimum zoom scale for the scroll view - in our case to see the entire image when fully zoomed out
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // set up the maximum zoom scale as 1, because zooming in more than the image’s resolution can support will cause it to look blurry
    self.scrollView.maximumZoomScale = 1.0f;
    // set up the initial zoom scale to be the minimum, so that the image starts fully zoomed out
    self.scrollView.zoomScale = minScale;
    
    // this will center the image within the scroll view
    [self centerScrollViewContents];
}

// if the scroll view content size is smaller than its bounds, then it sits in the center
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 4.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

// selector for the double-tap gesture recognizer to zoom in
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // work out where the tap occurred within the image view - to zoom in directly on that point
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // calculate a zoom scale that’s zoomed in 150%, but capped at the maximum zoom scale specified in viewDidLoad
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // use the location "pointInView" to calculate a CGRect rectangle to zoom in
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // tell the scroll view to zoom in with animation
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

// selector for the two-finger-tap gesture recognizer to zoom out
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark - 2 scrollview delegate methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // return the view that we want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // the scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
