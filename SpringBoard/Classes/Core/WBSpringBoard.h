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

@optional
- (BOOL)springBoard:(WBSpringBoard *)springBoard canMoveItemAtIndex:(NSInteger)index;
- (void)springBoard:(WBSpringBoard *)springBoard moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)springBoard:(WBSpringBoard *)springBoard combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

@end

@protocol WBSpringBoardDelegate <NSObject>

@optional

@end

@interface WBSpringBoard : UIControl

@property (nonatomic, weak) id<WBSpringBoardDelegate> delegate;
@property (nonatomic, weak) id<WBSpringBoardDataSource> dataSource;

@property (nonatomic, strong) WBSpringBoardLayout *layout;

@property (nonatomic, assign) BOOL isEdit;

- (void)reloadData;

@end
