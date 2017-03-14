//
//  WBSpringBoardLayout.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "WBSpringBoardLayout.h"
#import "WBSpringBoardDefines.h"

@implementation WBSpringBoardLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemSize = kItemSizeDefault;
        _insets = kEdgeInsetsDefault;
        _minimumHorizontalSpace = kMinimumHorizontalSpaceDefault;
        _minimumVerticalSpace = kMinimumVerticalSpaceDefault;
        _scrollDirection = WBSpringBoardScrollDirectionHorizontal;
    }
    return self;
}

@end
