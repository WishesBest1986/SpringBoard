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
#import "WBFileInfo.h"
#import "WBFolderInfo.h"

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
        WBFileInfo *fileInfo = [[WBFileInfo alloc] init];
        fileInfo.name = [NSString stringWithFormat:@"文件%d", i];
        fileInfo.iconName = [NSString stringWithFormat:@"%d", i];
        [_dataArray addObject:fileInfo];
        
        if (i == 2) {
            WBFolderInfo *folderInfo = [[WBFolderInfo alloc] init];
            folderInfo.name = [NSString stringWithFormat:@"文件夹%d", i];
            
            NSMutableArray *marr = [NSMutableArray array];
            for (int j = 0; j < 10; j ++) {
                WBFileInfo *fileInfo = [[WBFileInfo alloc] init];
                fileInfo.name = [NSString stringWithFormat:@"内文件%d", j];
                fileInfo.iconName = [NSString stringWithFormat:@"inner%d", j];
                [marr addObject:fileInfo];
            }
            folderInfo.fileArray = marr;
            [_dataArray addObject:folderInfo];
        }
    }
    
    _springBoardView.springBoardDelegate = self;
    _springBoardView.springBoardDataSource = self;
    _springBoardView.layout.itemSize = CGSizeMake(90, 90);
    _springBoardView.layout.insets = UIEdgeInsetsMake(20, 5, 30, 5);
    _springBoardView.layout.minimumHorizontalSpace = 20;
    _springBoardView.allowSingleItemCombinedCell = NO;
//    _springBoardView.layout.scrollDirection = WBSpringBoardScrollDirectionVertical;
    _springBoardView.hiddenOnePageIndicator = YES;
    
    _springBoardView.innerViewLayout.itemSize = CGSizeMake(90, 90);
    _springBoardView.innerViewLayout.insets = UIEdgeInsetsMake(5, 5, 25, 5);
    _springBoardView.innerViewLayout.minimumHorizontalSpace = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)modelChangedHandler
{
    NSLog(@"MODEL CHANGED, YOU CAN SAVE DATA HERE: %@", _dataArray);
}

#pragma mark - WBSpringBoardViewDelegate Method

- (void)springBoardView:(WBSpringBoardView *)springBoardView clickItemAtIndex:(NSInteger)index
{
    WBFileInfo *file = _dataArray[index];
    NSLog(@"clicked File %@", file.name);
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView clickSubItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex
{
    WBFolderInfo *folder = _dataArray[superIndex];
    WBFileInfo *file = folder.fileArray[index];
    NSLog(@"clicked File %@", file.name);
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
    if ([data isKindOfClass:WBFileInfo.class]) {
        WBFileInfo *file = data;
        WBCustomerCell *customerCell = [[WBCustomerCell alloc] init];
        customerCell.imageView.image = [UIImage imageNamed:file.iconName];
        customerCell.label.text = file.name;
        
        cell = customerCell;
    } else if ([data isKindOfClass:WBFolderInfo.class]) {
        WBFolderInfo *folder = data;
        WBCustomerCombinedCell *customerCombinedCell = [[WBCustomerCombinedCell alloc] init];
        customerCombinedCell.label.text = folder.name;
        [customerCombinedCell refreshSubImageNames:[folder fileIconNameArray]];
        
        cell = customerCombinedCell;
    }
//    //Change Image Size If you want
//    [cell setImageSize:CGSizeMake(100, 100)];
    
    return cell;
}

- (NSInteger)springBoardView:(WBSpringBoardView *)springBoardView numberOfSubItemsAtIndex:(NSInteger)index
{
    id superData = _dataArray[index];
    if ([superData isKindOfClass:WBFolderInfo.class]) {
        return ((WBFolderInfo *)superData).fileArray.count;
    }
    return 0;
}

- (WBSpringBoardCell *)springBoardView:(WBSpringBoardView *)springBoard subCellForItemAtIndex:(NSInteger)index withSuperIndex:(NSInteger)superIndex
{
    WBSpringBoardCell *cell = nil;

    id superData = _dataArray[superIndex];
    if ([superData isKindOfClass:WBFolderInfo.class]) {
        WBFolderInfo *folder = superData;
        id data = folder.fileArray[index];
        
        if ([data isKindOfClass:WBFileInfo.class]) {
            WBFileInfo *file = data;
            WBCustomerCell *customerCell = [[WBCustomerCell alloc] init];
            customerCell.imageView.image = [UIImage imageNamed:file.iconName];
            customerCell.label.text = file.name;
            
            cell = customerCell;
        }
    }
//    //Change Image Size If you want
//    [cell setImageSize:CGSizeMake(100, 100)];
    
    return cell;
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    id data = _dataArray[sourceIndex];
    [_dataArray removeObjectAtIndex:sourceIndex];
    [_dataArray insertObject:data atIndex:destinationIndex];
    
    [self modelChangedHandler];
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView combineItemAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    WBFileInfo *sourceData = _dataArray[sourceIndex];
    id destinationData = _dataArray[destinationIndex];
    
    WBFolderInfo *folder = [[WBFolderInfo alloc] init];
    if ([destinationData isKindOfClass:[WBFileInfo class]]) {
        folder.name = @"文件夹";
        folder.fileArray = @[destinationData, sourceData];
    } else if ([destinationData isKindOfClass:[WBFolderInfo class]]) {
        WBFolderInfo *oldFolder = destinationData;
        folder.name = oldFolder.name;
        folder.fileArray = [oldFolder.fileArray arrayByAddingObject:sourceData];
    }
    
    [_dataArray replaceObjectAtIndex:destinationIndex withObject:folder];
    [_dataArray removeObjectAtIndex:sourceIndex];
    
    [self modelChangedHandler];
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveSubItemAtIndex:(NSInteger)sourceIndex toSubIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex
{
    WBFolderInfo *folder = _dataArray[superIndex];
    NSMutableArray *mFileArray = [NSMutableArray arrayWithArray:folder.fileArray];
    
    WBFileInfo *data = mFileArray[sourceIndex];
    [mFileArray removeObjectAtIndex:sourceIndex];
    [mFileArray insertObject:data atIndex:destinationIndex];
    folder.fileArray = mFileArray;
    
//    _dataArray[superIndex] = superDataArray;
    
    [self modelChangedHandler];
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView moveSubItemAtIndex:(NSInteger)sourceIndex toSuperIndex:(NSInteger)destinationIndex withSuperIndex:(NSInteger)superIndex
{
    WBFolderInfo *folder = _dataArray[superIndex];
    WBFileInfo *file = folder.fileArray[sourceIndex];
    NSMutableArray *mFileArray = [NSMutableArray arrayWithArray:folder.fileArray];
    [mFileArray removeObjectAtIndex:sourceIndex];
    folder.fileArray = mFileArray;

//    _dataArray[superIndex] = superDataArray;
    [_dataArray insertObject:file atIndex:destinationIndex];
    
    [self modelChangedHandler];
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView removeItemAtIndex:(NSInteger)index
{
    [_dataArray removeObjectAtIndex:index];
    
    [self modelChangedHandler];
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView combinedCell:(WBCustomerCombinedCell *)combinedCell changeTitleFrom:(NSString *)originTitle to:(NSString *)currentTitle
{
    NSInteger index = [springBoardView indexForCell:combinedCell];
    WBFolderInfo *folder = _dataArray[index];
    folder.name = currentTitle;
    NSLog(@"should update data at index: %ld", index);
    
    NSLog(@"LABEL %@ Change to %@", originTitle, currentTitle);
    combinedCell.label.text = currentTitle;
    
    [self modelChangedHandler];
}

- (void)springBoardView:(WBSpringBoardView *)springBoardView needRefreshCombinedCell:(WBCustomerCombinedCell *)combinedCell
{
    NSInteger index = [springBoardView indexForCell:combinedCell];
    WBFolderInfo *folder = _dataArray[index];
    combinedCell.label.text = folder.name;
    [combinedCell refreshSubImageNames:[folder fileIconNameArray]];
}

@end
