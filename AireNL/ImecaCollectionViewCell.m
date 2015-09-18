//
//  ImecaCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ImecaCollectionViewCell.h"

@implementation ImecaCollectionViewCell

@synthesize delegate;

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    
    NSNumber *imecaPoints = measurement.imecaPoints ?: @(0);
    
    self.imecaLabel.text = [imecaPoints stringValue];
    self.imecaQualityLabel.text = [measurement stringForAirQuality];
    self.imecaQualityView.backgroundColor = [measurement colorForAirQuality];
}

- (IBAction)didSelectInfo:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoAtCell:)]) {
        [self.delegate didSelectInfoAtCell: self];
    }
}

@end
