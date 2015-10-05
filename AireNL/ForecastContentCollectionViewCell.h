//
//  ForecastContentCollectionViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 10/5/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Forecast.h"
#import "ResultsCellDelegate.h"
#import "ILRoundedView.h"

@interface ForecastContentCollectionViewCell : UICollectionViewCell <ResultsCellUpdateable>

@property (nonatomic) Forecast *forecast;
- (void)updateCell;

@property (weak, nonatomic) IBOutlet ILRoundedView *roundedContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *pm10Label;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UILabel *O3Label;


@end
