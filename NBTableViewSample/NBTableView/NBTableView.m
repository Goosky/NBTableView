//
//  NBTableView.m
//  NBTableViewSample
//
//  Created by BruceZCQ on 5/7/14.
//  Copyright (c) 2014 OpeningO,Inc. All rights reserved.
//

#import "NBTableView.h"

@interface NBTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NBTableView

- (id)initWithFrame:(CGRect)frame style:(NBTableViewStyle)style
{
    if (self = [super initWithFrame:frame]) {
        _sectionCnt = 1;
        _style = style;
        _subTableViews = [NSMutableArray array];
        [_subTableViews retain];
        _subTableViewHeaders = [NSMutableArray array];
        [_subTableViewHeaders retain];
        _subTableViewFooters = [NSMutableArray array];
        [_subTableViewFooters retain];
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height+0.5);
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)setDataSource:(id<NBTableViewDataSource>)dataSource
{
    dataSource_ = dataSource;
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(numberOfSectionsInNBTableView:)]) {
        _sectionCnt = [dataSource_ numberOfSectionsInNBTableView:self];
    }
    
    for (NSInteger i = 0; i < _sectionCnt; i++) {
        //add tableview
        UITableView *subTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        subTableView.delegate = self;
        subTableView.dataSource = self;
        subTableView.scrollEnabled = subTableView.bounces = subTableView.showsHorizontalScrollIndicator = subTableView.showsVerticalScrollIndicator = NO;
        [_subTableViews addObject:subTableView];
        [subTableView release];
        //add header views
        UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_subTableViewHeaders addObject:headerTitle];
        [headerTitle release];
        //add  footer views
        UILabel *footerTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_subTableViewFooters addObject:footerTitle];
        [footerTitle release];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    CGFloat startY = frame.origin.y;
    for (NSInteger i = 0; i < _sectionCnt; i++) {
        
        if (i > 0 && i < _sectionCnt) {
            frame = ((UITableView *)[_subTableViews objectAtIndex:i-1]).frame;
            frame.origin.y = frame.size.height;
        }
        
        float heightOffset = 0.0;
        
        if ([self headerTitleInSection:i] != nil && dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewTitleHeightForHeaderInSection:)]) {
            heightOffset += [dataSource_ nbTableViewTitleHeightForHeaderInSection:i];
        }
        
        if ([self footerTitleInSection:i] != nil && dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewTitleHeightForFooterInSection:)]) {
            heightOffset += [dataSource_ nbTableViewTitleHeightForFooterInSection:i];
        }
        
        CGFloat subViewHeight = [self nbTableHeightForSection:i];
        UITableView *subView = [_subTableViews objectAtIndex:i];
        frame.size.height = subViewHeight + heightOffset + startY;
        subView.frame = frame;
        [self addSubview:subView];
    }
    
    UITableView *lastView = [_subTableViews objectAtIndex:_sectionCnt-1];
    CGFloat contentSizeHeight = lastView.frame.origin.y + lastView.frame.size.height;
    if (contentSizeHeight < self.frame.size.height) {
        contentSizeHeight = self.frame.size.height;
    }
    self.contentSize = CGSizeMake(self.frame.size.width, contentSizeHeight+0.5);
}



#pragma mark - Common

- (CGFloat)nbTableHeightForSection:(NSInteger)section
{
    CGFloat height = 0.0;
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewHeightInSection:)]) {
        height = [dataSource_ nbTableViewHeightInSection:section];
    }
    return height;
}

- (NSString *)headerTitleInSection:(NSInteger)section
{
    NSString *title = nil;
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewTitleForHeaderInSection:)]) {
        title = [dataSource_ nbTableViewTitleForHeaderInSection:section];
    }
    return title;
}

- (NSString *)footerTitleInSection:(NSInteger)section
{
    NSString *title = nil;
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewTitleForFooterInSection:)]) {
        title = [dataSource_ nbTableViewTitleForFooterInSection:section];
    }
    return title;
}

- (UIView *)clearHeaderSectionViewInSection:(NSInteger)section
{
    UILabel *clearView = [[UILabel alloc] init];
    clearView.font = [UIFont systemFontOfSize:14];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.text = [self headerTitleInSection:section];
    return [clearView autorelease];
}

- (UIView *)clearFooterSectionViewInSection:(NSInteger)section
{
    UILabel *clearView = [[UILabel alloc] init];
    clearView.font = [UIFont systemFontOfSize:14];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.text = [self footerTitleInSection:section];
    return [clearView autorelease];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewNumberOfRowsInSection:)]) {
        rows =  [dataSource_ nbTableViewNumberOfRowsInSection:section];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger section = [_subTableViews indexOfObject:tableView];
    NSIndexPath *indexPath_ = [NSIndexPath indexPathForRow:indexPath.row inSection:section];
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableView:cellForRowAtIndexPath:)]) {
        cell = [dataSource_ nbTableView:tableView cellForRowAtIndexPath:indexPath_];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0;
    if (dataSource_ && [dataSource_ respondsToSelector:@selector(nbTableViewHeightForRowAtIndexPath:)]) {
        height = [dataSource_ nbTableViewHeightForRowAtIndexPath:indexPath];
    }
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger section_ = [_subTableViews indexOfObject:tableView];
    return [self headerTitleInSection:section_];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSInteger section_ = [_subTableViews indexOfObject:tableView];
    return [self footerTitleInSection:section_];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self clearFooterSectionViewInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self clearHeaderSectionViewInSection:section];
}
@end
