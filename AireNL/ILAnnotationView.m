//
//  ILAnnotationView.m
//  AireNL
//
//  Created by Daniel Lozano on 8/26/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILAnnotationView.h"

@implementation ILAnnotationView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest: point withEvent: event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront: self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

@end
