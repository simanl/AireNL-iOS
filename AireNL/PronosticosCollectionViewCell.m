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

@interface PronosticosCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *contaminantNames;

@end

@implementation PronosticosCollectionViewCell

- (void)awakeFromNib
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName: @"PronosticoTableViewCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib: cellNib forCellReuseIdentifier: @"pronosticoTableViewCell"];
    
    UINib *headerCellNib = [UINib nibWithNibName: @"PronosticoHeaderTableViewCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib: headerCellNib forCellReuseIdentifier: @"pronosticoHeaderTableViewCell"];
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
        return headerCell;
    }
    PronosticoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"pronosticoTableViewCell" forIndexPath: indexPath];
    cell.typeLabel.text = self.contaminantNames[indexPath.row - 1];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    }
    return 50.0f;
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
