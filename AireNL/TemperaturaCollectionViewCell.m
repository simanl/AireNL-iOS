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
    
    NSNumber *temperature = measurement.temperature ?: @(0);
    
    self.temperatureLabel.text = [temperature stringValue];
}

@end
