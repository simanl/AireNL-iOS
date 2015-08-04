//
//  ContaminantesCollectionViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 8/3/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContaminantesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *contaminante10TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contaminante25TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contaminante03TitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contaminante10Label;
@property (weak, nonatomic) IBOutlet UILabel *contaminante25Label;
@property (weak, nonatomic) IBOutlet UILabel *contaminante03Label;


@end
