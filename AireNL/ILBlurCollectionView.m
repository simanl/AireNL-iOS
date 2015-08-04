//
//  ILCollectionView.m
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILBlurCollectionView.h"

#import "ILLinearGradientView.h"

#define TOP_OFFSET 158
#define BOTTOM_OFFSET 300

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
    
    // REMOVE PREVIOUS VIEWS
    [self.blurView removeFromSuperview];
    [self.fadeView removeFromSuperview];
    [self.blackView removeFromSuperview];
    
    CGSize collectionViewSize = self.bounds.size;
    CGSize collectionViewContentSize = self.contentSize;

    // BLUR EFFECT
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
    self.blurView.frame = CGRectMake(0, TOP_OFFSET, collectionViewContentSize.width, collectionViewContentSize.height + BOTTOM_OFFSET);
    
    // BLACK FADE EFFECT
    self.fadeView = [[ILLinearGradientView alloc] initWithColors: @[[UIColor clearColor], [UIColor blackColor]]];
    self.fadeView.frame = CGRectMake(0, TOP_OFFSET, collectionViewSize.width, collectionViewSize.height);
    
    // BLACK BOTTOM VIEW
    self.blackView = [[UIView alloc] init];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.frame = CGRectMake(0, TOP_OFFSET + collectionViewSize.height,
                                      collectionViewSize.width, collectionViewContentSize.height - collectionViewSize.height + BOTTOM_OFFSET);
    
    [self insertSubview: self.blurView atIndex: 0];
    [self insertSubview: self.fadeView aboveSubview: self.blurView];
    [self insertSubview: self.blackView atIndex: 1];
    
    self.hasDrawnBlur = YES;
}

@end
