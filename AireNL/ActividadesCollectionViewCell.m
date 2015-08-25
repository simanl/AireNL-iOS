//
//  ActividadesCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ActividadesCollectionViewCell.h"

@implementation ActividadesCollectionViewCell

@synthesize delegate;

- (void)updateCell
{
    
}

- (IBAction)didSelectInfo:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoAtCell:)]) {
        [self.delegate didSelectInfoAtCell: self];
    }
}

@end
