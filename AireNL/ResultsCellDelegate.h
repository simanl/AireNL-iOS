//
//  ResultsCellDelegate.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Station.h"
#import "Measurement.h"

#import "PredictionResults.h"

@protocol ResultsCellDelegate <NSObject>

- (Station *)getSelectedStation;
- (Measurement *)getSelectedMeasurement;
- (PredictionResults *)getPredictionResults;

- (void)didSelectInfoAtCell:(UICollectionViewCell *)cell;
- (void)actividadesDidSelectInfoWithText:(NSString *)text;

@end

@protocol ResultsDelegateSettable <NSObject>

@property (weak, nonatomic) id<ResultsCellDelegate> delegate;

@end

@protocol ResultsCellUpdateable <NSObject>

- (void)updateCell;

@end