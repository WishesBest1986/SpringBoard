//
//  WBSpringBoardInnerView.m
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import "WBSpringBoardInnerView.h"
#import "WBSpringBoardComponent_Private.h"

@interface WBSpringBoardInnerView ( )

@property (nonatomic, assign) BOOL isDragOutsideMode;

@end

@implementation WBSpringBoardInnerView

#pragma mark - Override Method

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateMove:(UILongPressGestureRecognizer *)gesture
{
    @WBWeakObj(self);
    CGPoint pointAtWindow = [gesture locationInView:kAppKeyWindow];
    CGPoint currentOrigin = CGPointMake(pointAtWindow.x - self.lastPoint.x, pointAtWindow.y - self.lastPoint.y);
    
    if (self.isDrag) {
        CGRect dragViewFrame = self.dragView.frame;
        dragViewFrame.origin = currentOrigin;
        self.dragView.frame = dragViewFrame;
        
        if (_isDragOutsideMode) {
            if (_springBoardInnerViewOutsideGestureDelegate && [_springBoardInnerViewOutsideGestureDelegate respondsToSelector:@selector(springBoardInnerView:outsideGestureMove:fromCell:)]) {
                [_springBoardInnerViewOutsideGestureDelegate springBoardInnerView:weakself outsideGestureMove:gesture fromCell:cell];
            }
            
            return;
        }
        
        CGPoint scrollPoint = [gesture locationInView:self.scrollView];
        if (!CGRectContainsPoint(CGRectApplyAffineTransform(self.scrollView.bounds, CGAffineTransformMakeScale(1.2, 1.2)), scrollPoint)) {
            self.isDragOutsideMode = YES;
            
            [_popupView hideWithAnimated:YES removeFromSuperView:NO];
            if (_springBoardInnerViewOutsideGestureDelegate && [_springBoardInnerViewOutsideGestureDelegate respondsToSelector:@selector(springBoardInnerView:outsideGestureBegin:fromCell:)]) {
                [_springBoardInnerViewOutsideGestureDelegate springBoardInnerView:weakself outsideGestureBegin:gesture fromCell:cell];
            }
            
            return;
        }
    }
    
    [super springBoardCell:cell longGestureStateMove:gesture];
}

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateEnd:(UILongPressGestureRecognizer *)gesture
{
    @WBWeakObj(self);
    if (self.isDrag && _isDragOutsideMode) {
        if (_springBoardInnerViewOutsideGestureDelegate && [_springBoardInnerViewOutsideGestureDelegate respondsToSelector:@selector(springBoardInnerView:outsideGestureEnd:fromCell:)]) {
            [_springBoardInnerViewOutsideGestureDelegate springBoardInnerView:weakself outsideGestureEnd:gesture fromCell:cell];
        }
        
        [_popupView removeFromSuperview];
    
        self.isDragOutsideMode = NO;
    }
    
    [super springBoardCell:cell longGestureStateEnd:gesture];
}

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateCancel:(UILongPressGestureRecognizer *)gesture
{
    @WBWeakObj(self);
    if (self.isDrag && _isDragOutsideMode) {
        if (_springBoardInnerViewOutsideGestureDelegate && [_springBoardInnerViewOutsideGestureDelegate respondsToSelector:@selector(springBoardInnerView:outsideGestureCancel:fromCell:)]) {
            [_springBoardInnerViewOutsideGestureDelegate springBoardInnerView:weakself outsideGestureCancel:gesture fromCell:cell];
        }
        
        [_popupView removeFromSuperview];
        
        self.isDragOutsideMode = NO;
    }
    
    [super springBoardCell:cell longGestureStateCancel:gesture];
}

@end
