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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CurrentResults *currentResults = [self.delegate getCurrentResults];
    self.contaminante10Label.text = [currentResults.contaminants.pm10 stringValue];
    self.contaminante25Label.text = [currentResults.contaminants.pm25 stringValue];
    self.contaminante03Label.text = [currentResults.contaminants.O3 stringValue];
}

@end
