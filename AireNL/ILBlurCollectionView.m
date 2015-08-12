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

@property (nonatomic) CGSize newSize;

@end

@implementation ILBlurCollectionView

//@synthesize needsRedraw = _needsRedraw;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (!self) return nil;
    
    self.blurNeedsRedraw = YES;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //[self drawBlur];
}

- (void)drawBlur
{
    if (!self.blurNeedsRedraw) {
        return;
    }
        
    // REMOVE PREVIOUS VIEWS
    [self.blurView removeFromSuperview];
    [self.fadeView removeFromSuperview];
    
    CGFloat width = [self width];
    CGSize collectionViewContentSize = self.contentSize;
    CGRect effectRect = CGRectMake(0, TOP_OFFSET, width, collectionViewContentSize.height + BOTTOM_OFFSET);
    
    // BLUR EFFECT
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
    self.blurView.frame = effectRect;
    
    // BLACK FADE EFFECT
    self.fadeView = [[ILLinearGradientView alloc] initWithColors: @[[UIColor clearColor], [UIColor blackColor]]];
    self.fadeView.frame = effectRect;
    
    [self insertSubview: self.blurView atIndex: 0];
    [self insertSubview: self.fadeView aboveSubview: self.blurView];
    
    self.blurNeedsRedraw = NO;
}

#pragma mark - Helper's

- (CGFloat)width
{
    if (!CGSizeEqualToSize(CGSizeZero, self.newSize)) {
        return self.newSize.width;
    }else{
        return CGRectGetWidth(self.bounds);
    }
}

#pragma mark - Set/Get

- (void)setBlurNeedsRedraw:(BOOL)blurNeedsRedraw
{
    _blurNeedsRedraw = blurNeedsRedraw;
    _newSize = CGSizeZero;
}

- (void)setBlurNeedsRedraw:(BOOL)needsRedraw withNewSize:(CGSize)size;
{
    _blurNeedsRedraw = needsRedraw;
    _newSize = size;
}

@end
