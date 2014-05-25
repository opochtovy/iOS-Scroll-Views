//
//  ScrollViewContainer.m
//  ScrollViews
//
//  Created by Oleg Pochtovy on 23.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// ScrollViewContainer - UIView class for a container view whose job it is to intercept touches and hand them off to the scroll view (for PeekPagedScrollViewController class)

#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

@synthesize myScrollView;

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return self.myScrollView;
    }
    return view;
}

@end
