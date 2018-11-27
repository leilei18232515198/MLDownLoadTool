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

- (void)cancelTask{
    [self.stream close];
    self.stream = nil;
    [self.task cancel];
    self.status = Complete;
    [self.task cancel];
    if(self.itemDelegate&&[self.itemDelegate respondsToSelector:@selector(downLoadProgressWithid:)]){
        [self.itemDelegate downLoadProgressWithid:self.linker];
    }

}
@end
