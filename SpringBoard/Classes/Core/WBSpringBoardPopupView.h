//
//  WBSpringBoardPopupView.h
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import <UIKit/UIKit.h>

@interface WBSpringBoardPopupView : UIControl

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, assign) BOOL isEdit;

- (void)setTitle:(NSString *)title;
- (void)hideWithAnimated:(BOOL)animated removeFromSuperView:(BOOL)remove;

@end
