//
//  MLItemModel.h
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLEnumerHeader.h"
#import <AFNetworking.h>
@protocol itemDelegate<NSObject>
- (void)downLoadProgressWithid:(NSString *)downUrlId;
@end
@interface MLItemModel : NSObject
@property NSString *linker;
@property NSString *name;
@property NSInteger percent;
@property downLoadStatus status;
@property NSURLSessionDataTask *task;
@property AFURLSessionManager *manager;
@property NSFileHandle *fileHandle;
@property NSInteger currentLength;
@property (nonatomic , assign) NSInteger totalLength;
@property id<itemDelegate> itemDelegate;

- (NSString *)getFilePath;
-(long long) fileSizeAtPath:(NSString*)filePath;
- (void)setDataTaskRequest;
- (void)setDataTaskReceive;
@end
