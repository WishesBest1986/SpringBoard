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
        [inputView addSubview:textField];
        _textField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(inputView);
            make.width.mas_equalTo(inputView).multipliedBy(0.6);
            make.height.mas_equalTo(40);
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
    _isEdit = isEdit;
    
    _textField.enabled = isEdit;
    _textField.borderStyle = isEdit ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
}

#pragma mark - Public Method

- (void)setTitle:(NSString *)title
{
    _textField.text = title;
}

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
    [self hideWithAnimated:YES removeFromSuperView:YES];
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
