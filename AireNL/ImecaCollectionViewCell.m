//
//  ImecaCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ImecaCollectionViewCell.h"

#import "UIColor+ILColor.h"

@interface ImecaCollectionViewCell ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ImecaCollectionViewCell

@synthesize delegate;

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    
    NSNumber *imecaPoints = measurement.imecaPoints;
    self.imecaLabel.text = imecaPoints? [imecaPoints stringValue] : NSLocalizedString(@"n/a", nil);
    
    self.imecaQualityLabel.text = [measurement stringForAirQuality];
    
    UIColor *airQualityColor = [measurement colorForAirQuality] ?: [UIColor il_goodColor];
    self.imecaQualityView.backgroundColor = airQualityColor;
    
    if (measurement.date) {
        self.measurementDateLabel.text = [self.dateFormatter stringFromDate: measurement.date];
    }else{
        self.measurementDateLabel.text = [self.dateFormatter stringFromDate: [NSDate date]];
    }
    
}

- (IBAction)didSelectInfo:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoAtCell:)]) {
        [self.delegate didSelectInfoAtCell: self];
    }
}

#pragma mark - Set/Get

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.dateFormat = @"HH:mm dd/MM/yyyy";
    }
    return _dateFormatter;
}

@end
