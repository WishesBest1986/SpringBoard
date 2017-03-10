//
//  WBCustomerCombinedCell.m
//  SpringBoard
//
//  Created by LIJUN on 2017/3/10.
//  Copyright © 2017年 LiJun. All rights reserved.
//

#import "WBCustomerCombinedCell.h"
#import <Masonry/Masonry.h>

@implementation WBCustomerCombinedCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [[UILabel alloc] init];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

@end
