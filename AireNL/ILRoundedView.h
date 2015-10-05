//
//  ILRoundedView.h
//  AireNL
//
//  Created by Daniel Lozano on 8/12/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

typedef NS_ENUM(NSInteger, ILRoundedViewType) {
    ILRoundedViewTypeNone = 0,
    ILRoundedViewTypeLeft,
    ILRoundedViewTypeRight,
    ILRoundedViewTypeTop,
    ILRoundedViewTypeBottom
};

@interface ILRoundedView : UIView

@property (nonatomic) IBInspectable NSInteger integerType;
@property (nonatomic) ILRoundedViewType type;

@property (nonatomic) IBInspectable CGFloat radius;

@end
