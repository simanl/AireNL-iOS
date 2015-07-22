//
//  HeaderCollectionReusableView.m
//  AireNL
//
//  Created by Daniel Lozano on 7/22/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (IBAction)userDidSelectMap:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(userDidSelectMap)]) {
        [self.delegate userDidSelectMap];
    }
}

@end
