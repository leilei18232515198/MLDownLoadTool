//
//  MLDownManager.m
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "MLDownManager.h"
@implementation MLDownManager
static MLDownManager *manager = nil;

+ (instancetype)managerInstance{

    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        manager = [[MLDownManager alloc] init];
        manager.itemsArray = [NSMutableArray array];
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
    [self.itemsArray addObject:item];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    /* 下载路径 */
    NSURL *url = [NSURL URLWithString:item.linker];
    NSString *filePath = [item getFilePath];
    item.stream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 3.1 若之前下载过 , 则在 HTTP 请求头部加入 Range
        // 获取已下载文件的 size
     unsigned long long downloadedBytes = [self fileSizeAtPath:filePath];
        // 验证是否下载过文件
        if (downloadedBytes > 0) {
            // 若下载过 , 断点续传的时候修改 HTTP 头部部分的 Range
            NSString *requestRange =
            [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [request setValue:requestRange forHTTPHeaderField:@"Range"];
            }
    }
    item.task = [session dataTaskWithRequest:request];
    [item.task resume];
}

+ (void)stopDownLoadWithItem:(MLItemModel *)item{
    [DownloadManager stopDownLoadData:item];
}

- (void)stopDownLoadData:(MLItemModel *)item{
   
    [item.task suspend];
    item.status = Pause;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    MLItemModel *taskItem;
    for (MLItemModel *item in self.itemsArray) {
        if ([item.task isEqual:dataTask]) {
            taskItem = item;
            break;
        }
    }
    // 打开流
    [taskItem.stream open];
    // 获得服务器这次请求 返回数据的总长度
    NSString *filePath = [taskItem getFilePath];
    NSUInteger receivedSize = [self fileSizeAtPath:filePath];
    taskItem.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue]+receivedSize;
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到服务器返回的数据，一直回调，直到下载完成,暂停时会停止调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    MLItemModel *taskItem;
    for (MLItemModel *item in self.itemsArray) {
        if ([item.task isEqual:dataTask]) {
            taskItem = item;
            break;
        }
    }
    // 写入数据
    [taskItem.stream write:data.bytes maxLength:data.length];
    // 下载进度
    NSString *filePath = [taskItem getFilePath];
    NSUInteger receivedSize = [self fileSizeAtPath:filePath];
    double progress = 1.0 * receivedSize / taskItem.totalLength;
    taskItem.percent = progress*100;
    if (taskItem.percent >= 100) {
        [taskItem cancelTask];
        return;
    }
    if(taskItem.itemDelegate&&[taskItem.itemDelegate respondsToSelector:@selector(downLoadProgressWithid:)]){
        [taskItem.itemDelegate downLoadProgressWithid:taskItem.linker];
    }

}

// 当任务下载完成或失败会调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    MLItemModel *taskItem;
    for (MLItemModel *item in self.itemsArray) {
        if ([item.session isEqual:session]) {
            taskItem = item;
            break;
        }
    }
    // 下载成功 关闭流，取消任务
    [taskItem cancelTask];
}


-(long long) fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
}

@end
