//
//  WBSpringBoardCell.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "WBSpringBoardCell.h"
#import "WBSpringBoardDefines.h"
#import <Masonry/Masonry.h>

@interface WBSpringBoardCell ()

@property (nonatomic, weak) UIView *directoryBorder;

@end

@implementation WBSpringBoardCell

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
        [self addGestureRecognizer:_longGesture];
        
        UIView *directoryBorder = [[UIView alloc] initWithFrame:CGRectZero];
        directoryBorder.layer.borderColor = [UIColor blueColor].CGColor;
        directoryBorder.layer.borderWidth = 0.5;
        directoryBorder.layer.cornerRadius = 5;
        directoryBorder.userInteractionEnabled = NO;
        directoryBorder.hidden = YES;
        [self addSubview:directoryBorder];
        [directoryBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        _directoryBorder = directoryBorder;
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
        rockAnimation.duration = kAnimationDuration;
        rockAnimation.removedOnCompletion = NO;
        [self.layer addAnimation:rockAnimation forKey:@"rocking"];
    }
}

- (void)setShowDirectoryBorder:(BOOL)showDirectoryBorder
{
    if (_showDirectoryBorder != showDirectoryBorder) {
        _showDirectoryBorder = showDirectoryBorder;
        
        if (showDirectoryBorder) {
            _directoryBorder.hidden = NO;
            [UIView animateWithDuration:kAnimationSlowDuration animations:^{
                _directoryBorder.layer.affineTransform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
        } else {
            [UIView animateWithDuration:kAnimationSlowDuration animations:^{
                _directoryBorder.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _directoryBorder.hidden = YES;
            }];
        }
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
