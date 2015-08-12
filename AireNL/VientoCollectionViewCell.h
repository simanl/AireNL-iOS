//
//  VientoCollectionViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultsCellDelegate.h"

@interface VientoCollectionViewCell : UICollectionViewCell <ResultsDelegateSettable>

@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@property (weak, nonatomic) IBOutlet UIView *innerContentView;

@end
