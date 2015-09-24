//
//  ActividadesCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ActividadesCollectionViewCell.h"

@interface ActividadesCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) BOOL goodAirQuality;

@property (nonatomic) NSArray *positiveIcons;
@property (nonatomic) NSArray *negativeIcons;

@property (nonatomic) NSArray *iconExplanations;

@end

@implementation ActividadesCollectionViewCell

@synthesize delegate;

- (void)awakeFromNib
{
    self.goodAirQuality = NO;
    
    self.innerCollectionView.dataSource = self;
    self.innerCollectionView.delegate = self;
}

- (void)updateCell
{
    [self.innerCollectionView reloadData];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.goodAirQuality) {
        return [self.positiveIcons count];
    }else{
        return [self.negativeIcons count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"IconoActividadCell" forIndexPath: indexPath];
    
    if (self.goodAirQuality) {
        cell.backgroundColor = [UIColor greenColor];
    }else{
        cell.backgroundColor = [UIColor redColor];
    }
    
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

- (NSArray *)positiveIcons
{
    if (!_positiveIcons) {
        _positiveIcons = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    }
    return _positiveIcons;
}

- (NSArray *)negativeIcons
{
    if (!_negativeIcons) {
        _negativeIcons = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    }
    return _negativeIcons;
}

- (NSArray *)iconExplanations
{
    if (!_iconExplanations) {
        _iconExplanations = @[@"Explicacion1", @"Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2Explicacion2", @"Explicacion3", @"Explicacion4", @"Explicacion5", @"Explicacion6", @"Explicacion7", @"Explicacion8", @"Explicacion9"];
    }
    return _iconExplanations;
}

@end
