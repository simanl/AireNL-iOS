//
//  ILRoundedView.m
//  AireNL
//
//  Created by Daniel Lozano on 8/12/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILRoundedView.h"

@implementation ILRoundedView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.type == ILRoundedViewTypeNone) {
        self.layer.mask = nil;
        return;
    }
    
    UIRectCorner corners;
    if (self.type == ILRoundedViewTypeLeft) {
        corners = UIRectCornerTopLeft|UIRectCornerBottomLeft;
    }else if (self.type == ILRoundedViewTypeRight){
        corners = UIRectCornerTopRight|UIRectCornerBottomRight;
    }else if(self.type == ILRoundedViewTypeTop){
        corners = UIRectCornerTopLeft|UIRectCornerTopRight;
    }else if(self.type == ILRoundedViewTypeBottom){
        corners = UIRectCornerBottomLeft|UIRectCornerBottomRight;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds
                                                   byRoundingCorners: corners
                                                         cornerRadii: CGSizeMake(self.radius, self.radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setIntegerType:(NSInteger)integerType
{
    _integerType = integerType;
    _type = integerType;
    
    [self setNeedsLayout];
}

- (void)setType:(ILRoundedViewType)type
{
    _type = type;
    
    [self setNeedsLayout];
}

@end
