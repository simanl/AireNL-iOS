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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CurrentResults *currentResults = [self.delegate getCurrentResults];
    self.windLabel.text = [currentResults.wind stringValue];
}

@end
