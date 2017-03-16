//
//  WBFolderInfo.m
//  SpringBoard
//
//  Created by LIJUN on 2017/3/16.
//  Copyright © 2017年 LiJun. All rights reserved.
//

#import "WBFolderInfo.h"

@implementation WBFolderInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray<NSString *> *)fileNameArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (WBFileInfo *file in _fileArray) {
        [nameArray addObject:file.name ? file.name : @""];
    }
    return nameArray;
}

- (NSArray<NSString *> *)fileIconNameArray
{
    NSMutableArray *iconNameArray = [NSMutableArray array];
    for (WBFileInfo *file in _fileArray) {
        [iconNameArray addObject:file.iconName ? file.iconName : @""];
    }
    return iconNameArray;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[FOLDER]%@ %@", _name, [[self fileArray] componentsJoinedByString:@","]];
}

@end
