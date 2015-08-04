//
//  ILLineadGradientView.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILLinearGradientView : UIView

@property (nonatomic) BOOL hasDrawnGradient;

- (id)initWithColors:(NSArray *)colors;

@end
