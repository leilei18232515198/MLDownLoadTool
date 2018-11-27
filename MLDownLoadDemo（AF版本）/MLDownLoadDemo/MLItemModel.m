//
//  MLItemModel.m
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "MLItemModel.h"

@implementation MLItemModel

- (NSString *)getFilePath{
    NSURL *url = [NSURL URLWithString:self.linker];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",self.name,url.lastPathComponent]];
    return filePath;
}

-(long long) fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
}

- (void)setDataTaskRequest{
    __weak typeof(self) weakSelf = self;
    [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        NSLog(@"NSURLSessionResponseDisposition");
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        NSString *filePath = [weakSelf getFilePath];
        weakSelf.currentLength = [weakSelf fileSizeAtPath:filePath];
        weakSelf.totalLength = response.expectedContentLength + weakSelf.currentLength;
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:filePath]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:filePath contents:nil attributes:nil];
        }
        weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
}

- (void)setDataTaskReceive{
     __weak typeof(self) weakSelf = self;
    [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        NSLog(@"setDataTaskDidReceiveDataBlock");
        
        // 指定数据的写入位置 -- 文件内容的最后面
        [weakSelf.fileHandle seekToEndOfFile];
        // 向沙盒写入数据
        [weakSelf.fileHandle writeData:data];
        // 拼接文件总长度
        weakSelf.currentLength += data.length;
        // 获取主线程，不然无法正确显示进度。
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            // 下载进度
            double progress = 1.0 * weakSelf.currentLength / weakSelf.totalLength;
            weakSelf.percent =  100*progress;
            if(weakSelf.itemDelegate&&[weakSelf.itemDelegate respondsToSelector:@selector(downLoadProgressWithid:)]){
                [weakSelf.itemDelegate downLoadProgressWithid:weakSelf.linker];
            }
        }];
    }];
}
@end
