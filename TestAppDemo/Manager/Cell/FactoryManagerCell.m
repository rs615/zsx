//
//  FactoryManagerCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/14.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "FactoryManagerCell.h"
#import "ZXBHeader.h"

@interface FactoryManagerCell()

@property (strong, nonatomic) UILabel *cpNameLabel;//车牌
@property (strong, nonatomic) UILabel *jsdLabel;//结算单
@property (strong, nonatomic) UILabel *cjhLabel;//车架号
@property (strong, nonatomic) UILabel *projectStatusLabel;//项目状态
@property (strong, nonatomic) UILabel *cxLabel;//车型
@property (strong, nonatomic) UILabel *wxgzLabel;//维修工种
@property (strong, nonatomic) UILabel *lgryLabel;//领工人员
@property (strong, nonatomic) UILabel *zpryLabel;//指派人员
@property (strong, nonatomic) UILabel *enterDateLabel;//进厂日期

@end

@implementation FactoryManagerCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FactoryManagerCell];
    if(cell==nil){
         cell = [[FactoryManagerCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_FactoryManagerCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 40*PXSCALEH)];
        view.backgroundColor = SetColor(@"#98C89A", 1);
        //weak弱类型 assign之后会自动释放
        _cpNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*PXSCALE, 5*PXSCALEH, (view.bounds.size.width-(30+20)*PXSCALE)/2, 30*PXSCALEH)];
        [view addSubview:_cpNameLabel];
        _jsdLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.size.width/2+10*PXSCALE,  5*PXSCALEH, _cpNameLabel.bounds.size.width, 30*PXSCALEH)];
        [view addSubview:_jsdLabel];
        [self.contentView addSubview:view];

        _cjhLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, _jsdLabel.frame.origin.y+_jsdLabel.bounds.size.height+10*PXSCALEH, view.bounds.size.width-20*PXSCALE, 30*PXSCALEH)];
        _cjhLabel.font = Font(13*PXSCALEH);

        [self.contentView addSubview:_cjhLabel];

        _projectStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, _cjhLabel.frame.origin.y+_jsdLabel.bounds.size.height+5*PXSCALEH, (view.bounds.size.width-20*PXSCALE)/2, 30*PXSCALEH)];
        _projectStatusLabel.font = Font(13*PXSCALEH);
        [self.contentView addSubview:_projectStatusLabel];

        _cxLabel = [[UILabel alloc] initWithFrame:CGRectMake((view.bounds.size.width-20*PXSCALE)/2, _cjhLabel.frame.origin.y+_jsdLabel.bounds.size.height+5*PXSCALEH, (view.bounds.size.width-20*PXSCALE)/2, 30*PXSCALEH)];
        _cxLabel.font = Font(13*PXSCALEH);
        [self.contentView addSubview:_cxLabel];
    
        
        _wxgzLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, _cxLabel.frame.origin.y+_cxLabel.bounds.size.height+5*PXSCALEH, (view.bounds.size.width-20*PXSCALE)/2, 30*PXSCALEH)];
        _wxgzLabel.font = Font(13*PXSCALEH);
        [self.contentView addSubview:_wxgzLabel];
        
        _lgryLabel = [[UILabel alloc] initWithFrame:CGRectMake((view.bounds.size.width-20*PXSCALE)/2, _cxLabel.frame.origin.y+_cxLabel.bounds.size.height+5*PXSCALEH, (view.bounds.size.width-20*PXSCALE)/2, 30*PXSCALEH)];
        _lgryLabel.font = Font(13*PXSCALEH);
        [self.contentView addSubview:_lgryLabel];
        
        _zpryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PXSCALE, _wxgzLabel.frame.origin.y+_wxgzLabel.bounds.size.height+5*PXSCALEH, (view.bounds.size.width-20*PXSCALE)/2, 30*PXSCALEH)];
        [self.contentView addSubview:_zpryLabel];
        _zpryLabel.font = Font(13*PXSCALEH);

        _enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake((view.bounds.size.width-20*PXSCALE)/2, _wxgzLabel.frame.origin.y+_wxgzLabel.bounds.size.height+5*PXSCALEH, (view.bounds.size.width-20*PXSCALE)/2, 30*PXSCALEH)];
        _enterDateLabel.font = Font(13*PXSCALEH);

        [self.contentView addSubview:_enterDateLabel];
      

    }
    return self;
}

- (void)setModel:(ManageInfoModel *)model
{
    _model = model;
    _cpNameLabel.text = [NSString stringWithFormat:@"车牌: %@",model.cp!=nil?model.cp:@""];
    _jsdLabel.text = [NSString stringWithFormat:@"结算单: %@",model.jsd_id!=nil?model.jsd_id:@""];
    _cjhLabel.text = [NSString stringWithFormat:@"车架号码: %@",model.cjhm!=nil?model.cjhm:@""];
    _projectStatusLabel.text = [NSString stringWithFormat:@"项目状态: %@",model.states];
    _cxLabel.text = [NSString stringWithFormat:@"车型: %@",model.cx!=nil?model.cx:@""];
    _wxgzLabel.text = [NSString stringWithFormat:@"维修工种: %@",model.wxgz!=nil?model.wxgz:@""];
    _lgryLabel.text = [NSString stringWithFormat:@"领工人员: %@",model.assign!=nil?model.assign:@""];
    _zpryLabel.text = [NSString stringWithFormat:@"指派人员: %@",model.xlg!=nil?model.xlg:@""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:model.jc_date];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    _enterDateLabel.text = [NSString stringWithFormat:@"进厂日期: %@",[dateFormatter stringFromDate:date]];
}


@end
