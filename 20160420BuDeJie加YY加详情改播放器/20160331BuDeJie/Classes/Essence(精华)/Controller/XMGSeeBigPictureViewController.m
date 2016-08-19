//
//  XMGSeeBigPictureViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/16.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGSeeBigPictureViewController.h"
#import "XMGTopicItem.h"
#import <Photos/Photos.h>
@interface XMGSeeBigPictureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation XMGSeeBigPictureViewController


- (void)viewDidLoad {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];
    [self.view insertSubview:scrollView atIndex:0];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.item.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image == nil) return;
    }];
    
    imageView.xmg_width = scrollView.xmg_width;
    imageView.xmg_x = 0;
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 高度
    imageView.xmg_height = imageView.xmg_width / self.item.width * self.item.height;
    
    // 位置
    if (imageView.xmg_height >= XMGScreenH) {
        // 长图
        imageView.xmg_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.xmg_height);
    } else {
        imageView.xmg_centerY = scrollView.xmg_height / 2;
    }
    
    // 缩放
    CGFloat maxScale = self.item.width / imageView.xmg_width;
    if (maxScale > 1.0) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
////    self.imageView.xmg_centerY = XMGScreenH * 0.5;
////    self.imageView.xmg_centerX = XMGScreenW *0.5;
//}
//


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PHFetchResult<PHAsset *> *)createdAssets {
    // 1.添加图片到相机胶卷
    __block NSString *createdAssetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    // 取得图片
    PHFetchResult<PHAsset *> *createdAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
    return createdAssets;
}

- (PHAssetCollection *)createdCollection {
    // 2.创建自定义相册
    // 相册名
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    // 取所有相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历查找是否已经有创建同名相册
    PHAssetCollection *createdCollection = nil;
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createdCollection = collection;
        }
    }
    
    // 还没有创建过相册
    if (!createdCollection) {
        __block NSString *createdAssetCollectionId = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAssetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:nil];
        // 取得相册
        createdCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdAssetCollectionId] options:nil].firstObject;
    }
    return createdCollection;
}

- (void)saveImageIntoAlbum {
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    /*
     reason: 'This method can only be called from inside of -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:]'
     */
    
    // 1.添加图片到相机胶卷
    // 取得图片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    
    // 2.创建自定义相册
    // 取得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    
    // 无值则返回
    if (createdAssets == nil || createdCollection == nil) {
        NSLog(@"fail");
        return;
    }
    
    // 3.图片添加到自定义相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request =[PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 结果
    if (error) {
        NSLog(@"fail");
    } else {
        NSLog(@"success");
    }
}

- (IBAction)save:(id)sender {
    // 处理授权
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    [self saveImageIntoAlbum];
                    break;
                case PHAuthorizationStatusDenied:
                    if (oldStatus == PHAuthorizationStatusNotDetermined) {
                        return;
                    }
                    NSLog(@"请允许访问相册");
                    break;
                case PHAuthorizationStatusRestricted:
                    NSLog(@"系统原因，无法访问");
                    break;
                default:
                    break;
            }
        });
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"fail");
    } else {
        NSLog(@"success");
    }
}

@end
