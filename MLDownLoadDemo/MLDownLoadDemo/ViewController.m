//
//  ViewController.m
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "ViewController.h"
#import "MLItemModel.h"
#import "MLDownManager.h"
#import "MLLoadTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,itemDelegate>
@property (nonatomic,strong)NSMutableArray *loadArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController
//此版本未添加断点续传功能(待完善)
- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = @[@{@"linker":@"http://1253909364.vod2.myqcloud.com/ed921cd1vodtransgzp1253909364/ad7a01b57447398156413948364/v.f30.mp4",@"name":@"第一节"},@{@"linker":@"http://1253909364.vod2.myqcloud.com/ed921cd1vodtransgzp1253909364/f0fc04747447398156414529691/v.f30.mp4",@"name":@"第二节"}];
    
    self.loadArray = @[].mutableCopy;
    for (NSDictionary *dict in array) {
        MLItemModel *item = [[MLItemModel alloc]init];
        item.linker = dict[@"linker"];
        item.name = dict[@"name"];
        [self.loadArray addObject:item];
    }
   
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.loadArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(!cell){
        cell = [[MLLoadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    MLItemModel *item = self.loadArray[indexPath.row];
    item.itemDelegate = self;
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLItemModel *item = self.loadArray[indexPath.row];
    switch (item.status) {
            case Pause:
            [MLDownManager startDownWithItem:item];
            break;
            case DownLoad:
            [MLDownManager stopDownLoadWithItem:item];
            break;
            case Complete:
            
            break;
            case Error:
            
            break;
            
        default:
            break;
    }

}

- (void)downLoadProgressWithid:(NSString *)downUrlId{
    
    for (int i = 0; i < self.loadArray.count; i++) {
        MLItemModel *item = self.loadArray[i];
        if([item.linker isEqualToString:downUrlId]){
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            MLLoadTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
            cell.item = item;
            break;
        }
    }
}

- (UITableView *)tableView{
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height  = [UIScreen mainScreen].bounds.size.height;

    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, width, height-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
