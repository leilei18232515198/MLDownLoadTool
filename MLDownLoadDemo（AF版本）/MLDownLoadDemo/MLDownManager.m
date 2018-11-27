//
//  MLDownManager.m
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "MLDownManager.h"
#import <AFNetworking.h>
@implementation MLDownManager
static MLDownManager *manager = nil;

+ (instancetype)managerInstance{

    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        manager = [[MLDownManager alloc] init];
    });
    return manager;
}

+ (void)startDownWithItem:(MLItemModel *)item{
    item.status = DownLoad;
    [DownloadManager downLoadData:item];
}

- (void)downLoadData:(MLItemModel *)item{
    if(item.task){
        [item.task resume];
        return;
    }
    /* 创建网络下载对象 */
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];  
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:item.linker];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *filePath = [item getFilePath];
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", [item fileSizeAtPath:filePath]];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
        NSInteger downLoadProgress = downloadProgress.fractionCompleted * 100;
        item.percent = downLoadProgress;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(item.itemDelegate&&[item.itemDelegate respondsToSelector:@selector(downLoadProgressWithid:)]){
                [item.itemDelegate downLoadProgressWithid:item.linker];
            }

        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(item.percent < 100) return ;
        item.status = Complete;
        [item.task cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(item.itemDelegate&&[item.itemDelegate respondsToSelector:@selector(downLoadProgressWithid:)]){
                [item.itemDelegate downLoadProgressWithid:item.linker];
            }
            
        });
        NSLog(@"下载完成");
    }];
    item.task = downloadTask;
    [downloadTask resume];
    
}

+ (void)stopDownLoadWithItem:(MLItemModel *)item{
    [DownloadManager stopDownLoadData:item];
}

- (void)stopDownLoadData:(MLItemModel *)item{
    [item.task suspend];
    item.status = Pause;
}


@end
