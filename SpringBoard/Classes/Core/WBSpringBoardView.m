//
//  WBSpringBoardView.m
//  Pods
//
//  Created by LIJUN on 2017/3/14.
//
//

#import "WBSpringBoardView.h"
#import "WBSpringBoardComponent_Private.h"
#import "WBSpringBoardInnerView.h"
#import "WBSpringBoardPopupView.h"

@interface WBSpringBoardView ( ) <WBSpringBoardComponentDelegate, WBSpringBoardComponentDataSource, WBSpringBoardInnerViewOutsideGestureDelegate>

@end

@implementation WBSpringBoardView

#pragma mark - Override Method

- (void)commonInit
{
    [super commonInit];
    
    self.springBoardComponentDelegate = self;
    self.springBoardComponentDataSource = self;
    
    self.innerViewLayout = [[WBSpringBoardLayout alloc] init];
}

- (void)clickSpringBoardCell:(WBSpringBoardCell *)cell
{
    if ([cell isKindOfClass:WBSpringBoardCombinedCell.class]) {
        [self showCombinedCellsForCell:cell];
    } else {
        [super clickSpringBoardCell:cell];
    }
}

#pragma mark - Setter & Getter

- (void)setSpringBoardDataSource:(id<WBSpringBoardViewDataSource>)springBoardDataSource
{
    _springBoardDataSource = springBoardDataSource;
    
    [self reloadData];
}

#pragma mark - Public Method

#pragma mark - Private Method

- (void)showCombinedCellsForCell:(WBSpringBoardCell *)cell
{
    @WBWeakObj(self);
    NSInteger index = [self indexForCell:cell];
    
    WBSpringBoardInnerView *innerView = [[WBSpringBoardInnerView alloc] init];
    innerView.superIndex = index;
    innerView.springBoardComponentDelegate = self;
    innerView.springBoardComponentDataSource = self;
    innerView.springBoardInnerViewOutsideGestureDelegate = self;
    innerView.layout = _innerViewLayout;
    
    WBSpringBoardPopupView *popupView = [[WBSpringBoardPopupView alloc] init];
    [popupView.contentView addSubview:innerView];
    innerView.popupView = popupView;
    [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(innerView.superview);
    }];
    [kAppKeyWindow addSubview:popupView];
    
    popupView.alpha = 0.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        popupView.alpha = 1.0;
        [popupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(popupView.superview);
        }];
    } completion:^(BOOL finished) {
        innerView.isEdit = weakself.isEdit;
    }];
}

#pragma mark - WBSpringBoardComponentDelegate Method

- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent clickItemAtIndex:(NSInteger)index
{
    @WBWeakObj(self);
    if (_springBoardDelegate && [_springBoardDelegate respondsToSelector:@selector(springBoardView:clickItemAtIndex:)]) {
        [_springBoardDelegate springBoardView:weakself clickItemAtIndex:index];
    }
}

#pragma mark - WBSpringBoardComponentDataSource Method

- (NSInteger)numberOfItemsInSpringBoardComponent:(WBSpringBoardComponent *)springBoardComponent
{
    @WBWeakObj(self);
    if ([springBoardComponent isKindOfClass:WBSpringBoardView.class]) {
        if (_springBoardDataSource) {
            return [_springBoardDataSource numberOfItemsInSpringBoardView:weakself];
        }
    } else if ([springBoardComponent isKindOfClass:WBSpringBoardInnerView.class]) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:numberOfSubItemsAtIndex:)]) {
            NSInteger superIndex = ((WBSpringBoardInnerView *)springBoardComponent).superIndex;
            return [_springBoardDataSource springBoardView:weakself numberOfSubItemsAtIndex:superIndex];
        }
    }
    return 0;
}

- (__kindof WBSpringBoardCell *)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent cellForItemAtIndex:(NSInteger)index
{
    @WBWeakObj(self);
    if ([springBoardComponent isKindOfClass:WBSpringBoardView.class]) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:cellForItemAtIndex:)]) {
            return [_springBoardDataSource springBoardView:weakself cellForItemAtIndex:index];
        }
    } else if ([springBoardComponent isKindOfClass:WBSpringBoardInnerView.class]) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:subCellForItemAtIndex:withSuperIndex:)]) {
            NSInteger superIndex = ((WBSpringBoardInnerView *)springBoardComponent).superIndex;
            return [_springBoardDataSource springBoardView:weakself subCellForItemAtIndex:index withSuperIndex:superIndex];
        }
    }
    return nil;
}

- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    @WBWeakObj(self);
    if ([springBoardComponent isKindOfClass:WBSpringBoardView.class]) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:moveItemAtIndex:toIndex:)]) {
            [_springBoardDataSource springBoardView:weakself moveItemAtIndex:sourceIndex toIndex:destinationIndex];
        }
    } else if ([springBoardComponent isKindOfClass:WBSpringBoardInnerView.class]) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:moveSubItemAtIndex:toSubIndex:withSuperIndex:)]) {
            NSInteger superIndex = ((WBSpringBoardInnerView *)springBoardComponent).superIndex;
            return [_springBoardDataSource springBoardView:weakself moveSubItemAtIndex:sourceIndex toSubIndex:destinationIndex withSuperIndex:superIndex];
        }
    }
}

- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    @WBWeakObj(self);
    if ([springBoardComponent isKindOfClass:WBSpringBoardView.class]) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:combineItemAtIndex:toIndex:)]) {
            [_springBoardDataSource springBoardView:weakself combineItemAtIndex:sourceIndex toIndex:destinationIndex];
        }
    }
}

#pragma mark - WBSpringBoardInnerViewOutsideGestureDelegate Method

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureBegin:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    @WBWeakObj(self);
    self.isDrag = YES;
    self.dragFromIndex = 0;
    
    if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:moveSubItemAtIndex:toSubIndex:withSuperIndex:)]) {
        [_springBoardDataSource springBoardView:weakself moveSubItemAtIndex:[springBoardInnerView indexForCell:cell] toSuperIndex:0 withSuperIndex:springBoardInnerView.superIndex];
    }
    
    [self.scrollView addSubview:cell];
    [self.contentCellArray insertObject:cell atIndex:0];
    
    [self recomputePageAndSortContentCellsWithAnimated:YES];
}

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureMove:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    [super springBoardCell:cell longGestureStateMove:gesture];
}

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureEnd:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    [super springBoardCell:cell longGestureStateEnd:gesture];
    
    cell.delegate = self;
    cell.longGestureDelegate = self;
}

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureCancel:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    [super springBoardCell:cell longGestureStateCancel:gesture];
    
    cell.delegate = self;
    cell.longGestureDelegate = self;
}

@end
