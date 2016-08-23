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
    
    NSString *na = NSLocalizedString(@"n/a", nil);
    NSString *windString = measurement.windSpeed ? measurement.windSpeed.stringValue : na;
    
    self.windLabel.text = windString;
}

@end
