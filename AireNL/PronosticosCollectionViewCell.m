//
//  PronosticosCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 7/28/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "PronosticosCollectionViewCell.h"

#import "PronosticoTableViewCell.h"
#import "PronosticoHeaderTableViewCell.h"

@interface PronosticosCollectionViewCell () <UITableViewDelegate, UITableViewDataSource, PronosticoCellDelegate, PronosticoHeaderDelegate>

@property (nonatomic) NSArray *contaminantNames;

@end

@implementation PronosticosCollectionViewCell

@synthesize delegate;

- (void)awakeFromNib
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *headerCellNib = [UINib nibWithNibName: @"PronosticoHeaderTableViewCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib: headerCellNib forCellReuseIdentifier: @"pronosticoHeaderTableViewCell"];
    
    UINib *cellNib = [UINib nibWithNibName: @"PronosticoTableViewCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib: cellNib forCellReuseIdentifier: @"pronosticoTableViewCell"];
    
    [self.tableView reloadData];
}

- (void)updateCell
{
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PronosticoHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier: @"pronosticoHeaderTableViewCell"
                                                                                    forIndexPath: indexPath];
        headerCell.delegate = self;
        return headerCell;
    }
    PronosticoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"pronosticoTableViewCell" forIndexPath: indexPath];
    cell.typeLabel.text = self.contaminantNames[indexPath.row - 1];
    cell.row = @(indexPath.row - 1);
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    }
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor: [UIColor clearColor]];
}

#pragma mark - PronosticoCell Delegate

- (PredictionResults *)getPredictionResults
{
    return [self.delegate getPredictionResults];
}

#pragma mark - PronosticoHeaderCell Delegate

- (void)didSelectInfo
{
    if ([self.delegate respondsToSelector: @selector(didSelectInfoAtCell:)]) {
        [self.delegate didSelectInfoAtCell: self];
    }
}

#pragma mark - Set/Get

- (NSArray *)contaminantNames
{
    if (!_contaminantNames) {
        _contaminantNames = @[@"PM 10", @"PM 2.5", @"O3"];
    }
    return _contaminantNames;
}

@end
