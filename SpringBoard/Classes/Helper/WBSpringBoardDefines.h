//
//  WBSpringBoardDefines.h
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#ifndef WBSpringBoardDefines_h
#define WBSpringBoardDefines_h

#define kAppKeyWindow [UIApplication sharedApplication].keyWindow
#define kAnimationDuration 0.3
#define kAnimationSlowDuration 0.6

#define AngleToRadian(x) ((x) / 180.0 * M_PI)

#define WBWeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o;
#define WBStrongObj(o) autoreleasepool{} __strong typeof(o) o = weak##o;

#define kNotificationKeyInnerViewEditChanged @"kNotificationKeyInnerViewEditChanged"

// DEFINE DEFAULT VALUES
#define kItemSizeDefault CGSizeMake(100, 100)
#define kEdgeInsetsDefault UIEdgeInsetsZero;
#define kMinimumHorizontalSpaceDefault 10
#define kMinimumVerticalSpaceDefault 10

#define kCellInnerRectSideSpace 15

#define kCombinedCellShowItemColCount 3
#define kCombinedCellShowItemRowCount 3

#endif /* WBSpringBoardDefines_h */
