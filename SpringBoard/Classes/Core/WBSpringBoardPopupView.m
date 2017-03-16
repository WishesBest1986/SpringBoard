//
//  WBSpringBoardPopupView.m
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import "WBSpringBoardPopupView.h"
#import "WBSpringBoardDefines.h"
#import <Masonry/Masonry.h>

@interface WBSpringBoardPopupView ( ) <UITextFieldDelegate>

@property (nonatomic, weak) UIView *inputView;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UILabel *label;

@end

@implementation WBSpringBoardPopupView

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        
        UIView *inputView = [[UIView alloc] init];
        [self addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(self).multipliedBy(0.3);
        }];
        _inputView = inputView;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:30];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.hidden = YES;
        [inputView addSubview:textField];
        _textField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(inputView);
            make.width.mas_equalTo(inputView).multipliedBy(0.8);
            make.height.mas_equalTo(40);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:30];
        label.textAlignment = NSTextAlignmentCenter;
        [inputView addSubview:label];
        _label = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(textField);
        }];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 10;
        [self addSubview:contentView];
        _contentView = contentView;
        @WBWeakObj(self);
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @WBStrongObj(self);
            make.top.mas_equalTo(inputView.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self).multipliedBy(0.8);
            make.height.mas_equalTo(self).multipliedBy(0.5);
        }];
        
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(innerViewEditChangedNotification:)
                                                     name:kNotificationKeyInnerViewEditChanged
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationKeyInnerViewEditChanged
                                                  object:nil];
}

#pragma mark - Setter & Getter

- (void)setIsEdit:(BOOL)isEdit
{
    if (_isEdit != isEdit) {
        _isEdit = isEdit;

        if (isEdit) {
            _textField.text = _label.text;
        } else {
            if (_textField.text.length > 0) {
                _label.text = _textField.text;
            }
            [_textField resignFirstResponder];
        }
    }
    
    _textField.hidden = !isEdit;
    _label.hidden = isEdit;
}

- (void)setOriginTitle:(NSString *)originTitle
{
    _originTitle = originTitle;

    _textField.text = originTitle;
    _label.text = originTitle;
}

- (NSString *)currentTitle
{
    return _textField.text;
}

#pragma mark - Public Method

- (void)hideWithAnimated:(BOOL)animated removeFromSuperView:(BOOL)remove
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (remove) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Private Method

- (void)clickAction:(id)sender
{
    if (_maskClickBlock) {
        _maskClickBlock();
    } else {
        [self hideWithAnimated:YES removeFromSuperView:YES];
    }
}

- (void)innerViewEditChangedNotification:(NSNotification *)notification
{
    BOOL edit = [notification.object boolValue];
    self.isEdit = edit;
}

#pragma mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
