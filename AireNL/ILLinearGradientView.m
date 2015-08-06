//
//  ILLineadGradientView.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILLinearGradientView.h"

@interface ILLinearGradientView ()

@property (nonatomic) NSArray *colors;

@end

@implementation ILLinearGradientView

- (id)initWithColors:(NSArray *)colors
{
    self = [super init];
    if (!self) return nil;
    
    self.needsRedraw = YES;
    self.colors = colors;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawBackgroundGradient];
}

- (void)drawBackgroundGradient
{
    if (!self.needsRedraw || [self.colors count] < 2) {
        return;
    }
    
    UIColor *color1 = self.colors[0];
    UIColor *color2 = self.colors[1];
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)color1.CGColor, (id)color2.CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    
    [self.layer insertSublayer: gradientLayer atIndex: 0];
    
    self.needsRedraw = NO;
}

@end
