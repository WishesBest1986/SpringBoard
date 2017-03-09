//
//  WBCustomerCell.m
//  SpringBoard
//
//  Created by LIJUN on 2017/3/9.
//  Copyright © 2017年 LiJun. All rights reserved.
//

#import "WBCustomerCell.h"

@implementation WBCustomerCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_label];
    }
    return self;
}

@end
