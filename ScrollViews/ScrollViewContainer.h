//
//  ScrollViewContainer.h
//  ScrollViews
//
//  Created by Oleg Pochtovy on 23.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// ScrollViewContainer - UIView class for a container view whose job it is to intercept touches and hand them off to the scroll view (for PeekPagedScrollViewController class)

#import <UIKit/UIKit.h>
#import "PeekPagedScrollViewController.h"

@interface ScrollViewContainer : UIView

@property (nonatomic, strong) IBOutlet UIScrollView *myScrollView;

@end
