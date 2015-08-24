//
//  AirQualityInfoTableViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 8/24/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "AirQualityInfoTableViewController.h"

@interface AirQualityInfoTableViewController ()

@end

@implementation AirQualityInfoTableViewController

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

@end
