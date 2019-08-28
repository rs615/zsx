//
//  SearchCarCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "SearchCarCell.h"


@interface SearchCarCell()

@property (weak, nonatomic) IBOutlet UILabel *licensePlateLabel;
@property (weak, nonatomic) IBOutlet UILabel *carOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *vehicleTypeLabel;

@end

@implementation SearchCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(CarInfoModel *)model
{
    _model = model;
    _licensePlateLabel.text = [NSString stringWithFormat:@"车牌：%@",model.mc!=nil?model.mc:@""];
    _carOwnerLabel.text = [NSString stringWithFormat:@"车主：%@",model.cz!=nil?model.cz:@""];
    _phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",model.mobile!=nil?model.mobile:@""];
    _vehicleTypeLabel.text = [NSString stringWithFormat:@"车型： %@",model.cx!=nil?model.cx:@""];
}



@end
