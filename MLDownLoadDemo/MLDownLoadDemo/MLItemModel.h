//
//  MLItemModel.h
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLEnumerHeader.h"
@protocol itemDelegate<NSObject>
- (void)downLoadProgressWithid:(NSString *)downUrlId;
@end
@interface MLItemModel : NSObject
@property NSString *linker;
@property NSString *name;
@property NSInteger percent;
@property downLoadStatus status;
@property NSURLSessionDownloadTask* task;
@property id<itemDelegate> itemDelegate;

@end
