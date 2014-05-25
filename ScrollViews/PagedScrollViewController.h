//
//  PagedScrollViewController.h
//  ScrollViews
//
//  Created by Oleg Pochtovy on 23.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// PagedScrollViewController - class for paging with UIScrollView

#import <UIKit/UIKit.h>

@interface PagedScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end
