//
//  PronosticoTableViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 7/28/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PredictionResults.h"

@protocol PronosticoCellDelegate <NSObject>

- (PredictionResults *)getPredictionResults;
   
@end

@interface PronosticoTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PronosticoCellDelegate> delegate;

@property (nonatomic) NSNumber *row;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@end
