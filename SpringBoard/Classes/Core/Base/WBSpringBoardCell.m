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
#import "NSBundle+SpringBoard.h"
#import <Foundation/Foundation.h>

@interface WBSpringBoardCell ()

@property (nonatomic, weak) UIView *directoryHolderView;

@end

@implementation WBSpringBoardCell

#define kImageViewSize CGSizeMake(70, 70)
#define kImageViewCornerRadius 10
#define kLabelFontSize 12

#define kViewScaleFactor 1.2

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
        [self addGestureRecognizer:_longGesture];
        
        UIView *directoryHolderView = [[UIView alloc] initWithFrame:CGRectZero];
        directoryHolderView.backgroundColor = [UIColor lightGrayColor];
        directoryHolderView.layer.cornerRadius = kImageViewCornerRadius;
        directoryHolderView.userInteractionEnabled = NO;
        directoryHolderView.hidden = YES;
        [self addSubview:directoryHolderView];
        _directoryHolderView = directoryHolderView;
        
        UIView *topSpaceView = [UIView new];
        UIView *bottomSpaceView = [UIView new];
        [self addSubview:topSpaceView];
        [self addSubview:bottomSpaceView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [NSBundle wb_icoImage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = kImageViewCornerRadius;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        _imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:kLabelFontSize];
        [self addSubview:label];
        _label = label;
        
        [directoryHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(imageView);
        }];
        
        [topSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(bottomSpaceView);
            make.centerX.mas_equalTo(self);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(kImageViewSize);
            make.top.mas_equalTo(topSpaceView.mas_bottom);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_lessThanOrEqualTo(imageView).offset(10);
            make.height.mas_equalTo(label.font.lineHeight);
            make.top.mas_equalTo(imageView.mas_bottom).offset(2);
        }];
        
        [bottomSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom);
            make.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
        }];
        
        // process set nil image problems
        [_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [_imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - Override Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *image = [change valueForKey:NSKeyValueChangeNewKey];
        if (![image isKindOfClass:[UIImage class]]) {
            _imageView.image = [NSBundle wb_icoImage];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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

- (void)setShowDirectoryHolderView:(BOOL)showDirectoryHolderView
{
    if (_showDirectoryHolderView != showDirectoryHolderView) {
        _showDirectoryHolderView = showDirectoryHolderView;
        
        if (showDirectoryHolderView) {
            _directoryHolderView.hidden = NO;
            [UIView animateWithDuration:kAnimationSlowDuration animations:^{
                _directoryHolderView.layer.affineTransform = CGAffineTransformMakeScale(kViewScaleFactor, kViewScaleFactor);
            }];
        } else {
            [UIView animateWithDuration:kAnimationSlowDuration animations:^{
                _directoryHolderView.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _directoryHolderView.hidden = YES;
            }];
        }
    }
}

#pragma mark - Private Method

- (void)clickAction:(id)sender
{
    @WBWeakObj(self);
    if (_delegate && [_delegate respondsToSelector:@selector(clickSpringBoardCell:)]) {
        [_delegate clickSpringBoardCell:weakself];
    }
}

- (void)longGestureAction:(UILongPressGestureRecognizer *)gesture
{
    @WBWeakObj(self);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(editingSpringBoardCell:)]) {
                [_delegate editingSpringBoardCell:weakself];
            }
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateBegin:)]) {
                [_longGestureDelegate springBoardCell:weakself longGestureStateBegin:gesture];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateMove:)]) {
                [_longGestureDelegate springBoardCell:weakself longGestureStateMove:gesture];
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        {
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateCancel:)]) {
                [_longGestureDelegate springBoardCell:weakself longGestureStateCancel:gesture];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (_longGestureDelegate && [_longGestureDelegate respondsToSelector:@selector(springBoardCell:longGestureStateEnd:)]) {
                [_longGestureDelegate springBoardCell:weakself longGestureStateEnd:gesture];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
