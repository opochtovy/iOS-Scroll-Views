//
//  PagedScrollViewController.m
//  ScrollViews
//
//  Created by Oleg Pochtovy on 23.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// PagedScrollViewController - class for paging with UIScrollView

#import "PagedScrollViewController.h"

@interface PagedScrollViewController ()

@property (nonatomic, strong) NSArray *pageImages; // this will hold all the images to display – 1 per page
@property (nonatomic, strong) NSMutableArray *pageViews; // this will hold instances of UIImageView to display each image on its respective page. It’s a mutable array, because we’ll be loading the pages lazily (i.e. as and when we need them) so you need to be able to insert and delete from the array

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation PagedScrollViewController

@synthesize scrollView, pageControl, pageImages, pageViews;

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // set up a scrollView programmatically
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 480.0f)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // make an array containing images
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"photo1.png"],
                       [UIImage imageNamed:@"photo2.png"],
                       [UIImage imageNamed:@"photo3.png"],
                       [UIImage imageNamed:@"photo4.png"],
                       [UIImage imageNamed:@"photo5.png"],
                       nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    // set up the page control
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 380.0f, 320.0f, 40.0f)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    [self.view addSubview:pageControl];
    
    // set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; i++) {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // load the initial set of pages that are on screen
    [self loadVisiblePages];
}

// method loadPage: loads an image to an appropriate page by index (page) and reset the container array
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // if it's outside the range of what we have to display then do nothing
        return;
    }
    
    // load an individual page, first checking if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null]) {
        // work out the frame for this page. It’s calculated as being the same size as the scroll view, positioned at zero y offset, and then offset by the width of a page multiplied by the page number in the x (horizontal) direction
        CGRect newPageViewFrame = self.scrollView.bounds;
        newPageViewFrame.origin.x = newPageViewFrame.size.width * page;
        newPageViewFrame.origin.y = 0.0f;
        
        // 3 - create a new UIImageView, set it up and add it to the scroll view
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit; // the option to scale the content to fit the size of the view by maintaining the aspect ratio. Any remaining area of the view’s bounds is transparent
        newPageView.frame = newPageViewFrame;
        [self.scrollView addSubview:newPageView];
        
        // we need to reset the container array to have an opportunity to delete the subView (page) from the scrollView depending on the object in that array (in method purgePage:)
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

// method purgePage: removes subView from scrollView (pageView) by index (page) and reset the container array
- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // if it's outside the range of what we have to display then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisiblePages {
    // first, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth *2.0f)); // floor() function will round a decimal number to the next lowest integer and is used as the one of the ways to calculate of what page we’re using the scrollView contentOffset
    
    // update the page control
    self.pageControl.currentPage = page;
    
    // we will load three pages - current, previous and next
    
    // work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
    // load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
    // purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

#pragma mark - 1 scrollview delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
