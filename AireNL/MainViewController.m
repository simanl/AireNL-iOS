//
//  MainViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainViewController.h"

#import "UIColor+ILColor.h"
#import "ILGradientLayer.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *cellIdentifiers;

@end

@implementation MainViewController

@synthesize index;
@synthesize parentVC;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.index = 0;
    
    [self drawBackground];
    [self customizeAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0);
}

- (void)drawBackground
{
    UIImage *backgroundImage = [UIImage imageNamed: @"BackgroundIMG"];
    CALayer *aLayer = [CALayer layer];
    
    aLayer.contents = (id)backgroundImage.CGImage;
    aLayer.frame = self.view.bounds;
    
    [self.view.layer insertSublayer: aLayer atIndex: 0];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cellIdentifiers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.cellIdentifiers[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellIdentifier forIndexPath: indexPath];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                                                                             withReuseIdentifier: @"headerView"
                                                                                    forIndexPath: indexPath];
    return headerView;
}

#pragma mark - UICollectionView DelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, [self getCenterPoint]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [((NSNumber *)self.cellHeights[indexPath.row]) floatValue];
    CGFloat width;
    if (indexPath.row == 3 || indexPath.row == 4) {
        width = CGRectGetWidth(self.collectionView.bounds) / 2;
    }else{
        width = CGRectGetWidth(self.collectionView.bounds);
    }
    
    return CGSizeMake(width, height);
}

#pragma mark - Getters

- (NSArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = @[@(160), @(80), @(80), @(80), @(80)];
    }
    return _cellHeights;
}

- (NSArray *)cellIdentifiers
{
    if (!_cellIdentifiers) {
        _cellIdentifiers = @[@"imecaCell", @"actividadesCell", @"contaminantesCell", @"vientoCell", @"temperaturaCell"];
    }
    return _cellIdentifiers;
}

#pragma mark - Helper's

- (CGFloat)getCenterPoint
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    return CGRectGetMidY(self.collectionView.bounds);
}

@end
