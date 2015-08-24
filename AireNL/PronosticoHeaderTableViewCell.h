//
//  PronosticoHeaderTableViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 7/28/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultsCellDelegate.h"

@protocol PronosticoHeaderDelegate <NSObject>

- (void)didSelectInfo;

@end

@interface PronosticoHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PronosticoHeaderDelegate> delegate;

- (IBAction)didSelectInfo:(id)sender;

@end
