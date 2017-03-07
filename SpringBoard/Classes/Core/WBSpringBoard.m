//
//  WBSpringBoard.m
//  Pods
//
//  Created by LIJUN on 2017/3/7.
//
//

#import "WBSpringBoard.h"
#import "WBSpringBoardLayout.h"
#import "WBSpringBoardCell.h"
#import "UIView+Layout.h"
#import "WBSpringBoardDefines.h"

@interface WBSpringBoard () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger numberOfItems;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger colsPerPage;
@property (nonatomic, assign) NSInteger rowsPerPage;

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
    
    [self reloadData];
}

- (void)asyncLayoutSubviews
{
    [self computePages];
    
    CGSize scrollViewSize = _scrollView.bounds.size;

    
    
    CGAffineTransform t = CGAffineTransformMakeScale(_pages, 1);
    if (_layout.scrollDirection == WBSpringBoardScrollDirectionVertical) {
        t = CGAffineTransformMakeScale(1, _pages);
    }
    _scrollView.contentSize = CGSizeApplyAffineTransform(scrollViewSize, t);
    
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
        [self asyncLayoutSubviews];
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
