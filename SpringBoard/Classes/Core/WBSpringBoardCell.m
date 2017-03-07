//
//  WBSpringBoardCell.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "WBSpringBoardCell.h"
#import "WBSpringBoardDefines.h"

@implementation WBSpringBoardCell

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
        [self addGestureRecognizer:longGesture];
    }
    return self;
}

#pragma mark - Setter & Getter

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    [self.layer removeAnimationForKey:@"rocking"];
    if (isEdit) {
        CAKeyframeAnimation *rockAnimation = [CAKeyframeAnimation animation];
        rockAnimation.keyPath = @"transform.rotation";
        rockAnimation.values = @[@(AngleToRadian(-3)),@(AngleToRadian(3)),@(AngleToRadian(-3))];
        rockAnimation.repeatCount = MAXFLOAT;
        rockAnimation.duration = 0.3;
        rockAnimation.removedOnCompletion = NO;
        [self.layer addAnimation:rockAnimation forKey:@"rocking"];
    }
}

#pragma mark - Private Method

- (void)clickAction:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(clickSpringBoardCell:)]) {
        [_delegate clickSpringBoardCell:weakSelf];
    }
}

- (void)longGestureAction:(UILongPressGestureRecognizer *)gesture
{
    __weak __typeof(self)weakSelf = self;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(editingSpringBoardCell:)]) {
                [_delegate editingSpringBoardCell:weakSelf];
            }
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateBegin:)]) {
                [_longGestureDelegate springBoardCell:weakSelf longGestureStateBegin:gesture];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateMove:)]) {
                [_longGestureDelegate springBoardCell:weakSelf longGestureStateMove:gesture];
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        {
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateCancel:)]) {
                [_longGestureDelegate springBoardCell:weakSelf longGestureStateCancel:gesture];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateEnd:)]) {
                [_longGestureDelegate springBoardCell:weakSelf longGestureStateEnd:gesture];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
