//
//  HistoryListCell.m
//  TestAppDemo
//
//  Created by 涂程 on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HistoryListCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"

@interface HistoryListCell()

@property (strong, nonatomic) UILabel *gdhLabel;//工单号
@property (strong, nonatomic) UILabel *enterDateLabel;//进厂日期
@property (strong, nonatomic) UILabel *wxgzLabel;//工种
@property (strong, nonatomic) UILabel *moneyLabel;//金额

@end

@implementation HistoryListCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_WorkOrderCell];
    if(cell==nil){
        cell = [[HistoryListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_WorkOrderCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10,10,MainS_Width-20,2.5*40*PXSCALEH)];
        view.backgroundColor = SetColor(@"#E6E4E7", 1);
        
        _gdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5*PXSCALEH, MainS_Width, 40*PXSCALEH)];
        _enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5*PXSCALEH*5, MainS_Width, 40*PXSCALEH)];
        _wxgzLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5*PXSCALEH*9, MainS_Width, 40*PXSCALEH)];
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5*PXSCALEH*13, MainS_Width, 40*PXSCALEH)];
        
        _gdhLabel.numberOfLines = 2;
        _gdhLabel.textAlignment = NSTextAlignmentLeft;
        [_gdhLabel setFont:Font(12*PXSCALEH)];
        
        [_enterDateLabel setFont:Font(12*PXSCALEH)];
        _enterDateLabel.numberOfLines = 2;
        _enterDateLabel.textAlignment = NSTextAlignmentLeft;
        
          [_wxgzLabel setFont:Font(12*PXSCALEH)];
        _wxgzLabel.numberOfLines = 2;
        _wxgzLabel.textAlignment = NSTextAlignmentLeft;
        
        [_moneyLabel setFont:Font(12*PXSCALEH)];
        _moneyLabel.numberOfLines = 2;
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:view];
        [self.contentView addSubview:_gdhLabel];
        [self.contentView addSubview:_enterDateLabel];
  
        [self.contentView addSubview:_wxgzLabel];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}

- (void)setModel:(ManageModel *)model
{
    _model = model;
    _gdhLabel.text = [NSString stringWithFormat:@"本次工单：%@",model.jsd_id];
    _enterDateLabel.text =  [NSString stringWithFormat:@"修理类别：%@",model.xllb];
    _wxgzLabel.text =  [NSString stringWithFormat:@"进厂日期：%@",model.jc_date];
    _moneyLabel.text =  [NSString stringWithFormat:@"进厂里程：%@",model.jclc];
    
}

@end

