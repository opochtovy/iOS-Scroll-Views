//
//  CustomScrollViewController.h
//  ScrollViews
//
//  Created by Oleg Pochtovy on 21.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// CustomScrollViewController - class for scrolling and zooming a view hierarchy

#import <UIKit/UIKit.h>

@interface CustomScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end
