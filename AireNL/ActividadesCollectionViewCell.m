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

@interface ActividadesCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *activityIcons;
@property (nonatomic) NSArray *iconExplanations;

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
    
    UIColor *color;
    if ([measurement.imecaPoints integerValue] > 140) {
        color = [UIColor il_veryBadColor];
    }else{
        color = [UIColor il_goodColor];
    }
    self.statusView.backgroundColor = color;
    
    [self.innerCollectionView reloadData];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.activityIcons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InnerActividadesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"IconoActividadCell" forIndexPath: indexPath];
    cell.activityImageView.image = [UIImage imageNamed: self.activityIcons[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector: @selector(actividadesDidSelectInfoWithText:)]){
        [self.delegate actividadesDidSelectInfoWithText: self.iconExplanations[indexPath.row]];
    }
}

#pragma mark - Set/Get

- (NSArray *)activityIcons
{
    if (!_activityIcons) {
        _activityIcons = @[@"OutdoorsActivityIcon",
                           @"WindowActivityIcon",
                           @"AllergyActivityIcon",
                           @"ExerciseActivityIcon",
                           @"CarActivityIcon"];
    }
    return _activityIcons;
}

- (NSArray *)iconExplanations
{
    if (!_iconExplanations) {
        _iconExplanations = @[NSLocalizedString(@"ACTIVITY_OUTDOORS", nil),
                              NSLocalizedString(@"ACTIVITY_WINDOWS", nil),
                              NSLocalizedString(@"ACTIVITY_ALLERGIES", nil),
                              NSLocalizedString(@"ACTIVITY_EXERCISE", nil),
                              NSLocalizedString(@"ACTIVITY_CAR", nil)];
    }
    return _iconExplanations;
}

@end
