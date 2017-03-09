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

@property (nonatomic, weak) UIView *directoryView;

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
        
        UIView *directoryView = [[UIView alloc] initWithFrame:CGRectZero];
        directoryView.layer.borderColor = [UIColor blueColor].CGColor;
        directoryView.layer.borderWidth = 0.5;
        directoryView.layer.cornerRadius = 5;
        directoryView.userInteractionEnabled = NO;
        [self addSubview:directoryView];
        [directoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        _directoryView = directoryView;
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
