//
//  VientoCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "VientoCollectionViewCell.h"

@implementation VientoCollectionViewCell

@synthesize delegate;

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    
    NSNumber *windSpeed = measurement.windSpeed ?: @(0);
    
    self.windLabel.text = [windSpeed stringValue];
}

@end
