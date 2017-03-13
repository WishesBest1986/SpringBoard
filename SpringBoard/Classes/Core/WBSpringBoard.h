//
//  WBSpringBoard.h
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import <UIKit/UIKit.h>

@class WBSpringBoard;
@class WBSpringBoardLayout;
@class WBSpringBoardCell;

@protocol WBSpringBoardDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInSpringBoard:(WBSpringBoard *)springBoard;
- (__kindof WBSpringBoardCell *)springBoard:(WBSpringBoard *)springBoard cellForItemAtIndex:(NSInteger)index;

- (NSInteger)springBoard:(WBSpringBoard *)springBoard numberOfSubItemsAtIndex:(NSInteger)index;
- (__kindof WBSpringBoardCell *)springBoard:(WBSpringBoard *)springBoard subCellForItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex;

@optional
- (BOOL)springBoard:(WBSpringBoard *)springBoard canMoveItemAtIndex:(NSInteger)index;
- (void)springBoard:(WBSpringBoard *)springBoard moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)springBoard:(WBSpringBoard *)springBoard combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

- (void)springBoard:(WBSpringBoard *)springBoard moveSubItemAtIndex:(NSInteger)sourceIndex toSubIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex;
- (void)springBoard:(WBSpringBoard *)springBoard moveSubItemAtIndex:(NSInteger)sourceIndex toSuperIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex;

@end

@protocol WBSpringBoardDelegate <NSObject>

@optional

@end

@interface WBSpringBoard : UIView

@property (nonatomic, weak) id<WBSpringBoardDelegate> delegate;
@property (nonatomic, weak) id<WBSpringBoardDataSource> dataSource;

@property (nonatomic, strong) WBSpringBoardLayout *layout;
@property (nonatomic, strong) WBSpringBoardLayout *popupLayout;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL allowCombination;
@property (nonatomic, assign) BOOL allowOverlapCombination;

- (void)reloadData;

@end
