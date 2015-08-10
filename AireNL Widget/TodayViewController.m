//
//  TodayViewController.m
//  AireNL Widget
//
//  Created by Daniel Lozano on 8/5/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "TodayViewController.h"

#import <NotificationCenter/NotificationCenter.h>

#import "CurrentResults.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic) CurrentResults *currentResults;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadAssets];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

#pragma mark - Network / Appearance

- (void)loadAssets
{
    CurrentResults *currentResults = [[CurrentResults alloc] init];
    currentResults.date = [NSDate date];
    currentResults.temperature = @(100);
    currentResults.wind = @(500);
    
    ImecaResults *imecaResults = [[ImecaResults alloc] init];
    imecaResults.amount = @(184);
    imecaResults.quality = @"Aceptable";
    currentResults.imeca = imecaResults;
    
    ResultLocation *location = [[ResultLocation alloc] init];
    location.cityName = @"Monterrey";
    location.areaName = @"Estacion Centro Obispado";
    currentResults.location = location;
    
    self.currentResults = currentResults;
    
    [self updateScreen];
}

- (void)updateScreen
{
    self.locationTitleLabel.text = [self.currentResults.location.cityName uppercaseString];
    self.locationSubtitleLabel.text = [self.currentResults.location.areaName uppercaseString];
    
    self.imecaLabel.text = [self.currentResults.imeca.amount stringValue];
    self.imecaQualityLabel.text = [NSString stringWithFormat: @"Calidad del aire:  %@", self.currentResults.imeca.quality];
    
    self.windLabel.text = [NSString stringWithFormat: @"%@ km/h", self.currentResults.wind];
    self.tempLabel.text = [NSString stringWithFormat: @"%@ \u00B0 C", self.currentResults.temperature];
}

@end
