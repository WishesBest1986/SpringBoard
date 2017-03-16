//
//  WBSpringBoardPopupView.h
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import <UIKit/UIKit.h>

@interface WBSpringBoardPopupView : UIControl

@property (nonatomic, copy) void (^maskClickBlock)(WBSpringBoardPopupView *popupView);

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) NSString *originTitle;
@property (nonatomic, readonly) NSString *currentTitle;

- (void)hideWithAnimated:(BOOL)animated removeFromSuperView:(BOOL)remove;

@end
