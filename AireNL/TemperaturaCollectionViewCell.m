//
//  TemperaturaCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "TemperaturaCollectionViewCell.h"

@implementation TemperaturaCollectionViewCell

@synthesize delegate;

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    
    NSString *tempString;
    
    if (measurement.temperature){
        tempString = [NSString stringWithFormat: @"%.0f", [measurement.temperature floatValue]];
    }else{
        tempString = NSLocalizedString(@"n/a", nil);
    }
    
    self.temperatureLabel.text = tempString;
}

@end
