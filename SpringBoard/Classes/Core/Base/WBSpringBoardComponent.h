//
//  WBSpringBoardComponent.h
//  Pods
//
//  Created by LIJUN on 2017/3/13.
//
//

#import <UIKit/UIKit.h>

@class WBSpringBoardLayout;
@class WBSpringBoardCell;

@interface WBSpringBoardComponent : UIView

@property (nonatomic, strong) WBSpringBoardLayout *layout;

@property (nonatomic, assign) BOOL allowCombination;
@property (nonatomic, assign) BOOL allowOverlapCombination;

@property (nonatomic, assign) BOOL isEdit;

- (NSInteger)indexForCell:(WBSpringBoardCell *)cell;
- (void)reloadData;

@end
