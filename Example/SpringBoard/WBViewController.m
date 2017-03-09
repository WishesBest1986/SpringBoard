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

- (WBCustomerCell *)springBoard:(WBSpringBoard *)springBoard cellForItemAtIndex:(NSInteger)index
{
    WBCustomerCell *cell = [[WBCustomerCell alloc] init];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    cell.label.text = _dataArray[index];
    [cell.label sizeToFit];
    cell.label.center = cell.center;
    
    return cell;
}

- (void)springBoard:(WBSpringBoard *)springBoard moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    NSString *data = _dataArray[sourceIndex];
    [_dataArray removeObjectAtIndex:sourceIndex];
    [_dataArray insertObject:data atIndex:destinationIndex];
    
    NSLog(@"%@", _dataArray);
}

@end
