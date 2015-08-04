//
//  ILRadialGradient.m
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILRadialGradientLayer.h"

#import <UIKit/UIKit.h>

@interface ILRadialGradientLayer ()

@property (nonatomic) UIColor *color;

@end

@implementation ILRadialGradientLayer

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
        self.color = color;
        self.opacity = 0.6f;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    const CGFloat* colorComponents = CGColorGetComponents(self.color.CGColor);
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {colorComponents[0],colorComponents[1],colorComponents[2],colorComponents[3],
        colorComponents[0],colorComponents[1],colorComponents[2], 0.0f};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height);
    float gradRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    //    CGPoint gradCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //    float gradRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end
