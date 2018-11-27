//
//  MLDownManager.h
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLItemModel.h"
#import "MLEnumerHeader.h"
#define DownloadManager [MLDownManager managerInstance]

@interface MLDownManager : NSObject<NSURLSessionDataDelegate>
@property (nonatomic,strong)MLItemModel *item;
@property (nonatomic,strong)NSMutableArray *itemsArray;
+ (instancetype)managerInstance;
+ (void)startDownWithItem:(MLItemModel *)item;
+ (void)stopDownLoadWithItem:(MLItemModel *)item;
@end
