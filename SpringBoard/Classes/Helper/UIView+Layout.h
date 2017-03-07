//
//  UIView+Layout.h
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import <UIKit/UIKit.h>

// Summary:
//     Describe the thickness of a frame around a rectangle. Four double values describe
//     the left, top, right, bottom sides of the rectangle, respectively.
struct Thickness {
    double left;
    double top;
    double right;
    double bottom;
};
typedef struct Thickness Thickness;

NS_INLINE Thickness ThicknessMake(double left, double top, double right, double bottom) {
    Thickness t;
    t.left = left;
    t.top = top;
    t.right = right;
    t.bottom = bottom;
    return t;
}

NS_INLINE Thickness ThicknessZero()
{
    Thickness t;
    t.left = 0;
    t.top = 0;
    t.right = 0;
    t.bottom = 0;
    return t;
}

// Summary:
//     Indicates where an element should be displayed beside reference view.
typedef enum {
    // Summary:
    //     An element aligned to the left-top of the reference view.
    VTopLeft = 0,
    //
    // Summary:
    //     An element aligned to the top-right of the reference view.
    VTopRight = 1,
    //
    // Summary:
    //     An element aligned to the bottom-left of the reference view.
    VBottomLeft = 2,
    //
    // Summary:
    //     An element aligned to the bottom-right of the reference view.
    VBottomRight = 3,
    //
    // Summary:
    //     An element aligned to the center-left of the reference view.
    VCenterLeft = 4,
    //
    // Summary:
    //     An element aligned to the center-right of the reference view.
    VCenterRight = 5,
    //
    // Summary:
    //     An element aligned to the bottom-center of the reference view.
    VBottomCenter = 6,
} VertexAlignment;

// Summary:
//     Indicates where an element should be displayed on the horizontal axis relative
//     to the allocated layout slot of the parent element.
typedef enum {
    // Summary:
    //     An element aligned to the left of the layout slot for the parent element.
    HLeft = 0,
    //
    // Summary:
    //     An element aligned to the center of the layout slot for the parent element.
    HCenter = 1,
    //
    // Summary:
    //     An element aligned to the right of the layout slot for the parent element.
    HRight = 2,
    //
    // Summary:
    //     An element stretched to fill the entire layout slot of the parent element.
    HStretch = 3,
} HorizontalAlignment;

// Summary:
//     Describes how a child element is vertically positioned or stretched within
//     a parent's layout slot.
typedef enum {
    // Summary:
    //     The element is aligned to the top of the parent's layout slot.
    VTop = 0,
    //
    // Summary:
    //     The element is aligned to the center of the parent's layout slot.
    VCenter = 1,
    //
    // Summary:
    //     The element is aligned to the bottom of the parent's layout slot.
    VBottom = 2,
    //
    // Summary:
    //     The element is stretched to fill the entire layout slot of the parent element.
    VStretch = 3,
} VerticalAlignment;

@interface UIView (Layout)

- (void)layoutWithHorizontalAlignment:(HorizontalAlignment)horizontalAlignment
                withVerticalAlignment:(VerticalAlignment)verticalAlignment
                           withMargin:(Thickness)margin;

- (void)layoutBesideView:(UIView *)view
     withVertexAlignment:(VertexAlignment)vertexAlignment
              withMargin:(Thickness)margin;

- (void)layoutInView:(UIView *)view
withHorizontalAlignment:(HorizontalAlignment)horizontalAlignment
withVerticalAlignment:(VerticalAlignment)verticalAlignment
          withMargin:(Thickness)margin;

@end
