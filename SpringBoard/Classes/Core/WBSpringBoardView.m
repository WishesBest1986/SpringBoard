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

#pragma mark - Init & Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationKeyInnerViewEditChanged
                                                  object:nil];
}

#pragma mark - Override Method

- (void)commonInit
{
    [super commonInit];
    
    self.allowCombination = YES;
    self.allowOverlapCombination = NO;
    self.allowSingleItemCombinedCell = YES;

    self.springBoardComponentDelegate = self;
    self.springBoardComponentDataSource = self;
    
    self.innerViewLayout = [[WBSpringBoardLayout alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(innerViewEditChangedNotification:)
                                                 name:kNotificationKeyInnerViewEditChanged
                                               object:nil];
}

- (void)clickSpringBoardCell:(WBSpringBoardCell *)cell
{
    if ([cell isKindOfClass:WBSpringBoardCombinedCell.class]) {
        [self showCombinedCellsForCell:((WBSpringBoardCombinedCell *)cell)];
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

#pragma mark - Private Method

- (void)showCombinedCellsForCell:(WBSpringBoardCombinedCell *)cell
{
    @WBWeakObj(self);
    NSInteger index = [self indexForCell:cell];
    
    WBSpringBoardInnerView *innerView = [[WBSpringBoardInnerView alloc] init];
    innerView.superIndex = index;
    innerView.superCell = cell;
    innerView.springBoardComponentDelegate = self;
    innerView.springBoardComponentDataSource = self;
    innerView.springBoardInnerViewOutsideGestureDelegate = self;
    innerView.layout = _innerViewLayout;
    innerView.hiddenOnePageIndicator = self.hiddenOnePageIndicator;
    
    WBSpringBoardPopupView *popupView = [[WBSpringBoardPopupView alloc] init];
    [popupView.contentView addSubview:innerView];
    popupView.originTitle = cell.label.text;
    popupView.isEdit = self.isEdit;
    innerView.popupView = popupView;
    popupView.maskClickBlock = ^(WBSpringBoardPopupView *popupView) {
        NSString *originTitle = popupView.originTitle;
        NSString *currentTitle = popupView.currentTitle;
        if ((currentTitle && currentTitle.length > 0) && ![originTitle isEqualToString:currentTitle]) {
            if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:combinedCell:changeTitleFrom:to:)]) {
                [_springBoardDataSource springBoardView:weakself combinedCell:cell changeTitleFrom:originTitle to:currentTitle];
            }
        }
        
        [popupView hideWithAnimated:YES removeFromSuperView:YES];
    };
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

- (void)innerViewEditChangedNotification:(NSNotification *)notification
{
    BOOL edit = [notification.object boolValue];
    self.isEdit = edit;
}

- (void)afterGestureCheckSpringBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView
{
    @WBWeakObj(self);
    WBSpringBoardCombinedCell *combinedCell = springBoardInnerView.superCell;
    if ([self verifyNecessityOfCombinedCell:combinedCell]) {
        // check whether title changed
        WBSpringBoardPopupView *popupView = springBoardInnerView.popupView;
        NSString *originTitle = popupView.originTitle;
        NSString *currentTitle = popupView.currentTitle;
        if ((currentTitle && currentTitle.length > 0) && ![originTitle isEqualToString:currentTitle]) {
            if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:combinedCell:changeTitleFrom:to:)]) {
                [_springBoardDataSource springBoardView:weakself combinedCell:combinedCell changeTitleFrom:originTitle to:currentTitle];
            }
        }
    }
}

- (BOOL)verifyNecessityOfCombinedCell:(WBSpringBoardCombinedCell *)combinedCell
{
    @WBWeakObj(self);
    BOOL necessary = YES;
    NSInteger superIndex = [self indexForCell:combinedCell];
    
    NSInteger numberOfItems = 0;
    if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:numberOfSubItemsAtIndex:)]) {
        numberOfItems = [_springBoardDataSource springBoardView:weakself numberOfSubItemsAtIndex:superIndex];
    }
    
    if (numberOfItems <= 0) {
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:removeItemAtIndex:)]) {
            [_springBoardDataSource springBoardView:weakself removeItemAtIndex:superIndex];
        }
        
        [combinedCell removeFromSuperview];
        [self.contentCellArray removeObjectAtIndex:superIndex];
        [self recomputePageAndSortContentCellsWithAnimated:YES];
        
        necessary = NO;
    }
    
    if (numberOfItems == 1 && !_allowSingleItemCombinedCell) {
        WBSpringBoardCell *cell = [[WBSpringBoardCell alloc] init];
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:subCellForItemAtIndex:withSuperIndex:)]) {
            cell = [_springBoardDataSource springBoardView:weakself subCellForItemAtIndex:0 withSuperIndex:superIndex];
            cell.isEdit = self.isEdit;
        }
        
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:moveSubItemAtIndex:toSubIndex:withSuperIndex:)]) {
            [_springBoardDataSource springBoardView:weakself moveSubItemAtIndex:0 toSuperIndex:superIndex withSuperIndex:superIndex];
        }
        
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:removeItemAtIndex:)]) {
            [_springBoardDataSource springBoardView:weakself removeItemAtIndex:(superIndex + 1)];
        }
        
        cell.frame = combinedCell.frame;
        [combinedCell removeFromSuperview];
        [self.scrollView addSubview:cell];
        [self.contentCellArray replaceObjectAtIndex:superIndex withObject:cell];
        cell.delegate = self;
        cell.longGestureDelegate = self;
        
        [self recomputePageAndSortContentCellsWithAnimated:YES];
        
        necessary = NO;
    }
    
    return necessary;
}

#pragma mark - WBSpringBoardComponentDelegate Method

- (void)springBoardComponent:(WBSpringBoardComponent *)springBoardComponent clickItemAtIndex:(NSInteger)index
{
    @WBWeakObj(self);
    if ([springBoardComponent isKindOfClass:WBSpringBoardView.class]) {
        if (_springBoardDelegate && [_springBoardDelegate respondsToSelector:@selector(springBoardView:clickItemAtIndex:)]) {
            [_springBoardDelegate springBoardView:weakself clickItemAtIndex:index];
        }
    } else if ([springBoardComponent isKindOfClass:WBSpringBoardInnerView.class]) {
        if (_springBoardDelegate && [_springBoardDelegate respondsToSelector:@selector(springBoardView:clickSubItemAtIndex:withSuperIndex:)]) {
            NSInteger superIndex = ((WBSpringBoardInnerView *)springBoardComponent).superIndex;
            [_springBoardDelegate springBoardView:weakself clickSubItemAtIndex:index withSuperIndex:superIndex];
        }
    }
}

#pragma mark - WBSpringBoardComponentDataSource Method

- (NSInteger)numberOfItemsInSpringBoardComponent:(WBSpringBoardComponent *)springBoardComponent
{
    @WBWeakObj(self);
    if ([springBoardComponent isKindOfClass:WBSpringBoardView.class]) {
        if (_springBoardDataSource) {
            NSAssert([_springBoardDataSource respondsToSelector:@selector(numberOfItemsInSpringBoardView:)], @"@selector(numberOfItemsInSpringBoardView:) must be implemented");
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
        if (_springBoardDataSource) {
            NSAssert([_springBoardDataSource respondsToSelector:@selector(springBoardView:cellForItemAtIndex:)], @"@selector(springBoardView:cellForItemAtIndex:) must be implemented");
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
        WBSpringBoardInnerView *innerView = (WBSpringBoardInnerView *)springBoardComponent;
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:moveSubItemAtIndex:toSubIndex:withSuperIndex:)]) {
            NSInteger superIndex = innerView.superIndex;
            [_springBoardDataSource springBoardView:weakself moveSubItemAtIndex:sourceIndex toSubIndex:destinationIndex withSuperIndex:superIndex];
        }
        
        if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:needRefreshCombinedCell:)]) {
            [_springBoardDataSource springBoardView:weakself needRefreshCombinedCell:innerView.superCell];
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
    
    if (_springBoardDataSource && [_springBoardDataSource respondsToSelector:@selector(springBoardView:needRefreshCombinedCell:)]) {
        [_springBoardDataSource springBoardView:weakself needRefreshCombinedCell:springBoardInnerView.superCell];
    }
    
    [self recomputePageAndSortContentCellsWithAnimated:YES];
}

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureMove:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    [super springBoardCell:cell longGestureStateMove:gesture];
}

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureEnd:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    [super springBoardCell:cell longGestureStateEnd:gesture];
    
    // ----- 2017-04-28 modify begin -----
    // fix drag out of combineCell then drag into this combineCell again, crash bug.
    
    // In this condition, method [super springBoardCell:longGestureStateEnd:] will replace original combineCell(springBoarderInnerView.superCell), then springBoarderInnerView.superCell no longer contained by self.contentCellArray
    if (![self.contentCellArray containsObject:springBoardInnerView.superCell]) {
        springBoardInnerView.superCell = [self.contentCellArray objectAtIndex:springBoardInnerView.superIndex];
    }
    // ----- 2017-04-28 modify end -----
    
    cell.delegate = self;
    cell.longGestureDelegate = self;
    [self afterGestureCheckSpringBoardInnerView:springBoardInnerView];
}

- (void)springBoardInnerView:(WBSpringBoardInnerView *)springBoardInnerView outsideGestureCancel:(UILongPressGestureRecognizer *)gesture fromCell:(WBSpringBoardCell *)cell
{
    [super springBoardCell:cell longGestureStateCancel:gesture];
    
    cell.delegate = self;
    cell.longGestureDelegate = self;
    [self afterGestureCheckSpringBoardInnerView:springBoardInnerView];
}

@end
