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

@interface WBViewController () <WBSpringBoardDelegate, WBSpringBoardDataSource>

@property (weak, nonatomic) IBOutlet WBSpringBoard *springBoard;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 70; i ++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    _springBoard.delegate = self;
    _springBoard.dataSource = self;
    _springBoard.layout.insets = UIEdgeInsetsMake(20, 5, 30, 5);
    _springBoard.layout.minimumHorizontalSpace = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WBSpringBoardDelegate Method

#pragma mark - WBSpringBoardDataSource Method

- (NSInteger)numberOfItemsInSpringBoard:(WBSpringBoard *)springBoard
{
    return _dataArray.count;
}

- (WBSpringBoardCell *)springBoard:(WBSpringBoard *)springBoard cellForItemAtIndex:(NSInteger)index
{
    id data = _dataArray[index];
    
    WBSpringBoardCell *cell = nil;
    if ([data isKindOfClass:NSString.class]) {
        WBCustomerCell *customerCell = [[WBCustomerCell alloc] init];
        customerCell.backgroundColor = [UIColor lightGrayColor];
        customerCell.label.text = (NSString *)data;
        
        cell = customerCell;
    } else if ([data isKindOfClass:NSArray.class]) {
        WBCustomerCombinedCell *customerCombinedCell = [[WBCustomerCombinedCell alloc] init];
        customerCombinedCell.backgroundColor = [UIColor darkGrayColor];
        customerCombinedCell.label.text = [((NSArray *)data) componentsJoinedByString:@","];
        
        cell = customerCombinedCell;
    }
    
    return cell;
}

- (void)springBoard:(WBSpringBoard *)springBoard moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    NSString *data = _dataArray[sourceIndex];
    [_dataArray removeObjectAtIndex:sourceIndex];
    [_dataArray insertObject:data atIndex:destinationIndex];
    
    NSLog(@"%@", _dataArray);
}

- (void)springBoard:(WBSpringBoard *)springBoard combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
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

@end
