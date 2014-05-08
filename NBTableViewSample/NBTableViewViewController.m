//
//  NBTableViewViewController.m
//  NBTableViewSample
//
//  Created by BruceZCQ on 5/7/14.
//  Copyright (c) 2014 OpeningO,Inc. All rights reserved.
//

#import "NBTableViewViewController.h"
#import "NBTableView.h"

@interface NBTableViewViewController ()<NBTableViewDataSource>

@end

@implementation NBTableViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _row = 4;
    _cellHeight = 44;
    CGRect frame = self.view.frame;
    frame.origin.y += 10;
    NBTableView *tableview = [[NBTableView alloc] initWithFrame:frame style:NBTableViewStylePlain];
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    [tableview release];
}


- (NSInteger)numberOfSectionsInNBTableView:(NBTableView *)tableView
{
    return 2;
}

- (NSInteger)nbTableViewNumberOfRowsInSection:(NSInteger)section
{
    return _row;
}

- (UITableViewCell*)nbTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"No.%d row in section %d",indexPath.row,indexPath.section];
    
    return [cell autorelease];
}

- (CGFloat)nbTableViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (NSString *)nbTableViewTitleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"No.%d Section HeaderTitle",section];
}

- (NSString *)nbTableViewTitleForFooterInSection:(NSInteger)section
{
    
    return [NSString stringWithFormat:@"No.%d Section FooterTitle",section];
}


- (CGFloat)nbTableViewTitleHeightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)nbTableViewTitleHeightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)nbTableViewHeightInSection:(NSInteger)section
{
    return _cellHeight*_row;
}

- (BOOL)nbTableViewBouncesInSection:(NSInteger)section
{

    return NO;
}


@end
