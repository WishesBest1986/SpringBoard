//
//  WBSpringBoardInnerView.h
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import "WBSpringBoardComponent.h"
#import "WBSpringBoardPopupView.h"

@class WBSpringBoardInnerView;

@protocol WBSpringBoardInnerViewOutsideGestureDelegate <NSObject>

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureBegin:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;
- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureMove:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;
- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureEnd:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;
- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureCancel:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell;

@end

@interface WBSpringBoardInnerView : WBSpringBoardComponent

@property (nonatomic, assign) NSInteger superIndex;
@property (nonatomic, weak) id<WBSpringBoardInnerViewOutsideGestureDelegate> springBoardInnerViewOutsideGestureDelegate;
@property (nonatomic, weak) WBSpringBoardPopupView *popupView;

@end
