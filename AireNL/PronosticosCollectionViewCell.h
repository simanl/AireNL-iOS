//
//  PronosticosCollectionViewCell.h
//  AireNL
//
//  Created by Daniel Lozano on 7/28/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultsCellDelegate.h"

@interface PronosticosCollectionViewCell : UICollectionViewCell <ResultsDelegateSettable, ResultsCellUpdateable>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
