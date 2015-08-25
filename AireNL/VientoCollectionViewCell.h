//
//  VientoCollectionViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultsCellDelegate.h"

@interface VientoCollectionViewCell : UICollectionViewCell <ResultsDelegateSettable, ResultsCellUpdateable>

@property (weak, nonatomic) IBOutlet UIView *innerContentView;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@end
