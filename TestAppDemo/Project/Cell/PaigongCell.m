//
//  PaigongCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "PaigongCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"

@implementation PaigongCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PaigongCell];
    if(cell==nil){
        cell = [[PaigongCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_PaigongCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 170*PXSCALEH)];
        NSArray* titleArr = @[@"项目名称: ",@"指派给: ",@"维修人员: ",@"派工金额: ",@"派工状态: "];
        for(int i=0;i<titleArr.count;i++){
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(40*PXSCALE, i*30*PXSCALEH+10*PXSCALEH,MainS_Width-80*PXSCALE, 30*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:12*PXSCALEH color:[UIColor blackColor] align:@"left"];
            titleLabel.tag = 100+i;
            [contentView addSubview:titleLabel];
            
        }
        _checkBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((40*PXSCALE-20*PXSCALE)/2, (170*PXSCALEH-20*PXSCALE)/2,  20*PXSCALEH, 20*PXSCALEH) imageName:@"right_now_no" title:@"" clickAction:@selector(btnSelect:)];
        [_checkBtn setImage:[UIImage imageNamed:@"right_now"] forState:UIControlStateSelected];
        [_checkBtn setImage:[UIImage imageNamed:@"right_now_no"] forState:UIControlStateNormal];
        [contentView addSubview:_checkBtn];
        [self.contentView addSubview:contentView];

        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setModel:(PaigongInfoModel *)model
{
    _model = model;
    NSString* checkedImgName = model.checked?@"right_now":@"right_now_no";
    
    [_checkBtn setImage:[UIImage imageNamed:checkedImgName] forState:(UIControlStateNormal)];

    NSArray* titleArr = @[@"项目名称: ",@"指派给: ",@"维修人员: ",@"派工金额: ",@"派工状态: "];
    NSArray* valueArr = @[model.xlxm,model.assign,model.xlg,model.pgje,model.states];
    for (int i=0; i<titleArr.count; i++) {
        UILabel* titleLable = (UILabel*)[self.contentView viewWithTag:100+i];
        titleLable.text = [NSString stringWithFormat:@"%@%@",[titleArr objectAtIndex:i],[valueArr objectAtIndex:i]];
    }
}

-(void)btnSelect:(UIButton*)btn{
    btn.selected = !btn.selected;
}
@end
