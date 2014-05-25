//
//  TableController.h
//  ScrollViews
//
//  Created by Oleg Pochtovy on 17.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// TableController - is Table View DataSource and Table View Delegate for class RootTableViewController

#import <Foundation/Foundation.h>

@interface TableController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UINavigationController *myNavVC;  // to move from cell to next VC programmatically - step 1

@end
