//
//  ManagerLinggongCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/26.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ManagerLinggongCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"


@interface ManagerLinggongCell()

@property (strong, nonatomic) UILabel *repair_assignLabel;//
@property (strong, nonatomic) UILabel *repair_typeLabel;//进厂日期
@property (strong, nonatomic) UILabel *repair_nameLabel;//进厂日期

@end


@implementation ManagerLinggongCell



+(instancetype)cellWithTableView:(UITableView *)tableView{
    ManagerLinggongCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ManagerLinggongCell];
    if(cell==nil){
        cell = [[ManagerLinggongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_ManagerLinggongCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 85*PXSCALEH)];
        NSArray* imgArr = @[@"repair_shop:",@"gou_red",@"person"];
        contentView.backgroundColor = SetColor(@"#eeeeee", 1);
        
        
        UIImageView* nameImgView = [PublicFunction getImageView:CGRectMake(40*PXSCALE, 10*PXSCALEH, 30*PXSCALE, 30*PXSCALE) imageName:@"person"];
        _repair_nameLabel = [PublicFunction getlabel:CGRectMake(nameImgView.frame.origin.x+nameImgView.bounds.size.width+10*PXSCALE, nameImgView.frame.origin.y, (MainS_Width-70*PXSCALE)/3*2, 30*PXSCALEH) text:@"" align:@"left"];
        [contentView addSubview:nameImgView];
        [contentView addSubview:_repair_nameLabel];
        
        UIImageView* typeImgView = [PublicFunction getImageView:CGRectMake(MainS_Width-(MainS_Width-70*PXSCALE)/3, 10*PXSCALEH, 30*PXSCALE, 30*PXSCALE) imageName:@"gou_red"];
        _repair_typeLabel = [PublicFunction getlabel:CGRectMake(typeImgView.frame.origin.x+typeImgView.bounds.size.width+10*PXSCALE, typeImgView.frame.origin.y, MainS_Width-(MainS_Width-70*PXSCALE)/3*2-_repair_nameLabel.frame.origin.x-30*PXSCALE, 30*PXSCALEH) text:@"" align:@"left"];

        [contentView addSubview:typeImgView];
        [contentView addSubview:_repair_typeLabel];
        
        UIImageView* assginImgView = [PublicFunction getImageView:CGRectMake(40*PXSCALE, 10*PXSCALEH+_repair_nameLabel.frame.origin.y+_repair_nameLabel.bounds.size.height, 30*PXSCALE, 30*PXSCALE) imageName:@"repair_shop"];
        _repair_assignLabel = [PublicFunction getlabel:CGRectMake(assginImgView.frame.origin.x+assginImgView.bounds.size.width+10*PXSCALE, assginImgView.frame.origin.y, (MainS_Width-70*PXSCALE)/3*2, 30*PXSCALEH) text:@"" align:@"left"];
        [contentView addSubview:assginImgView];
        [contentView addSubview:_repair_assignLabel];
       

        NSString* checkedImgName = _model.isChecked?@"right_now":@"right_now_no";
        _checkBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((30*PXSCALE-20*PXSCALE)/2, (80*PXSCALEH-20*PXSCALE)/2,  20*PXSCALEH, 20*PXSCALEH) imageName:checkedImgName title:@"" clickAction:@selector(btnSelect:)];
        _checkBtn.tag = 200;
        [contentView addSubview:_checkBtn];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setModel:(ManageInfoModel *)model
{
    _model = model;
    NSString* checkedImgName = _model.isChecked?@"right_now":@"right_now_no";
    [_checkBtn setImage:[UIImage imageNamed:checkedImgName] forState:UIControlStateNormal];

    _repair_nameLabel.text = model.xlxm!=nil?model.xlxm:@"";
    _repair_typeLabel.text = model.wxgz!=nil?model.wxgz:@"";
    _repair_assignLabel.text = [NSString stringWithFormat:@"指派给: %@",model.assign!=nil?model.assign:@""];
}

-(void)btnSelect:(UIButton*)btn{
    btn.selected = !btn.selected;
    _model.isChecked = btn.isSelected;
    NSString* checkedImgName = _model.isChecked?@"right_now":@"right_now_no";
    [_checkBtn setImage:[UIImage imageNamed:checkedImgName] forState:UIControlStateNormal];
}

@end
