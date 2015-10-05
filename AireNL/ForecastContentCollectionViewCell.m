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
}

- (void)updateCell
{
    self.pm10Label.text = [self.forecast.toracicParticles stringValue];
    self.pm25Label.text = [self.forecast.respirableParticles stringValue];
    self.O3Label.text = [self.forecast.ozone stringValue];
}

@end
