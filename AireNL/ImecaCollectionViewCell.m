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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CurrentResults *currentResults = [self.delegate getCurrentResults];
    self.imecaLabel.text = [currentResults.imeca.amount stringValue];
    self.imecaQualityLabel.text = [currentResults.imeca airQualityString];
    self.imecaQualityView.backgroundColor = [currentResults.imeca airQualityColor];
    self.imecaQualityView.alpha = 0.8f;
}

- (IBAction)didSelectInfo:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoAtCell:)]) {
        [self.delegate didSelectInfoAtCell: self];
    }
}

@end
