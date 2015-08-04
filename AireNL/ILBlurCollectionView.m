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

@property (nonatomic) CGSize newSize;

@end

@implementation ILBlurCollectionView

@synthesize needsRedraw = _needsRedraw;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawBlur];
}

- (void)drawBlur
{
    if (!self.needsRedraw) {
        return;
    }
    
    // REMOVE PREVIOUS VIEWS
    [self.blurView removeFromSuperview];
    [self.fadeView removeFromSuperview];
//    [self.blackView removeFromSuperview];
    
//    CGSize collectionViewSize = self.bounds.size;
    CGFloat width = [self width];
    CGSize collectionViewContentSize = self.contentSize;

//    NSLog(@"VIEW SIZE : %@", NSStringFromCGSize(collectionViewSize));
//    NSLog(@"CONTENT SIZE : %@", NSStringFromCGSize(collectionViewContentSize));
    
    // BLUR EFFECT
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
    self.blurView.frame = CGRectMake(0, TOP_OFFSET, width, collectionViewContentSize.height + BOTTOM_OFFSET);
    
    // BLACK FADE EFFECT
    self.fadeView = [[ILLinearGradientView alloc] initWithColors: @[[UIColor clearColor], [UIColor blackColor]]];
    self.fadeView.frame = CGRectMake(0, TOP_OFFSET, width, collectionViewContentSize.height + BOTTOM_OFFSET);
    //    self.fadeView.frame = CGRectMake(0, TOP_OFFSET, collectionViewSize.width, collectionViewSize.height - TOP_OFFSET);
    
    // BLACK BOTTOM VIEW
//    self.blackView = [[UIView alloc] init];
//    self.blackView.backgroundColor = [UIColor redColor];
//    self.blackView.frame = CGRectMake(0, collectionViewSize.height,
//                                      collectionViewSize.width, collectionViewContentSize.height - collectionViewSize.height + BOTTOM_OFFSET);
    
    [self insertSubview: self.blurView atIndex: 0];
    [self insertSubview: self.fadeView aboveSubview: self.blurView];
//    [self insertSubview: self.blackView atIndex: 1];
    
    self.needsRedraw = NO;
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

- (BOOL)needsRedraw
{
    if (!_needsRedraw) {
        _needsRedraw = YES;
    }
    return _needsRedraw;
}

- (void)setNeedsRedraw:(BOOL)needsRedraw
{
    _needsRedraw = needsRedraw;
    _newSize = CGSizeZero;
}

- (void)setNeedsRedraw:(BOOL)needsRedraw withNewSize:(CGSize)size
{
    _needsRedraw = needsRedraw;
    _newSize = size;
}

@end
