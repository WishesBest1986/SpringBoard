//
//  WBSpringBoardCombinedPopup.h
//  Pods
//
//  Created by LIJUN on 2017/3/10.
//
//

#import <UIKit/UIKit.h>

@interface WBSpringBoardCombinedPopup : UIControl

@property (nonatomic, readonly) UIView *springBoard;

- (void)hideWithAnimated:(BOOL)animated removeFromSuperView:(BOOL)remove;

@end
