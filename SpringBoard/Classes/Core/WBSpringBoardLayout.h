//
//  WBSpringBoardLayout.h
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WBSpringBoardScrollDirection) {
    WBSpringBoardScrollDirectionVertical,
    WBSpringBoardScrollDirectionHorizontal
};

@interface WBSpringBoardLayout : NSObject

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat minimumHorizontalSpace;
@property (nonatomic, assign) CGFloat minimumVerticalSpace;
@property (nonatomic, assign) WBSpringBoardScrollDirection scrollDirection;

@end
