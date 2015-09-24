//
//  InfoContainerViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 8/26/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "InfoContainerViewController.h"

#import "InfoTableViewController.h"

@interface InfoContainerViewController ()

@property (nonatomic) InfoTableViewController *childViewController;

@end

@implementation InfoContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"embedSegue"]) {
        self.childViewController = segue.destinationViewController;
    }
}

- (IBAction)didSelectCloseButton:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Set/Get

- (void)setInfoText:(NSString *)infoText
{
    _infoText = infoText;
    self.childViewController.infoText = infoText;
}

@end
