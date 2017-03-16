//
//  WBSpringBoardView.h
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import "WBSpringBoardComponent.h"

@class WBSpringBoardView;
@class WBSpringBoardLayout;
@class WBSpringBoardCell;
@class WBSpringBoardCombinedCell;

@protocol WBSpringBoardViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInSpringBoardView:(WBSpringBoardView *)springBoardView;
- (__kindof WBSpringBoardCell *)springBoardView:(WBSpringBoardView *)springBoardView cellForItemAtIndex:(NSInteger)index;

@optional
- (BOOL)springBoardView:(WBSpringBoardView *)springBoardView canMoveItemAtIndex:(NSInteger)index;
- (void)springBoardView:(WBSpringBoardView *)springBoardView moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)springBoardView:(WBSpringBoardView *)springBoardView combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

- (NSInteger)springBoardView:(WBSpringBoardView *)springBoardView numberOfSubItemsAtIndex:(NSInteger)index;
- (__kindof WBSpringBoardCell *)springBoardView:(WBSpringBoardView *)springBoard subCellForItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex;

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveSubItemAtIndex:(NSInteger)sourceIndex toSubIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex;
- (void)springBoardView:(WBSpringBoardView *)springBoardView moveSubItemAtIndex:(NSInteger)sourceIndex toSuperIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex;
- (void)springBoardView:(WBSpringBoardView *)springBoardView removeItemAtIndex:(NSInteger)index;

- (void)springBoardView:(WBSpringBoardView *)springBoardView combinedCell:(__kindof WBSpringBoardCombinedCell *)combinedCell changeTitleFrom:(NSString *)originTitle to:(NSString *)currentTitle;
- (void)springBoardView:(WBSpringBoardView *)springBoardView needRefreshCombinedCell:(__kindof WBSpringBoardCombinedCell *)combinedCell;

@end

@protocol WBSpringBoardViewDelegate <NSObject>

@optional
- (void)springBoardView:(WBSpringBoardView *)springBoardView clickItemAtIndex:(NSInteger)index;

- (void)springBoardView:(WBSpringBoardView *)springBoardView clickSubItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex;

@end

@interface WBSpringBoardView : WBSpringBoardComponent

@property (nonatomic, weak) id<WBSpringBoardViewDelegate> springBoardDelegate;
@property (nonatomic, weak) id<WBSpringBoardViewDataSource> springBoardDataSource;

@property (nonatomic, strong) WBSpringBoardLayout *innerViewLayout;

@property (nonatomic, assign) BOOL allowSingleItemCombinedCell; // default YES

@end
