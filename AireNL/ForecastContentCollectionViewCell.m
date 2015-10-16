//
//  ForecastContentCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 10/5/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "ForecastContentCollectionViewCell.h"

@implementation ForecastContentCollectionViewCell

- (void)prepareForReuse
{
    self.forecast = nil;
    self.roundedContentView.type = ILRoundedViewTypeNone;

    [super prepareForReuse];
}

- (void)updateCell
{
    self.pm10Label.text = self.forecast.toracicParticles;
    self.pm25Label.text = self.forecast.respirableParticles;
    self.O3Label.text = self.forecast.ozone;
}

@end
