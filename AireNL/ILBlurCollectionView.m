//
//  ILCollectionView.m
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILBlurCollectionView.h"

#import "ILLinearGradientView.h"

@interface ILBlurCollectionView ()

@property (nonatomic) UIVisualEffectView *blurView;
@property (nonatomic) ILLinearGradientView *fadeView;
@property (nonatomic) UIView *blackView;

@end

@implementation ILBlurCollectionView

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
    
    // REMOVE EFFECTS
    [self.blurView removeFromSuperview];
    [self.fadeView removeFromSuperview];
    [self.blackView removeFromSuperview];
    
    
    // BLUR EFFECT
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
    
    CGSize contentSize = self.contentSize;
    self.blurView.frame = CGRectMake(0, 160-2, contentSize.width, contentSize.height + 300);
    
    [self insertSubview: self.blurView atIndex: 0];

    // FADE EFFECT
    self.fadeView = [[ILLinearGradientView alloc] initWithColors: @[[UIColor clearColor], [UIColor blackColor]]];
    CGSize collectionViewSize = self.bounds.size;
    self.fadeView.frame = CGRectMake(0, 160-2, collectionViewSize.width, collectionViewSize.height);
    [self insertSubview: self.fadeView aboveSubview: self.blurView];
    
    self.blackView = [[UIView alloc] init];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.frame = CGRectMake(0, (160-2)+collectionViewSize.height, collectionViewSize.width, contentSize.height - collectionViewSize.height + 300);
    [self insertSubview: self.blackView atIndex: 1];
    
    self.hasDrawnBlur = YES;
}

@end
