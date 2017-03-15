//
//  WBViewController.m
//  SpringBoard
//
//  Created by LiJun on 03/06/2017.
//  Copyright (c) 2017 LiJun. All rights reserved.
//

#import "WBViewController.h"
#import <SpringBoard/SpringBoard.h>
#import "WBCustomerCell.h"
#import "WBCustomerCombinedCell.h"

@interface WBViewController () <WBSpringBoardViewDelegate, WBSpringBoardViewDataSource>

@property (weak, nonatomic) IBOutlet WBSpringBoardView *springBoardView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 70; i ++) {
        if (i == 2) {
            NSMutableArray *marr = [NSMutableArray array];
            for (int j = 0; j < 10; j ++) {
                [marr addObject:[NSString stringWithFormat:@"c%d", j]];
            }
            [_dataArray addObject:marr];
        }
        [_dataArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    _springBoardView.springBoardDelegate = self;
    _springBoardView.springBoardDataSource = self;
    _springBoardView.layout.insets = UIEdgeInsetsMake(20, 5, 30, 5);
    _springBoardView.layout.minimumHorizontalSpace = 5;
    _springBoardView.allowSingleItemCombinedCell = NO;
    
    _springBoardView.innerViewLayout.insets = UIEdgeInsetsMake(5, 5, 25, 5);
    _springBoardView.innerViewLayout.minimumHorizontalSpace = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WBSpringBoardViewDelegate Method

- (void)springBoardView:(WBSpringBoardView *)springBoardView clickItemAtIndex:(NSInteger)index
{
    NSString *data = _dataArray[index];
    NSLog(@"clicked data %@", data);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView clickSubItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex
{
    NSArray *superData = _dataArray[superIndex];
    NSString *data = superData[index];
    NSLog(@"clicked data %@", data);
}

#pragma mark - WBSpringBoardViewDataSource Method

- (NSInteger)numberOfItemsInSpringBoardView:(WBSpringBoardView *)springBoardView
{
    return _dataArray.count;
}

- (WBSpringBoardCell *)springBoardView:(WBSpringBoardView *)springBoardView cellForItemAtIndex:(NSInteger)index
{
    id data = _dataArray[index];
    
    WBSpringBoardCell *cell = nil;
    if ([data isKindOfClass:NSString.class]) {
        WBCustomerCell *customerCell = [[WBCustomerCell alloc] init];
        customerCell.label.text = (NSString *)data;
        
        cell = customerCell;
    } else if ([data isKindOfClass:NSArray.class]) {
        WBCustomerCombinedCell *customerCombinedCell = [[WBCustomerCombinedCell alloc] init];
        customerCombinedCell.label.text = [((NSArray *)data) componentsJoinedByString:@","];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSInteger i = 0; i < ((NSArray *)data).count; i ++) {
            [imageArray addObject:[UIImage imageNamed:@"file"]];
        }
        [customerCombinedCell refreshSubImages:imageArray];
        
        cell = customerCombinedCell;
    }
    
    return cell;
}

- (NSInteger)springBoardView:(WBSpringBoardView *)springBoardView numberOfSubItemsAtIndex:(NSInteger)index
{
    id superData = _dataArray[index];
    if ([superData isKindOfClass:NSArray.class]) {
        return ((NSArray *)superData).count;
    }
    return 0;
}

- (WBSpringBoardCell *)springBoardView:(WBSpringBoardView *)springBoard subCellForItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex
{
    WBSpringBoardCell *cell = nil;

    id superData = _dataArray[superIndex];
    if ([superData isKindOfClass:NSArray.class]) {
        NSArray *dataArr = superData;
        id data = dataArr[index];
        
        if ([data isKindOfClass:NSString.class]) {
            WBCustomerCell *customerCell = [[WBCustomerCell alloc] init];
            customerCell.label.text = (NSString *)data;
            
            cell = customerCell;
        } else if ([data isKindOfClass:NSArray.class]) {
            WBCustomerCombinedCell *customerCombinedCell = [[WBCustomerCombinedCell alloc] init];
            customerCombinedCell.label.text = [((NSArray *)data) componentsJoinedByString:@","];
            NSMutableArray *imageArray = [NSMutableArray array];
            for (NSInteger i = 0; i < ((NSArray *)data).count; i ++) {
                [imageArray addObject:[UIImage imageNamed:@"file"]];
            }
            [customerCombinedCell refreshSubImages:imageArray];
            
            cell = customerCombinedCell;
        }
    }
    
    return cell;
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    NSString *data = _dataArray[sourceIndex];
    [_dataArray removeObjectAtIndex:sourceIndex];
    [_dataArray insertObject:data atIndex:destinationIndex];
    
    NSLog(@"%@", _dataArray);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    NSString *sourceData = _dataArray[sourceIndex];
    id destinationData = _dataArray[destinationIndex];
    
    NSMutableArray *combinedData = [@[sourceData] mutableCopy];
    if ([destinationData isKindOfClass:[NSString class]]) {
        [combinedData addObject:destinationData];
    } else if ([destinationData isKindOfClass:[NSArray class]]) {
        [combinedData addObjectsFromArray:destinationData];
    }
    
    [_dataArray replaceObjectAtIndex:destinationIndex withObject:combinedData];
    [_dataArray removeObjectAtIndex:sourceIndex];
    
    NSLog(@"%@", _dataArray);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveSubItemAtIndex:(NSInteger)sourceIndex toSubIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex
{
    NSMutableArray *superDataArray = _dataArray[superIndex];
    
    NSString *data = superDataArray[sourceIndex];
    [superDataArray removeObjectAtIndex:sourceIndex];
    [superDataArray insertObject:data atIndex:destinationIndex];
    
    _dataArray[superIndex] = superDataArray;
    
    NSLog(@"%@", _dataArray);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveSubItemAtIndex:(NSInteger)sourceIndex toSuperIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex
{
    NSMutableArray *superDataArray = _dataArray[superIndex];
    NSString *subData = superDataArray[sourceIndex];
    [superDataArray removeObjectAtIndex:sourceIndex];

    _dataArray[superIndex] = superDataArray;
    [_dataArray insertObject:subData atIndex:destinationIndex];
    
    NSLog(@"%@", _dataArray);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView removeItemAtIndex:(NSInteger)index
{
    [_dataArray removeObjectAtIndex:index];
    
    NSLog(@"%@", _dataArray);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView combinedCell:(WBCustomerCombinedCell *)combinedCell changeLabel:(NSString *)newLabel
{
    NSLog(@"LABEL %@ Change to %@", combinedCell.label.text, newLabel);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView needRefreshCombinedCell:(WBCustomerCombinedCell *)combinedCell
{
    NSInteger index = [springBoardView indexForCell:combinedCell];
    NSArray *data = _dataArray[index];
    combinedCell.label.text = [((NSArray *)data) componentsJoinedByString:@","];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < ((NSArray *)data).count; i ++) {
        [imageArray addObject:[UIImage imageNamed:@"file"]];
    }
    [combinedCell refreshSubImages:imageArray];
}

@end
