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
#import "UIView+Layout.h"

@interface WBSpringBoard () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger numberOfItems;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger colsPerPage;
@property (nonatomic, assign) NSInteger rowsPerPage;

@property (nonatomic, strong) NSMutableArray *frameContainerArray;

@property (nonatomic, strong) NSMutableArray *contentIndexRectArray;
@property (nonatomic, strong) NSMutableArray *contentCellArray;

@end

@implementation WBSpringBoard

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

#pragma mark - Private Method

- (void)commonInit
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    [scrollView layoutWithHorizontalAlignment:HStretch
                        withVerticalAlignment:VStretch
                                   withMargin:ThicknessZero()];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    pageControl.enabled = NO;
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    pageControl.numberOfPages = 1;
    [self addSubview:pageControl];
    _pageControl = pageControl;

    [pageControl sizeToFit];
    [pageControl layoutWithHorizontalAlignment:HCenter
                         withVerticalAlignment:VBottom
                                    withMargin:ThicknessZero()];
    
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
        
        CGRect frame = CGRectFromString(_frameContainerArray[i]);
        cell.frame = frame;
        
        [_contentIndexRectArray addObject:[[WBIndexRect alloc] initWithIndex:i rect:frame]];
        [_contentCellArray addObject:cell];
        [_scrollView addSubview:cell];
    }

    CGAffineTransform t = CGAffineTransformMakeScale(_pages, 1);
    if (_layout.scrollDirection == WBSpringBoardScrollDirectionVertical) {
        t = CGAffineTransformMakeScale(1, _pages);
    }
    _scrollView.contentSize = CGSizeApplyAffineTransform(_scrollView.bounds.size, t);
    
    _pageControl.numberOfPages = _pages;
    _pageControl.currentPage = 0;
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_layout.scrollDirection == WBSpringBoardScrollDirectionHorizontal) {
        _pageControl.currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    } else if (_layout.scrollDirection == WBSpringBoardScrollDirectionVertical) {
        _pageControl.currentPage = scrollView.contentOffset.y / scrollView.bounds.size.height;
    }
}

@end
