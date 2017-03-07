//
//  WBViewController.m
//  SpringBoard
//
//  Created by LiJun on 03/06/2017.
//  Copyright (c) 2017 LiJun. All rights reserved.
//

#import "WBViewController.h"
#import <SpringBoard/SpringBoard.h>

@interface WBViewController () <WBSpringBoardDelegate, WBSpringBoardDataSource>

@property (weak, nonatomic) IBOutlet WBSpringBoard *springBoard;

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _springBoard.delegate = self;
    _springBoard.dataSource = self;
    _springBoard.layout.insets = UIEdgeInsetsMake(20, 10, 30, 10);
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
    return 70;
}

- (__kindof WBSpringBoardCell *)springBoard:(WBSpringBoard *)springBoard cellForItemAtIndex:(NSInteger)index
{
    WBSpringBoardCell *cell = [[WBSpringBoardCell alloc] init];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

@end
