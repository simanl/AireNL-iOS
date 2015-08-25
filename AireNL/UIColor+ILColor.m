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
    return [UIColor colorWithRed: 81.0/255.0 green: 205.0/255.0 blue: 84.0/255.0 alpha: 1];
}

+ (UIColor *)il_regularColor
{
    return [UIColor colorWithRed: 255.0/255.0 green: 215.0/255.0 blue: 0/255.0 alpha: 1];
}

+ (UIColor *)il_badColor
{
    return [UIColor colorWithRed: 243.0/255.0 green: 154.0/255.0 blue: 53.0/255.0 alpha: 1];
}

+ (UIColor *)il_veryBadColor
{
    return [UIColor colorWithRed: 230.0/255.0 green: 65.0/255.0 blue: 60.0/255.0 alpha: 1];
}

+ (UIColor *)il_extremelyBadColor
{
    return [UIColor colorWithRed: 115.0/255.0 green: 52.0/255.0 blue: 135.0/255.0 alpha: 1];
}

@end
