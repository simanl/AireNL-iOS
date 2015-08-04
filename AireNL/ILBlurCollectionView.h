//
//  ILCollectionView.h
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILBlurCollectionView : UICollectionView

@property (nonatomic) BOOL needsRedraw;

- (void)drawBlur;
- (void)setNeedsRedraw:(BOOL)needsRedraw withNewSize:(CGSize)size;

@end
