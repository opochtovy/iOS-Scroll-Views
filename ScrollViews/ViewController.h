//
//  ViewController.h
//  ScrollViews
//
//  Created by Oleg Pochtovy on 17.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// ViewController - class for scrolling and zooming a large image

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end
