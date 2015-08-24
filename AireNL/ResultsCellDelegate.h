//
//  ResultsCellDelegate.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CurrentResults.h"
#import "PredictionResults.h"

@protocol ResultsCellDelegate <NSObject>

- (CurrentResults *)getCurrentResults;
- (PredictionResults *)getPredictionResults;

- (void)didSelectInfoAtCell:(UICollectionViewCell *)cell;

@end

@protocol ResultsDelegateSettable <NSObject>

@property (weak, nonatomic) id<ResultsCellDelegate> delegate;

@end