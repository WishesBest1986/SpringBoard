//
//  WBSpringBoardCombination.h
//  Pods
//
//  Created by LIJUN on 2017/3/13.
//
//

#import <UIKit/UIKit.h>

@class WBSpringBoardCombination;
@class WBSpringBoardLayout;
@class WBSpringBoardCell;

@protocol WBSpringBoardCombinationDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInSpringBoardCombination:(WBSpringBoardCombination *)springBoardCombination;
- (__kindof WBSpringBoardCell *)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination  cellForItemAtIndex:(NSInteger)index;

@optional
- (BOOL)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination canMoveItemAtIndex:(NSInteger)index;
- (void)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

@end

@protocol WBSpringBoardCombinationDelegate <NSObject>

@optional

@end

@protocol WBSpringBoardCombinationOutsideGestureDelegate <NSObject>

- (void)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination outsideGestureBegin:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;
- (void)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination outsideGestureMove:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;
- (void)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination outsideGestureEnd:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;
- (void)springBoardCombination:(WBSpringBoardCombination *)springBoardCombination outsideGestureCancel:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;

@end

@interface WBSpringBoardCombination : UIView

@property (nonatomic, weak) id<WBSpringBoardCombinationDelegate> delegate;
@property (nonatomic, weak) id<WBSpringBoardCombinationDataSource> dataSource;
@property (nonatomic, weak) id<WBSpringBoardCombinationOutsideGestureDelegate> outsideGestureDelegate;

@property (nonatomic, strong) WBSpringBoardLayout *layout;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL allowCombination;
@property (nonatomic, assign) BOOL allowOverlapCombination;

@property (nonatomic, assign) NSInteger superIndex;
@property (nonatomic, weak) UIView *popupView;

- (void)reloadData;
- (NSInteger)indexForCell:(WBSpringBoardCell *)cell;

@end
