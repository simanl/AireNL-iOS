//
//  TempWindInterfaceController.m
//  AireNL
//
//  Created by Daniel Lozano on 8/10/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "TempWindInterfaceController.h"

#import "CurrentResults.h"

@interface TempWindInterfaceController ()

@property (nonatomic) CurrentResults *currentResults;

@end

@implementation TempWindInterfaceController

- (void)awakeWithContext:(id)context
{
    // Configure interface objects here.
    [super awakeWithContext:context];
    
    [self loadAssets];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Network

- (void)loadAssets
{
    CurrentResults *currentResults = [[CurrentResults alloc] init];
    currentResults.date = [NSDate date];
    currentResults.temperature = @(100);
    currentResults.wind = @(500);
    
    ImecaResults *imecaResults = [[ImecaResults alloc] init];
    imecaResults.amount = @(68);
    imecaResults.airQuality = AirQualityTypeVeryBad;
    currentResults.imeca = imecaResults;
    
    ResultLocation *location = [[ResultLocation alloc] init];
    location.cityName = @"Monterrey";
    location.areaName = @"Estacion Centro Obispado de Nuevo Leon";
    currentResults.location = location;
    
    self.currentResults = currentResults;
    
    [self updateScreen];
}

- (void)updateScreen
{
    [self setTitle: self.currentResults.location.cityName];
    
    [self.windLabel setText: [self stringForWindValue: self.currentResults.wind]];
    [self.tempLabel setText: [self stringForTempValue: self.currentResults.temperature]];
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



