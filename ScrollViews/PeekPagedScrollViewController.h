//
//  PeekPagedScrollViewController.h
//  ScrollViews
//
//  Created by Oleg Pochtovy on 23.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// PeekPagedScrollViewController - class for viewing previous/next pages

#import <UIKit/UIKit.h>

@interface PeekPagedScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end
