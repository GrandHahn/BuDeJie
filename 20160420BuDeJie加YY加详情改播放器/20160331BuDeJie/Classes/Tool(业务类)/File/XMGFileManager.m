//
//  XMGFileManager.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/8.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGFileManager.h"

@implementation XMGFileManager
// 获取文件夹尺寸
+ (NSInteger)getDirectorySize:(NSString *)directoryPath {
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 报错
        NSException *excep = [NSException exceptionWithName:@"pathError" reason:@"路径必须是文件夹路径" userInfo:nil];
        [excep raise];
    }
    // 所有文件路径
    NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
    // 遍历计算总文件大小
    NSInteger totalSize = 0;
    for (NSString *subPath in subPaths) {
        // 拼接
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        // 文件属性
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [attr fileSize];
        
        totalSize += size;
    }
    return totalSize;
}

+ (void)removeDirectoryData:(NSString *)directoryPath {
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 报错
        NSException *excep = [NSException exceptionWithName:@"pathError" reason:@"路径必须是文件夹路径" userInfo:nil];
        [excep raise];
    }
    // 当前目录下的文件名(一层)
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    // 遍历删除
    for (NSString *subPath in subPaths) {
        // 拼接路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        // 删除
        [mgr removeItemAtPath:filePath error:nil];
    }
}
@end
