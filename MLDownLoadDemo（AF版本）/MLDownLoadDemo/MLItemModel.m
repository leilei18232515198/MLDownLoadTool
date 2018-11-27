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

@end
