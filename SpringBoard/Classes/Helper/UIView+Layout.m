//
//  UIView+Layout.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)layoutWithHorizontalAlignment:(HorizontalAlignment)horizontalAlignment
                withVerticalAlignment:(VerticalAlignment)verticalAlignment
                           withMargin:(Thickness)margin
{
    CGRect frame = self.frame;
    CGRect parentFrame = self.superview.frame;
    switch (horizontalAlignment) {
        case HLeft:
            frame.origin.x = margin.left;
            break;
        case HRight:
            frame.origin.x = parentFrame.size.width - frame.size.width - margin.right;
            break;
        case HCenter:
            frame.origin.x = roundf((parentFrame.size.width - frame.size.width) / 2.0);
            break;
        case HStretch:
            frame.origin.x = margin.left;
            frame.size.width = parentFrame.size.width - margin.left - margin.right;
            break;
        default:
            break;
    }
    
    switch (verticalAlignment) {
        case VTop:
            frame.origin.y = margin.top;
            break;
        case VBottom:
            frame.origin.y = parentFrame.size.height - frame.size.height - margin.bottom;
            break;
        case VCenter:
            frame.origin.y = roundf((parentFrame.size.height - frame.size.height) / 2.0);
            break;
        case VStretch:
            frame.origin.y = margin.top;
            frame.size.height = parentFrame.size.height - margin.top - margin.bottom;
            break;
        default:
            break;
    }
    
    self.frame = frame;
}

- (void)layoutBesideView:(UIView *)view
     withVertexAlignment:(VertexAlignment)vertexAlignment
              withMargin:(Thickness)margin
{
    CGRect frame = self.frame;
    CGRect refFrame = view.frame;
    
    switch (vertexAlignment) {
        case VTopLeft:
            frame.origin.x = refFrame.origin.x + margin.left;
            frame.origin.y = refFrame.origin.y + margin.top;
            break;
        case VTopRight:
            frame.origin.x = refFrame.origin.x + refFrame.size.width + margin.left;
            frame.origin.y = refFrame.origin.y + margin.top;
            break;
        case VBottomLeft:
            frame.origin.x = refFrame.origin.x + margin.left;
            frame.origin.y = refFrame.origin.y + refFrame.size.height + margin.top;
            break;
        case VBottomRight:
            frame.origin.x = refFrame.origin.x + refFrame.size.width + margin.left;
            frame.origin.y = refFrame.origin.y + refFrame.size.height + margin.top;
            break;
        case VCenterLeft:
            frame.origin.x = refFrame.origin.x + margin.left;
            frame.origin.y = refFrame.origin.y + roundf((refFrame.size.height - frame.size.height) / 2.0) + margin.top;
            break;
        case VCenterRight:
            frame.origin.x = refFrame.origin.x + refFrame.size.width + margin.left;
            frame.origin.y = refFrame.origin.y + roundf((refFrame.size.height - frame.size.height) / 2.0) + margin.top;
            break;
        case VBottomCenter:
            frame.origin.x = refFrame.origin.x + roundf((refFrame.size.width - frame.size.width) / 2.0) + margin.left;
            frame.origin.y = refFrame.origin.y + refFrame.size.height + margin.top;
            break;
        default:
            break;
    }
    
    self.frame = frame;
}

- (void)layoutInView:(UIView *)view
withHorizontalAlignment:(HorizontalAlignment)horizontalAlignment
withVerticalAlignment:(VerticalAlignment)verticalAlignment
          withMargin:(Thickness)margin
{
    CGRect frame = self.frame;
    CGRect refFrame = view.frame;
    
    switch (horizontalAlignment) {
        case HLeft:
            frame.origin.x = refFrame.origin.x + margin.left;
            break;
        case HRight:
            frame.origin.x = refFrame.origin.x + refFrame.size.width - frame.size.width - margin.right;
            break;
        case HCenter:
            frame.origin.x = refFrame.origin.x + roundf((refFrame.size.width - frame.size.width) / 2.0);
            break;
        case HStretch:
            frame.origin.x = refFrame.origin.x + margin.left;
            frame.size.width = refFrame.size.width - margin.left - margin.right;
            break;
        default:
            break;
    }
    
    switch (verticalAlignment) {
        case VTop:
            frame.origin.y = refFrame.origin.y + margin.top;
            break;
        case VBottom:
            frame.origin.y = refFrame.origin.y + refFrame.size.height - frame.size.height - margin.bottom;
            break;
        case VCenter:
            frame.origin.y = refFrame.origin.y + roundf((refFrame.size.height - frame.size.height) / 2.0);
            break;
        case VStretch:
            frame.origin.y = refFrame.origin.y + margin.top;
            frame.size.height = refFrame.size.height - margin.top - margin.bottom;
            break;
        default:
            break;
    }
    
    self.frame = frame;
}

@end
