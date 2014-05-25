//
//  TableController.m
//  ScrollViews
//
//  Created by Oleg Pochtovy on 17.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// TableController - is Table View DataSource and Table View Delegate for class RootTableViewController

#import "TableController.h"

#import "ViewController.h"
#import "CustomScrollViewController.h"
#import "PagedScrollViewController.h"
#import "PeekPagedScrollViewController.h"

@implementation TableController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Image scroll";
            break;
        case 1:
            cell.textLabel.text = @"Custom view scroll";
            break;
        case 2:
            cell.textLabel.text = @"Paged";
            break;
        case 3:
            cell.textLabel.text = @"Paged with peeking";
            break;
            
        default:
            cell.textLabel.text = @"New cell";
            break;
    }
    
    return cell;
}

// to move from cell to next VC programmatically - step 2
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        ViewController *myVC = [[ViewController alloc] init];
        myVC.title = @"Image";
        
        [self.myNavVC pushViewController:myVC animated:YES];
    } else if (indexPath.row == 1)
    {
        CustomScrollViewController *customVC = [[CustomScrollViewController alloc] init];
        customVC.title = @"Custom view";
        
        [self.myNavVC pushViewController:customVC animated:YES];
    } else if (indexPath.row == 2)
    {
        PagedScrollViewController *pagedVC = [[PagedScrollViewController alloc] init];
        pagedVC.title = @"Paged";
        
        [self.myNavVC pushViewController:pagedVC animated:YES];
    } else if (indexPath.row == 3)
    {
        PeekPagedScrollViewController *peekPagedVC = [[PeekPagedScrollViewController alloc] init];
        peekPagedVC.title = @"Peek paged";
        
        [self.myNavVC pushViewController:peekPagedVC animated:YES];
    }
    
}

@end
