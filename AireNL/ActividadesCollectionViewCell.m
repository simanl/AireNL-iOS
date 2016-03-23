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

@interface ActividadesCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

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
    
    self.activities = [ActivityFactory activitiesForAirqualityDescriptor: [measurement airQuality]];

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
    if ([self.delegate respondsToSelector: @selector(didSelectInfoWithText:)]){
        Activity *activity = self.activities[indexPath.row];
        [self.delegate didSelectInfoWithText: [activity description]];
    }
}

#pragma mark - UICollectionView Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger items = self.activities.count;
    NSInteger itemWidth = 49;
    CGFloat totalItemsWidth = itemWidth * items;

    NSInteger margin = 10;
    CGFloat totalMarginsWidth = margin * (items + 1);
    
    CGFloat collectionWidth = CGRectGetWidth(collectionView.bounds);
    
    if (totalItemsWidth < collectionWidth) {
        CGFloat newWidth = (collectionWidth - totalMarginsWidth) / items;
        return CGSizeMake(newWidth, 58);
    }else{
        return CGSizeMake(49, 58);
    }
    
}

@end
