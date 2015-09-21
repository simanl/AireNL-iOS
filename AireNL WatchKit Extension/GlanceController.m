//
//  GlanceController.m
//  AireNL WatchKit Extension
//
//  Created by Daniel Lozano on 8/6/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "GlanceController.h"

//#import "CurrentResults.h"

@interface GlanceController()

//@property (nonatomic) CurrentResults *currentResults;

@end

@implementation GlanceController

- (void)awakeWithContext:(id)context
{
    // Configure interface objects here.
    [super awakeWithContext:context];

    [self loadAssets];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Network

- (void)loadAssets
{
//    CurrentResults *currentResults = [[CurrentResults alloc] init];
//    currentResults.date = [NSDate date];
//    currentResults.temperature = @(100);
//    currentResults.wind = @(500);
//    
//    ImecaResults *imecaResults = [[ImecaResults alloc] init];
//    imecaResults.amount = @(68);
//    imecaResults.airQuality = AirQualityTypeVeryBad;
//    currentResults.imeca = imecaResults;
//    
//    MeasurementLocation *location = [[MeasurementLocation alloc] initWithCityName: @"Monterrey"
//                                                                         areaName: NSLocalizedString(@"Downtown Obispado Station", nil)];
//    currentResults.location = location;
//    
//    self.currentResults = currentResults;
    
    [self updateScreen];
}

- (void)updateScreen
{
//    [self.locationTitleLabel setText: self.currentResults.location.cityName];
//    [self.locationSubtitleLabel setText: self.currentResults.location.areaName];
//    
//    [self.imecaAmountLabel setText: [self.currentResults.imeca.amount stringValue]];
//    [self.imecaQualityLabel setText: [self.currentResults.imeca airQualityString]];
}

@end



