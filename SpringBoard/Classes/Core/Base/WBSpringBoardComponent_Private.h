//
//  WBSpringBoardComponent_Private.h
//  Pods
//
//  Created by LIJUN on 2017/3/13.
//
//

#import "WBSpringBoardComponent.h"
#import "WBSpringBoardDefines.h"
#import "WBSpringBoardLayout.h"
#import "WBSpringBoardCell.h"
#import "WBSpringBoardCombinedCell.h"
#import "WBIndexRect.h"
#import <Masonry/Masonry.h>

@protocol WBSpringBoardComponentDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInSpringBoardComponent:(WBSpringBoardComponent *)springBoardComponent;
- (__kindof WBSpringBoardCell *)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent cellForItemAtIndex:(NSInteger)index;

@optional
- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

@end

@protocol WBSpringBoardComponentDelegate <NSObject>

@optional
- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent clickItemAtIndex:(NSInteger)index;

@end

@interface WBSpringBoardComponent () <UIScrollViewDelegate, WBSpringBoardCellDelegate, WBSpringBoardCellLongGestureDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *dragView;

@property (nonatomic, assign) NSInteger numberOfItems;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger colsPerPage;
@property (nonatomic, assign) NSInteger rowsPerPage;

@property (nonatomic, strong) NSMutableArray *frameContainerArray;
@property (nonatomic, strong) NSMutableArray *contentIndexRectArray;
@property (nonatomic, strong) NSMutableArray *contentCellArray;

@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, assign) NSInteger dragFromIndex;
@property (nonatomic, weak) WBSpringBoardCell *dragTargetCell;

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGPoint previousMovePointAtWindow;
@property (nonatomic, assign) CGPoint currentMovePointAtScrollView;

@property (nonatomic, strong) dispatch_source_t flipDetectTimer;

@property (nonatomic, weak) id<WBSpringBoardComponentDelegate> springBoardComponentDelegate;
@property (nonatomic, weak) id<WBSpringBoardComponentDataSource> springBoardComponentDataSource;

- (void)commonInit;
- (void)sortContentCellsWithAnimated:(BOOL)animated;
- (void)recomputePageAndSortContentCellsWithAnimated:(BOOL)animated;

@end
