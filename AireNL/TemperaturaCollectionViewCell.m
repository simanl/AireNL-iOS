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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CurrentResults *currentResults = [self.delegate getCurrentResults];
    self.temperatureLabel.text = [currentResults.temperature stringValue];
}

@end
