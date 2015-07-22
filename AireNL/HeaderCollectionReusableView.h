//
//  HeaderCollectionReusableView.h
//  AireNL
//
//  Created by Daniel Lozano on 7/22/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderCollectionReusableViewDelegate <NSObject>

- (void)userDidSelectMap;

@end

@interface HeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) id<HeaderCollectionReusableViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;

- (IBAction)userDidSelectMap:(id)sender;

@end
