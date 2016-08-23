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
    
    NSString *na = NSLocalizedString(@"n/a", nil);
    
    NSString *pm10 = measurement.toracicParticles ? measurement.toracicParticles.stringValue : na;
    NSString *pm25 = measurement.respirableParticles ? measurement.respirableParticles.stringValue : na;
    NSString *O3 = measurement.ozone ? measurement.ozone.stringValue : na;
    
    self.contaminante10Label.text = pm10;
    self.contaminante25Label.text = pm25;
    self.contaminante03Label.text = O3;
}

- (IBAction)didSelectInfo:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoAtCell:)]) {
        [self.delegate didSelectInfoAtCell: self];
    }
}

@end
