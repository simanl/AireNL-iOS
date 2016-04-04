//
//  UIColor+ILColor.h
//  AireNL
//
//  Created by Daniel Lozano on 7/13/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ILColor)

+ (UIColor *)il_goodColor;
+ (UIColor *)il_regularColor;
+ (UIColor *)il_badColor;
+ (UIColor *)il_veryBadColor;
+ (UIColor *)il_extremelyBadColor;

+ (UIColor *)il_goodColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)il_regularColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)il_badColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)il_veryBadColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)il_extremelyBadColorWithAlpha:(CGFloat)alpha;

@end
