//
//  InterfaceController.m
//  AireNL WatchKit Extension
//
//  Created by Daniel Lozano on 8/6/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "InterfaceController.h"

#import "CurrentResults.h"

@interface InterfaceController()

@property (nonatomic) CurrentResults *currentResults;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    // Configure interface objects here.
    [super awakeWithContext: context];

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
    imecaResults.amount = @(1500);
    imecaResults.quality = @"Aceptable";
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
    [self.locationTitleLabel setText: self.currentResults.location.cityName];
    [self.locationSubtitleLabel setText: self.currentResults.location.areaName];
    
    self.imecaAmountLabel.text = [self.currentResults.imeca.amount stringValue];
    self.imecaQualityLabel.text = [NSString stringWithFormat: @"Calidad del aire:  %@", self.currentResults.imeca.quality];
}

@end



