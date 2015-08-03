//
//  ILRadialGradient.h
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class UIColor;

@interface ILRadialGradient : CALayer

- (instancetype)initWithColor:(UIColor *)color;

@end
