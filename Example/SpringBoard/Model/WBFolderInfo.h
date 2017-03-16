//
//  WBFolderInfo.h
//  SpringBoard
//
//  Created by LIJUN on 2017/3/16.
//  Copyright © 2017年 LiJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBFileInfo.h"

@interface WBFolderInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<WBFileInfo *> *fileArray;

- (NSArray<NSString *> *)fileNameArray;
- (NSArray<NSString *> *)fileIconNameArray;

@end
