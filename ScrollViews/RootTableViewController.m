//
//  RootTableViewController.m
//  ScrollViews
//
//  Created by Oleg Pochtovy on 17.05.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// RootTableViewController - our root VC with table

#import "RootTableViewController.h"

#import "TableController.h"

@interface RootTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TableController *tableController;

@end

@implementation RootTableViewController

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
    
    // set up Back Bar Button in Navigation bar
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backPressed:)];
    
    // set up our table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
   
    self.tableController = [[TableController alloc] init];
    
    self.tableController.myNavVC = self.navigationController;  // to move from cell to next VC programmatically - step 3
    
    self.tableView.delegate = self.tableController;
    self.tableView.dataSource = self.tableController;
    
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - method for Back Bar Button
- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
