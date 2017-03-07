//
//  WBIndexRect.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "WBIndexRect.h"
#import "WBSpringBoardDefines.h"

@implementation WBIndexRect

- (instancetype)initWithIndex:(NSInteger)index rect:(CGRect)rect
{
    self = [super init];
    if (self) {
        _index = index;
        _rect = rect;
        
        _innerRect = CGRectInset(rect, kCellInnerRectSideSpace, kCellInnerRectSideSpace);
    }
    return self;
}

@end
