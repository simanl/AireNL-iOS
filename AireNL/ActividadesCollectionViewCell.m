//
//  ActividadesCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ActividadesCollectionViewCell.h"

#import "UIColor+ILColor.h"
#import "InnerActividadesCollectionViewCell.h"

#import "ActivityFactory.h"

@interface ActividadesCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *activities;

@end

@implementation ActividadesCollectionViewCell

@synthesize delegate;

- (void)awakeFromNib
{    
    self.innerCollectionView.dataSource = self;
    self.innerCollectionView.delegate = self;
}

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    
    self.statusView.backgroundColor = [measurement colorForAirQuality];
    self.activities = [ActivityFactory activitiesForAirqualityDescriptor: AirQualityDescriptorExtremelyBad];

    [self.innerCollectionView reloadData];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InnerActividadesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"IconoActividadCell"
                                                                                         forIndexPath: indexPath];
    
    Activity *activity = self.activities[indexPath.row];
    cell.activityImageView.image = [activity image];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector: @selector(actividadesDidSelectInfoWithText:)]){
        Activity *activity = self.activities[indexPath.row];
        [self.delegate actividadesDidSelectInfoWithText: [activity description]];
    }
}

@end
