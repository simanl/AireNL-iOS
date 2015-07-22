//
//  ILGradientLayer.h
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class UIColor;

@interface ILGradientLayer : CALayer

- (instancetype)initWithColor:(UIColor *)color;

@end
