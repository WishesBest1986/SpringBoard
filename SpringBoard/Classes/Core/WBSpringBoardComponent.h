//
//  WBSpringBoardComponent.h
//  Pods
//
//  Created by LIJUN on 2017/3/10.
//
//

#import <UIKit/UIKit.h>

@class WBSpringBoardComponent;
@class WBSpringBoardLayout;
@class WBSpringBoardCell;

@protocol WBSpringBoardComponentDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInSpringBoardComponent:(WBSpringBoardComponent *)springBoardComponent;
- (__kindof WBSpringBoardCell *)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent cellForItemAtIndex:(NSInteger)index;

@optional
- (BOOL)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent canMoveItemAtIndex:(NSInteger)index;
- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

@end

@protocol WBSpringBoardComponentDelegate <NSObject>

@optional

@end

@interface WBSpringBoardComponent : UIControl

@property (nonatomic, weak) id<WBSpringBoardComponentDelegate> delegate;
@property (nonatomic, weak) id<WBSpringBoardComponentDataSource> dataSource;

@property (nonatomic, strong) WBSpringBoardLayout *layout;

@property (nonatomic, strong) WBSpringBoardComponent *outterSpringBoardComponent;

@property (nonatomic, assign) BOOL isEdit;

- (void)reloadData;

@end
