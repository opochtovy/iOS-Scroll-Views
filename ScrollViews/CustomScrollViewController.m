//
//  CustomScrollViewController.m
//  ScrollViews
//
//  Created by Oleg Pochtovy on 21.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// CustomScrollViewController - class for scrolling and zooming a view hierarchy

#import "CustomScrollViewController.h"

@interface CustomScrollViewController ()
@property (nonatomic, strong) UIView *containerView; // container view to hold our custom view hierarchy

- (void)centerScrollViewContents; // if the scroll view content size is smaller than its bounds, then it sits in the center
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer;

@end

@implementation CustomScrollViewController

@synthesize scrollView, containerView;

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
    
    // set up the container view to hold our custom view hierarchy
    CGSize containerSize = CGSizeMake(640.0f, 640.0f);
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    [self.scrollView addSubview:self.containerView];
    
    // set up our custom view hierarchy
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 640.0f, 80.0f)];
    redView.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:redView];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 560.0f, 640.0f, 80.0f)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.containerView addSubview:blueView];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(160.0f, 160.0f, 320.0f, 320.0f)];
    greenView.backgroundColor = [UIColor greenColor];
    [self.containerView addSubview:greenView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bench.png"]];
    imageView.center = CGPointMake(320.0f, 320.0f);
    [self.containerView addSubview:imageView];
    
    // tell the scroll view the size of the contents
    self.scrollView.contentSize = containerSize;
    
    // set up two gesture recognizers: one for the double-tap to zoom in, and one for the two-finger-tap to zoom out
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired =2;
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
    // set up the initial zoom scale to be 1, so that the image starts by its normal size
    self.scrollView.zoomScale = 1.0f;
    
    // this will center the image within the scroll view
    [self centerScrollViewContents];
}

// if the scroll view content size is smaller than its bounds, then it sits in the center
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}

// selector for the double-tap gesture recognizer to zoom in
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // work out where the tap occurred within the image view - to zoom in directly on that point
    CGPoint pointInView = [recognizer locationInView:self.containerView];
    
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
    return self.containerView;
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
