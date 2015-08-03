//
//  ILCollectionView.m
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILCollectionView.h"

@interface ILCollectionView ()

@property (nonatomic) UIVisualEffectView *blurView;

@end

@implementation ILCollectionView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawBlur];
}

- (void)drawBlur
{
    if (self.hasDrawnBlur) {
        return;
    }
    
    [self.blurView removeFromSuperview];
    
    // BLUR EFFECT
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
    
    CGSize contentSize = self.contentSize;
    self.blurView.frame = CGRectMake(0, 160 - 2, contentSize.width, contentSize.height + 300);
    
    [self insertSubview: self.blurView atIndex: 0];
    
    self.hasDrawnBlur = YES;
}

@end
