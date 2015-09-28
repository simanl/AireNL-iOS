//
//  ImecaCollectionViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultsCellDelegate.h"

@interface ImecaCollectionViewCell : UICollectionViewCell <ResultsDelegateSettable, ResultsCellUpdateable>

@property (weak, nonatomic) IBOutlet UILabel *imecaLabel;
@property (weak, nonatomic) IBOutlet UILabel *imecaQualityLabel;
@property (weak, nonatomic) IBOutlet UIView *imecaQualityView;

@property (weak, nonatomic) IBOutlet UILabel *measurementDateLabel;

- (IBAction)didSelectInfo:(id)sender;

@end
