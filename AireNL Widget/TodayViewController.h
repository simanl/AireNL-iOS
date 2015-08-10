//
//  TodayViewController.h
//  AireNL Widget
//
//  Created by Daniel Lozano on 8/5/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationSubtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *imecaLabel;
@property (weak, nonatomic) IBOutlet UILabel *imecaQualityLabel;

@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end
