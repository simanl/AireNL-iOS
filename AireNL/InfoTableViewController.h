//
//  InfoTableViewController.h
//  AireNL
//
//  Created by Daniel Lozano on 8/25/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InfoContainerViewController.h"

@interface InfoTableViewController : UITableViewController

@property (nonatomic) NSString *infoText;

@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;

@end