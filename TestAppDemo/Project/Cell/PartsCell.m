//
//  PartsCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "PartsCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"
@interface PartsCell()


@end

@implementation PartsCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    PartsCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PartsCell];
    if(cell==nil){
        cell = [[PartsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_PartsCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 110*PXSCALEH)];
    
        NSArray* titleArr = @[@"名称:",@"规格:",@"仓库:",@"库存量:",@"销售价:",@"配件型号:"];
        contentView.backgroundColor = SetColor(@"#E5CCD0", 1);

        for(int i=0;i<titleArr.count;i++){
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i%2*(MainS_Width-60*PXSCALE)/2+30*PXSCALE, i/2*30*PXSCALEH+10*PXSCALEH,(MainS_Width-60*PXSCALE)/2, 30*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:12*PXSCALEH color:[UIColor blackColor] align:@"left"];
            titleLabel.tag = 100+i;
            [contentView addSubview:titleLabel];
        }
        NSString* checkedImgName = _model.isSelected?@"right_now":@"right_now_no";
        _checkBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((30*PXSCALE-20*PXSCALE)/2, (100*PXSCALEH-20*PXSCALE)/2,  20*PXSCALEH, 20*PXSCALEH) imageName:checkedImgName title:@"" clickAction:@selector(btnSelect:)];
        _checkBtn.tag = 200;
//        [_checkBtn setImage:[UIImage imageNamed:@"right_now"] forState:UIControlStateSelected];
//        [_checkBtn setImage:[UIImage imageNamed:@"right_now_no"] forState:UIControlStateNormal];
        [contentView addSubview:_checkBtn];
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setModel:(PartsModel *)model
{
    _model = model;
  
    NSString* checkedImgName = _model.isSelected?@"right_now":@"right_now_no";
    [_checkBtn setImage:[UIImage imageNamed:checkedImgName] forState:UIControlStateNormal];


    ((UILabel*)[self.contentView viewWithTag:100]).text = [NSString stringWithFormat:@"名称:%@",model.pjmc];
    ((UILabel*)[self.contentView viewWithTag:102]).text =  [NSString stringWithFormat:@"仓库:%@号仓",model.cd];
    ((UILabel*)[self.contentView viewWithTag:101]).text = [NSString stringWithFormat:@"规格:%@",model.cd];
    ((UILabel*)[self.contentView viewWithTag:103]).text = [NSString stringWithFormat:@"库存量:%d",[model.kcl intValue]];
    ((UILabel*)[self.contentView viewWithTag:104]).text =[NSString stringWithFormat:@"销售价: ¥%.2f",[model.xsj floatValue]];
    ((UILabel*)[self.contentView viewWithTag:105]).text = [NSString stringWithFormat:@"配件型号:%@",model.cx];

}

-(void)btnSelect:(UIButton*)btn{
    btn.selected = !btn.selected;
    _model.isSelected = btn.selected;
    NSString* checkedImgName = _model.isSelected?@"right_now":@"right_now_no";
    [_checkBtn setImage:[UIImage imageNamed:checkedImgName] forState:UIControlStateNormal];
}

@end
