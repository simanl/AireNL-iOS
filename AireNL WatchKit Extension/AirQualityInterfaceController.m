//
//  AirQualityInterfaceController.m
//  AireNL
//
//  Created by Daniel Lozano on 8/10/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "AirQualityInterfaceController.h"

#import "Station.h"
#import "Measurement.h"

#import "Constants.h"

@interface AirQualityInterfaceController ()

@property (nonatomic) Station *selectedStation;
@property (nonatomic) Measurement *selectedMeasurement;

@end

@implementation AirQualityInterfaceController

- (void)awakeWithContext:(id)context
{
    // Configure interface objects here.
    [super awakeWithContext:context];
    
    [self setUpNotifications];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self updateScreen];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)setUpNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleLoadNotification:)
                                                 name: kWatchkitDidDownloadDataNotification
                                               object: nil];
}

#pragma mark - Network

- (void)handleLoadNotification:(NSNotification *)notification
{
    NSLog(@"Air Quality Controller : Handle Load Notification");
    
    NSDictionary *userInfo = notification.userInfo;
    
    self.selectedStation = userInfo[@"selectedStation"];
    self.selectedMeasurement = userInfo[@"selectedMeasurement"];
        
    [self updateScreen];
}

#pragma mark - Appearance

- (void)updateScreen
{
    [self setTitle: self.selectedStation.name];
    [self.airQualityLabel setText: [self.selectedMeasurement stringForAirQuality]];
}

@end



