//
//  InfoTableViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 8/25/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "InfoTableViewController.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectClose:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

@end
