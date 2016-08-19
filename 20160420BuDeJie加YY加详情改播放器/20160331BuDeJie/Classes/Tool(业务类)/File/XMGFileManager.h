//
//  XMGFileManager.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/8.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGFileManager : NSObject
/**得到路径（文件夹）下文件大小*/
+ (NSInteger)getDirectorySize:(NSString *)directoryPath;
/**清除路径（文件夹）下文件*/
+ (void)removeDirectoryData:(NSString *)directoryPath;
@end
