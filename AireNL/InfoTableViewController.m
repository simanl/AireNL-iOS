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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Set/Get

- (void)setInfoText:(NSString *)infoText
{
    _infoText = infoText;
    
    if (self.infoText.length > 0) {
        self.infoTextLabel.text = self.infoText;
        [self.tableView reloadData];
    }
}

@end
