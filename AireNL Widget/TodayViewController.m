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
    imecaResults.airQuality = AirQualityTypeRegular;
    currentResults.imeca = imecaResults;
    
    MeasurementLocation *location = [[MeasurementLocation alloc] initWithCityName: @"Monterrey"
                                                                         areaName: NSLocalizedString(@"Downtown Obispado Station", nil)];
    currentResults.location = location;
    
    self.currentResults = currentResults;
    
    [self updateScreen];
}

- (void)updateScreen
{
    self.locationTitleLabel.text = [self.currentResults.location.cityName uppercaseString];
    self.locationSubtitleLabel.text = [self.currentResults.location.areaName uppercaseString];
    
    self.imecaLabel.text = [self.currentResults.imeca.amount stringValue];
    
    NSString *localizedQualityText = NSLocalizedString(@"Air Quality", nil);
    self.imecaQualityLabel.text = [NSString stringWithFormat: @"%@: %@", localizedQualityText, [self.currentResults.imeca airQualityString]];
    
    self.windLabel.text = [self stringForWindValue: self.currentResults.wind];
    self.tempLabel.text = [self stringForTempValue: self.currentResults.temperature];
}

#pragma mark - Helper's

- (NSString *)stringForWindValue:(NSNumber *)value
{
    return [NSString stringWithFormat: @"%@ k/h", value];
}

- (NSString *)stringForTempValue:(NSNumber *)value
{
    return [NSString stringWithFormat: @"%@ \u00B0 C", value];
}

@end
