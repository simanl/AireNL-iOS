//
//  UIColor+ILColor.m
//  AireNL
//
//  Created by Daniel Lozano on 7/13/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "UIColor+ILColor.h"

@implementation UIColor (ILColor)

+ (UIColor *)il_blueMorningColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 85.0/255.0 green: 123.0/255.0 blue: 164.0/255.0 alpha: alpha];
}

+ (UIColor *)il_beigeMorningColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 250.0/255.0 green: 197.0/255.0 blue: 163.0/255.0 alpha: alpha];
}

@end
