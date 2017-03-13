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
        _label.numberOfLines = 0;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_lessThanOrEqualTo(self).offset(-10);
            make.height.mas_lessThanOrEqualTo(self).offset(-10);
        }];
    }
    return self;
}

@end
