//
//  XMGSettingViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/3.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGSettingViewController.h"
#import "XMGFileManager.h"
#define cachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

static NSString * const ID = @"cell";


@interface XMGSettingViewController ()

@end

@implementation XMGSettingViewController

// 此段没用，暂时不要
//- (void)jump {
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"设置";
    
    // 此段没用，暂时不要
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jumpp" style:UIBarButtonItemStyleDone target:self action:@selector(jump)];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.textLabel.text = [self getFileSizeStr];
    
    return cell;
}

// 点击清理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 当前目录下的文件名
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:cachePath error:nil];
    // 遍历删除
    for (NSString *subPath in subPaths) {
        // 拼接路径
        NSString *filePath = [cachePath stringByAppendingPathComponent:subPath];
        // 删除
        [mgr removeItemAtPath:filePath error:nil];
    }
     */
    [XMGFileManager removeDirectoryData:cachePath];
    [self.tableView reloadData];
}

// 获取文件尺寸字符串
- (NSString *)getFileSizeStr {
    NSInteger totalSize = [XMGFileManager getDirectorySize:cachePath];
    NSString *str = @"清除缓存";
    str = [str stringByAppendingFormat:@"%zdB", totalSize];
    return str;
}

// 获取文件尺寸
- (NSInteger)getDirectorySize:(NSString *)directoryPath {
    NSFileManager *mgr = [NSFileManager defaultManager];
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
@end
