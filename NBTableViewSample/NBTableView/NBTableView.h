//
//  NSTableView.h
//  NBTableViewSample
//
//  Created by BruceZCQ on 5/7/14.
//  Copyright (c) 2014 OpeningO,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, NBTableViewStyle) {
    NBTableViewStylePlain,                  // regular table view
    NBTableViewStyleGrouped                 // preferences style table view
};

@protocol NBTableViewDataSource;

@interface NBTableView : UIScrollView
{
    NSUInteger _sectionCnt; //section cnt
    NBTableViewStyle _style;
    id <NBTableViewDataSource> dataSource_;
    NSMutableArray *_subTableViews;
    NSMutableArray *_subTableViewHeaders;
    NSMutableArray *_subTableViewFooters;
}

@property (nonatomic, assign) id <NBTableViewDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame style:(NBTableViewStyle)style;

@end


@protocol NBTableViewDataSource <NSObject>

@optional
- (NSInteger)numberOfSectionsInNBTableView:(NBTableView *)tableView;// section count
- (CGFloat)nbTableViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)nbTableViewTitleForHeaderInSection:(NSInteger)section; // header title
- (NSString *)nbTableViewTitleForFooterInSection:(NSInteger)section;    // footer title
- (CGFloat)nbTableViewTitleHeightForHeaderInSection:(NSInteger)section; // header title height
- (CGFloat)nbTableViewTitleHeightForFooterInSection:(NSInteger)section; // footer title height
- (CGFloat)nbTableViewHeightInSection:(NSInteger)section; // subtableview height
- (BOOL)nbTableViewBouncesInSection:(NSInteger)section; // bounces

@required
- (NSInteger)nbTableViewNumberOfRowsInSection:(NSInteger)section; // rows in secion
- (UITableViewCell *)nbTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end