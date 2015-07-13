//
//  ViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/13/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ViewController.h"

#import "UIColor+ILColor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self drawBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)drawBackground
{
    UIColor *color1 = [UIColor il_blueColor];
    UIColor *color2 = [UIColor il_beigeColor];
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)color1.CGColor, (id)color2.CGColor];

    [self.view.layer insertSublayer: gradientLayer atIndex: 0];
}

@end
