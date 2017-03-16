//
//  NSBundle+SpringBoard.m
//  Pods
//
//  Created by LIJUN on 2017/3/16.
//
//

#import "NSBundle+SpringBoard.h"
#import "WBSpringBoardComponent.h"

@implementation NSBundle (SpringBoard)

+ (instancetype)wb_bundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[WBSpringBoardComponent class]] pathForResource:@"SpringBoard" ofType:@"bundle"]];
    }
    return bundle;
}

+ (UIImage *)wb_icoImage
{
    static UIImage *icoImage = nil;
    if (icoImage == nil) {
        icoImage = [UIImage imageNamed:@"ico" inBundle:[NSBundle wb_bundle] compatibleWithTraitCollection:nil];
    }
    return icoImage;
}

@end
