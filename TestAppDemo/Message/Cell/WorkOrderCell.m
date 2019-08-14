//
//  WorkOrderCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/14.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "WorkOrderCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"

@interface WorkOrderCell()

@property (strong, nonatomic) UILabel *gdhLabel;//工单号
@property (strong, nonatomic) UILabel *enterDateLabel;//进厂日期
@property (strong, nonatomic) UILabel *cpLabel;//车牌号
@property (strong, nonatomic) UILabel *wxgzLabel;//工种
@property (strong, nonatomic) UILabel *moneyLabel;//金额

@end

@implementation WorkOrderCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_WorkOrderCell];
    if(cell==nil){
        cell = [[WorkOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_WorkOrderCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _gdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
        _enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
        _cpLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5*2,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
        _wxgzLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5*3,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5*4,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
      
        _gdhLabel.numberOfLines = 2;
        _gdhLabel.textAlignment = NSTextAlignmentCenter;
        [_gdhLabel setFont:Font(12*PXSCALEH)];

        [_enterDateLabel setFont:Font(12*PXSCALEH)];
        _enterDateLabel.numberOfLines = 2;
        _enterDateLabel.textAlignment = NSTextAlignmentCenter;

        [_cpLabel setFont:Font(12*PXSCALEH)];
        _cpLabel.numberOfLines = 2;
        _cpLabel.textAlignment = NSTextAlignmentCenter;

        [_wxgzLabel setFont:Font(12*PXSCALEH)];
        _wxgzLabel.numberOfLines = 2;
        _wxgzLabel.textAlignment = NSTextAlignmentCenter;

        [_moneyLabel setFont:Font(12*PXSCALEH)];
        _moneyLabel.numberOfLines = 2;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_gdhLabel];
        [self.contentView addSubview:_enterDateLabel];
        [self.contentView addSubview:_cpLabel];
        [self.contentView addSubview:_wxgzLabel];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    _gdhLabel.text = model.jsd_id;
    _enterDateLabel.text = model.jc_date;
    _cpLabel.text = model.cp;
    _wxgzLabel.text = model.wxgz_collect;
    _moneyLabel.text = model.zje;

}

@end
