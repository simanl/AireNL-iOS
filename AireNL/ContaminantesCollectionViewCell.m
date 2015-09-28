//
//  ContaminantesCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ContaminantesCollectionViewCell.h"

@implementation ContaminantesCollectionViewCell

@synthesize delegate;

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    
    NSNumber *pm10 = measurement.respirableSuspendedParticles ?: @(0);
    NSNumber *pm25 = measurement.fineParticles ?: @(0);
    NSNumber *O3 = measurement.ozone ?: @(0);
    
    self.contaminante10Label.text = [pm10 stringValue];
    self.contaminante25Label.text = [pm25 stringValue];
    self.contaminante03Label.text = [O3 stringValue];

}

@end
