//
//  MainPageViewController.h
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainPageViewController;

@protocol MainContainerChild <NSObject>

@property (nonatomic) NSUInteger index;
@property (nonatomic) MainPageViewController *parentVC;

@end

@interface MainPageViewController : UIPageViewController

@end
