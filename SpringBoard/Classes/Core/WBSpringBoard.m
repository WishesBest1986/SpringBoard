//
//  WBSpringBoard.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "WBSpringBoard.h"
#import "WBSpringBoardDefines.h"
#import "WBSpringBoardLayout.h"
#import "WBSpringBoardCell.h"
#import "WBIndexRect.h"
#import <Masonry/Masonry.h>

@interface WBSpringBoard () <UIScrollViewDelegate, WBSpringBoardCellDelegate, WBSpringBoardCellLongGestureDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *dragView;

@property (nonatomic, assign) NSInteger numberOfItems;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger colsPerPage;
@property (nonatomic, assign) NSInteger rowsPerPage;

@property (nonatomic, strong) NSMutableArray *frameContainerArray;
@property (nonatomic, strong) NSMutableArray *contentIndexRectArray;
@property (nonatomic, strong) NSMutableArray *contentCellArray;

@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, assign) NSInteger dragFromIndex;

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGPoint previousMovePointAtWindow;
@property (nonatomic, assign) CGPoint currentMovePointAtScrollView;

@property (nonatomic, strong) dispatch_source_t flipDetectTimer;

@end

@implementation WBSpringBoard

#define kDragScaleFactor 1.2
#define kScrollViewDragBoundaryThreshold 30
#define kFlipDetectTimeInterval 0.5

#pragma mark - Init & Dealloc

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [self stopDetectFlipTimer];
}

#pragma mark - Private Method

- (void)commonInit
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scrollView.superview);
    }];
    _scrollView = scrollView;

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    pageControl.enabled = NO;
    pageControl.numberOfPages = 1;
    [self addSubview:pageControl];
    [pageControl sizeToFit];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(pageControl.superview);
        make.width.mas_equalTo(pageControl.superview);
        make.height.mas_equalTo(pageControl.bounds.size.height);
        make.bottom.mas_equalTo(pageControl.superview);
    }];
    _pageControl = pageControl;

    _layout = [[WBSpringBoardLayout alloc] init];
    
    _frameContainerArray = [NSMutableArray array];
    _contentIndexRectArray = [NSMutableArray array];
    _contentCellArray = [NSMutableArray array];
    
    [self reloadData];
}

- (void)layoutContentCells
{
    __weak __typeof(self)weakSelf = self;
    
    [self computePages];
    [self computeFrameContainers];

    [_contentIndexRectArray removeAllObjects];
    for (UIView *view in _contentCellArray) {
        [view removeFromSuperview];
    }
    [_contentCellArray removeAllObjects];
    
    for (NSInteger i = 0; i < _numberOfItems; i ++) {
        WBSpringBoardCell *cell = nil;
        if (_dataSource) {
            NSAssert([_dataSource respondsToSelector:@selector(springBoard:cellForItemAtIndex:)], @"@selector(springBoard:cellForItemAtIndex:) must be implemented");
            cell = [_dataSource springBoard:weakSelf cellForItemAtIndex:i];
        } else {
            cell = [[WBSpringBoardCell alloc] init];
        }
        cell.frame = CGRectFromString(_frameContainerArray[i]);
        cell.delegate = self;
        cell.longGestureDelegate = self;
        
        
        [_contentIndexRectArray addObject:[[WBIndexRect alloc] initWithIndex:i rect:cell.frame]];
        [_contentCellArray addObject:cell];
        [_scrollView addSubview:cell];
    }

    CGAffineTransform t = CGAffineTransformMakeScale(_pages, 1);
    if (_layout.scrollDirection == WBSpringBoardScrollDirectionVertical) {
        t = CGAffineTransformMakeScale(1, _pages);
    }
    _scrollView.contentSize = CGSizeApplyAffineTransform(_scrollView.bounds.size, t);
    
    _pageControl.numberOfPages = _pages;
    _pageControl.currentPage = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
}

- (void)computePages
{
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat maximumContentWidth = scrollViewSize.width - (_layout.insets.left + _layout.insets.right);
    CGFloat maximumContentHeight = scrollViewSize.height - (_layout.insets.top + _layout.insets.bottom);

    _colsPerPage = (maximumContentWidth + _layout.minimumHorizontalSpace) / (_layout.itemSize.width + _layout.minimumHorizontalSpace);
    _rowsPerPage = (maximumContentHeight + _layout.minimumVerticalSpace) / (_layout.itemSize.height + _layout.minimumVerticalSpace);
    
    NSInteger onePageMaxItems = _colsPerPage * _rowsPerPage;
    _pages = MAX((_numberOfItems + (onePageMaxItems - 1)) / onePageMaxItems, 1);
}

- (void)computeFrameContainers
{
    [_frameContainerArray removeAllObjects];
    
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGSize itemSize = _layout.itemSize;
    CGFloat itemHSpace = (scrollViewSize.width - (_layout.insets.left + _layout.insets.right) - _colsPerPage * itemSize.width) / (_colsPerPage - 1);
    CGFloat itemVSpace = (scrollViewSize.height - (_layout.insets.top + _layout.insets.bottom) - _rowsPerPage * itemSize.height) / (_rowsPerPage - 1);
    
    for (NSInteger page = 0; page < _pages; page ++) {
        for (NSInteger row = 0; row < _rowsPerPage; row ++) {
            for (NSInteger col = 0; col < _colsPerPage; col ++) {
                CGRect frame = CGRectZero;
                frame.size = itemSize;
                
                frame.origin.x = page * scrollViewSize.width + _layout.insets.left + (itemSize.width + itemHSpace) * col;
                frame.origin.y = _layout.insets.top + (itemSize.height + itemVSpace) * row;
                if (_layout.scrollDirection == WBSpringBoardScrollDirectionVertical) {
                    frame.origin.x = _layout.insets.left + (itemSize.width + itemHSpace) * col;
                    frame.origin.y = page * scrollViewSize.height + _layout.insets.top + (itemSize.height + itemVSpace) * row;
                }
                
                [_frameContainerArray addObject:NSStringFromCGRect(frame)];
            }
        }
    }
}

- (NSInteger)indexForCell:(WBSpringBoardCell *)cell
{
    return [_contentCellArray indexOfObject:cell];
}

- (UIView *)dragViewWithCell:(WBSpringBoardCell *)cell
{
    self.isDrag = YES;
    if (_dragView) {
        return _dragView;
    }
    
    CGRect frame = cell.frame;
    CGRect dragFrameInWindow = [cell.superview convertRect:frame toView:kAppKeyWindow];
    
    _dragView = [cell snapshotViewAfterScreenUpdates:NO];
    _dragView.frame = dragFrameInWindow;
    [kAppKeyWindow addSubview:_dragView];
    
    return _dragView;
}

- (double)fingerMoveSpeedWithPreviousPoint:(CGPoint)prePoint nowPoint:(CGPoint)nowPoint
{
    double x = pow(prePoint.x - nowPoint.x, 2);
    double y = pow(prePoint.y - nowPoint.y, 2);
    return sqrt(x + y);
}

- (NSDictionary *)targetInfoWithPoint:(CGPoint)scrollPoint
{
    NSMutableDictionary *dict = [@{@"targetIndex": @(-1), @"innerRect": @(NO)} mutableCopy];
    for (WBIndexRect *indexRect in _contentIndexRectArray) {
        if (CGRectContainsPoint(indexRect.rect, scrollPoint)) {
            dict[@"targetIndex"] = @(indexRect.index);
            if (CGRectContainsPoint(indexRect.innerRect, scrollPoint)) {
                dict[@"innerRect"] = @(YES);
            }
            
            break;
        }
    }
    return dict;
}


- (void)sortContentCellsWithAnimated:(BOOL)animated
{
    [UIView animateWithDuration:(animated ? kAnimationSlowDuration : 0.0) animations:^{
        for (NSInteger i = 0; i < _contentCellArray.count; i ++) {
            UIView *view = _contentCellArray[i];
            view.frame = CGRectFromString(_frameContainerArray[i]);
        }
    }];
}

- (void)startDetectFlipTimer
{
    [self stopDetectFlipTimer];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _flipDetectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    dispatch_source_set_timer(_flipDetectTimer, DISPATCH_TIME_NOW, kFlipDetectTimeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_flipDetectTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self detectScrollViewFlipBasedOnCurrentMovePoint];
        });
    });
    dispatch_resume(_flipDetectTimer);
}

- (void)stopDetectFlipTimer
{
    if (_flipDetectTimer) {
        dispatch_source_cancel(_flipDetectTimer);
        _flipDetectTimer = nil;
    }
}

- (void)detectScrollViewFlipBasedOnCurrentMovePoint
{
    CGPoint scrollPoint = _currentMovePointAtScrollView;
    
    CGRect scrollViewLeftSideRect = CGRectMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y, kScrollViewDragBoundaryThreshold, CGRectGetHeight(_scrollView.frame));
    CGRect scrollViewRightSideRect = CGRectMake(_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.frame) - kScrollViewDragBoundaryThreshold, _scrollView.contentOffset.y, kScrollViewDragBoundaryThreshold, CGRectGetHeight(_scrollView.frame));
    
    if (CGRectContainsPoint(scrollViewLeftSideRect, scrollPoint)) {
        if (_pageControl.currentPage > 0) {
            _pageControl.currentPage -= 1;
            CGPoint offset = CGPointMake(_pageControl.currentPage * CGRectGetWidth(_scrollView.frame), 0);
            [_scrollView setContentOffset:offset animated:YES];
        }
    } else if (CGRectContainsPoint(scrollViewRightSideRect, scrollPoint)) {
        if (_pageControl.currentPage < _pageControl.numberOfPages - 1) {
            _pageControl.currentPage += 1;
            CGPoint offset = CGPointMake(_pageControl.currentPage * CGRectGetWidth(_scrollView.frame), 0);
            [_scrollView setContentOffset:offset animated:YES];
        }
    }
}

#pragma mark - Setter & Getter

- (void)setLayout:(WBSpringBoardLayout *)layout
{
    _layout = layout;
    
    [self reloadData];
}

- (void)setDataSource:(id<WBSpringBoardDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reloadData];
}

- (void)setIsEdit:(BOOL)isEdit
{
    if (_isEdit != isEdit) {
        _isEdit = isEdit;
        
        for (WBSpringBoardCell *cell in _contentCellArray) {
            cell.isEdit = isEdit;
        }
    }
}

- (void)setIsDrag:(BOOL)isDrag
{
    if (_isDrag != isDrag) {
        _isDrag = isDrag;
        
        if (isDrag) {
            [self startDetectFlipTimer];
        } else {
            [self stopDetectFlipTimer];
        }
    }
}

#pragma mark - Public Method

- (void)reloadData
{
    __weak __typeof(self)weakSelf = self;
    
    _numberOfItems = 0;
    if (_dataSource) {
        NSAssert([_dataSource respondsToSelector:@selector(numberOfItemsInSpringBoard:)], @"@selector(numberOfItemsInSpringBoard:) must be implemented");
        _numberOfItems = [_dataSource numberOfItemsInSpringBoard:weakSelf];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutContentCells];
    });
}

#pragma mark - UIScrollViewDelegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isDrag) {
        // Ajust currentMovePointAtScrollView when [_scrollView setContentOffset:offset animated:YES]
        // fix mistake value when auto flip while gesture not moved.
        WBSpringBoardCell *dragedCell = _contentCellArray[_dragFromIndex];
        _currentMovePointAtScrollView = [dragedCell.longGesture locationInView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_layout.scrollDirection == WBSpringBoardScrollDirectionHorizontal) {
        _pageControl.currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    } else if (_layout.scrollDirection == WBSpringBoardScrollDirectionVertical) {
        _pageControl.currentPage = scrollView.contentOffset.y / scrollView.bounds.size.height;
    }
}

#pragma mark - WBSpringBoardCellDelegate Method

- (void)clickSpringBoardCell:(WBSpringBoardCell *)cell
{
    if (self.isEdit) {
        self.isEdit = NO;
    }
}

- (void)editingSpringBoardCell:(WBSpringBoardCell *)cell
{
    self.isEdit = YES;
    
    _dragFromIndex = [self indexForCell:cell];
    
    UIView *dragView = [self dragViewWithCell:cell];
    dragView.backgroundColor = [UIColor redColor];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        dragView.transform = CGAffineTransformMakeScale(kDragScaleFactor, kDragScaleFactor);
        dragView.alpha = 0.8;
    }];
}

#pragma mark - WBSpringBoardCellLongGestureDelegate Method

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateBegin:(UILongPressGestureRecognizer *)gesture
{
    cell.hidden = YES;
    
    CGPoint beginPoint = [gesture locationInView:cell];
    _lastPoint = CGPointApplyAffineTransform(beginPoint, CGAffineTransformMakeScale(kDragScaleFactor, kDragScaleFactor));
    CGPoint pointAtWindow = [gesture locationInView:kAppKeyWindow];
    _previousMovePointAtWindow = pointAtWindow;
}

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateMove:(UILongPressGestureRecognizer *)gesture
{
    __weak __typeof(self)weakSelf = self;
    
    CGPoint pointAtWindow = [gesture locationInView:kAppKeyWindow];
    CGPoint currentOrigin = CGPointMake(pointAtWindow.x - _lastPoint.x, pointAtWindow.y - _lastPoint.y);
    if (_isDrag) {
        CGRect dragViewFrame = _dragView.frame;
        dragViewFrame.origin = currentOrigin;
        _dragView.frame = dragViewFrame;
        
        CGPoint scrollPoint = [gesture locationInView:_scrollView];
        _currentMovePointAtScrollView = scrollPoint;

        double fingerSpeed = [self fingerMoveSpeedWithPreviousPoint:_previousMovePointAtWindow nowPoint:pointAtWindow];
        _previousMovePointAtWindow = pointAtWindow;
        if (fingerSpeed < 2) {
            NSDictionary *targetInfo = [self targetInfoWithPoint:scrollPoint];
            NSInteger targetIndex = [targetInfo[@"targetIndex"] integerValue];
            
            if (targetIndex >= 0 && targetIndex != _dragFromIndex) {
                [_contentCellArray removeObjectAtIndex:_dragFromIndex];
                [_contentCellArray insertObject:cell atIndex:targetIndex];
                [self sortContentCellsWithAnimated:YES];
                
                if (_dataSource && [_dataSource respondsToSelector:@selector(springBoard:moveItemAtIndex:toIndex:)]) {
                    [_dataSource springBoard:weakSelf moveItemAtIndex:_dragFromIndex toIndex:targetIndex];
                }
                
                _dragFromIndex = targetIndex;
            }
        }
    }
}

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateEnd:(UILongPressGestureRecognizer *)gesture
{
    cell.hidden = NO;
    
    if (_isDrag) {
        self.isDrag = NO;
        
        [_dragView removeFromSuperview];
        _dragView = nil;
    }
}

- (void)springBoardCell:(WBSpringBoardCell *)cell longGestureStateCancel:(UILongPressGestureRecognizer *)gesture
{
    cell.hidden = NO;

    if (_isDrag) {
        self.isDrag = NO;
        
        [_dragView removeFromSuperview];
        _dragView = nil;
    }
}

@end
