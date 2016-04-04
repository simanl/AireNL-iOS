//
//  UIColor+ILColor.m
//  AireNL
//
//  Created by Daniel Lozano on 7/13/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "UIColor+ILColor.h"

@implementation UIColor (ILColor)

+ (UIColor *)il_goodColor
{
    return [UIColor il_goodColorWithAlpha: 1];
}

+ (UIColor *)il_regularColor
{
    return [UIColor il_regularColorWithAlpha: 1];
}

+ (UIColor *)il_badColor
{
    return [UIColor il_badColorWithAlpha: 1];
}

+ (UIColor *)il_veryBadColor
{
    return [UIColor il_veryBadColorWithAlpha: 1];
}

+ (UIColor *)il_extremelyBadColor
{
    return [UIColor il_extremelyBadColorWithAlpha: 1];
}

+ (UIColor *)il_goodColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 81.0/255.0 green: 205.0/255.0 blue: 84.0/255.0 alpha: alpha];
}

+ (UIColor *)il_regularColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 255.0/255.0 green: 215.0/255.0 blue: 0/255.0 alpha: alpha];
}

+ (UIColor *)il_badColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 243.0/255.0 green: 154.0/255.0 blue: 53.0/255.0 alpha: alpha];
}

+ (UIColor *)il_veryBadColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 230.0/255.0 green: 65.0/255.0 blue: 60.0/255.0 alpha: alpha];
}

+ (UIColor *)il_extremelyBadColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: 115.0/255.0 green: 52.0/255.0 blue: 135.0/255.0 alpha: alpha];
}

@end
