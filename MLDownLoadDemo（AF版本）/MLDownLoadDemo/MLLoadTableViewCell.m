//
//  MLLoadTableViewCell.m
//  MLDownLoadDemo
//
//  Created by 268Edu on 2018/11/1.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "MLLoadTableViewCell.h"

@interface MLLoadTableViewCell()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *percentLabel;
@end
@implementation MLLoadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self configureCellview];
    }
    return self;
}

- (void)configureCellview{
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(self.contentView.frame))];
        [self.contentView addSubview:label];
        label;
    });

    self.percentLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)-100-15, 0, 100, CGRectGetHeight(self.contentView.frame))];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor magentaColor];
        [self.contentView addSubview:label];
        label;
    });

}


- (void)setItem:(MLItemModel *)item{
    _item = item;
    self.nameLabel.text = _item.name;
    self.percentLabel.text = [NSString stringWithFormat:@"%ld%%",_item.percent];
}
@end
