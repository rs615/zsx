//
//  FactoryManagerCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/14.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "FactoryListCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"

@interface FactoryListCell()

@property (strong, nonatomic) UILabel *cpNameLabel;//车牌
@property (strong, nonatomic) UILabel *cjhLabel;//车架号
@property (strong, nonatomic) UILabel *cxLabel;//车型
@property (strong, nonatomic) UILabel *jdryLabel;//接待人员
@property (strong, nonatomic) UILabel *enterDateLabel;//进厂日期
@property (strong, nonatomic) UILabel *statesLabel;//进厂日期

@end

@implementation FactoryListCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FactoryListCell];
    if(cell==nil){
        cell = [[FactoryListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_FactoryListCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 40*PXSCALEH)];
        view.backgroundColor = SetColor(@"#98C89A", 1);
        [self.contentView addSubview:view];
        
        _cpNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*PXSCALE, 5*PXSCALEH, (view.bounds.size.width-(30+20)*PXSCALE)/2, 30*PXSCALEH)];
        [view addSubview:_cpNameLabel];
        _statesLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.size.width/2+10*PXSCALE,  5*PXSCALEH, _cpNameLabel.bounds.size.width, 30*PXSCALEH)];
        [view addSubview:_statesLabel];
        
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, MainS_Width, 130*PXSCALEH)];
        
        UIImageView* leftView = [PublicFunction getImageView:CGRectMake(10*PXSCALE,10*PXSCALEH, (MainS_Width-2*10*PXSCALE)/3, 110*PXSCALEH) imageName:@"car_img"];
        [bottomView addSubview:leftView];
        UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.origin.x+leftView.bounds.size.width, 0, MainS_Width-leftView.frame.origin.x+leftView.bounds.size.width, 120*PXSCALEH)];
        _cjhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, 5*PXSCALEH, rightView.bounds.size.width-10*PXSCALE, 30*PXSCALEH)];
        _enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, 35*PXSCALEH, rightView.bounds.size.width-10*PXSCALE, 30*PXSCALEH)];
        _jdryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, 65*PXSCALEH, rightView.bounds.size.width-10*PXSCALE, 30*PXSCALEH)];
        _cxLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, 95*PXSCALEH, rightView.bounds.size.width-10*PXSCALE, 30*PXSCALEH)];
        [rightView addSubview:_cjhLabel];
        [rightView addSubview:_enterDateLabel];
        [rightView addSubview:_jdryLabel];
        [rightView addSubview:_cxLabel];
        [bottomView addSubview:rightView];
        [self.contentView addSubview:bottomView];
        bottomView.backgroundColor = lightGrayColor;
    }
    return self;
}

- (void)setModel:(ManageInfoModel *)model
{
    _model = model;
    _cpNameLabel.text = [NSString stringWithFormat:@"车牌: %@",model.cp!=nil?model.cp:@""];
    _statesLabel.text = [NSString stringWithFormat:@"状态: %@",model.states];
    _cjhLabel.text = [NSString stringWithFormat:@"车架号码: %@",model.cjhm!=nil?model.cjhm:@""];
    _cxLabel.text = [NSString stringWithFormat:@"车型: %@",model.cx!=nil?model.cx:@""];
    _jdryLabel.text = [NSString stringWithFormat:@"接待人员: %@",model.jcr!=nil?model.jcr:@""];
  
    _enterDateLabel.text = [NSString stringWithFormat:@"进厂时间: %@",model.jc_date!=nil?model.jc_date:@""];
}


@end
