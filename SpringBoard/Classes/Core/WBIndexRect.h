//
//  WBIndexRect.h
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import <Foundation/Foundation.h>

@interface WBIndexRect : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect innerRect;

- (instancetype)initWithIndex:(NSInteger)index rect:(CGRect)rect;

@end
