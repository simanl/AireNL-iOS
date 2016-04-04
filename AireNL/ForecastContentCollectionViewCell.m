//
//  ForecastContentCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 10/5/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "ForecastContentCollectionViewCell.h"

@interface ForecastContentCollectionViewCell ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ForecastContentCollectionViewCell

@synthesize delegate;

- (void)prepareForReuse
{
    self.forecast = nil;
    self.roundedContentView.type = ILRoundedViewTypeNone;

    [super prepareForReuse];
}

- (void)updateCell
{
    NSDate *startDate = self.forecast.startsAt;
    NSDate *endDate = self.forecast.endsAt;
    NSString *dateRangeString = [NSString stringWithFormat: @"%@-%@",
                                 [self.dateFormatter stringFromDate: startDate],
                                 [self.dateFormatter stringFromDate: endDate]];
    self.timeLabel.text = dateRangeString;
    
    self.pm10Label.text = self.forecast.toracicParticlesIndex ? [self.forecast.toracicParticlesIndex stringValue] :     NSLocalizedString(@"n/a", nil);
    self.pm25Label.text = self.forecast.respirableParticlesIndex ? [self.forecast.respirableParticlesIndex stringValue] :     NSLocalizedString(@"n/a", nil);
    self.O3Label.text = self.forecast.ozoneIndex ? [self.forecast.ozoneIndex stringValue] : NSLocalizedString(@"n/a", nil);
    
    self.pm10Label.backgroundColor = [self.forecast toracicParticlesColor];
    self.pm25Label.backgroundColor = [self.forecast respirableParticlesColor];
    self.O3Label.backgroundColor = [self.forecast ozoneColor];

}

#pragma mark - IBAction's

- (IBAction)didSelectOverlay:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoWithText:)]){
        NSString *text = [NSString stringWithFormat: NSLocalizedString(@"Maximum expected value (%@)", nil), self.timeLabel.text];
        [self.delegate didSelectInfoWithText: text];
    }
}

#pragma mark - Set/Get

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return _dateFormatter;
}

@end
