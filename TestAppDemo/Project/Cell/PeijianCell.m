//
//  PeijianCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/16.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "PeijianCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"
@implementation PeijianCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PeijianCell];
    if(cell==nil){
        cell = [[PeijianCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_PeijianCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 80*PXSCALEH)];
        contentView.backgroundColor = lightGrayColor;
        NSArray* titleArr = @[@"配件名称",@"规格",@"数量",@"单价",@"合计",@"操作"];
        for(int i=0;i<titleArr.count;i++){
            if(i==titleArr.count-1){
                UIView* btnView = [[UIView alloc] initWithFrame:CGRectMake(i*MainS_Width/6, 0, MainS_Width/6, 80*PXSCALEH)];
                UIButton* deleteBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((MainS_Width/6-30)/2, 5*PXSCALEH, 30, 30) imageName:@"minus_img" title:@"" clickAction:@selector(btnSelect:)];
                UIButton* editBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((MainS_Width/6-30)/2, deleteBtn.frame.origin.y+deleteBtn.bounds.size.height+5*PXSCALEH, 30, 30) imageName:@"edit" title:@"" clickAction:@selector(btnSelect:)];
                [btnView addSubview:deleteBtn];
                deleteBtn.tag = 110;
                editBtn.tag = 111;
                [btnView addSubview:editBtn];
                [contentView addSubview:btnView];
                
            }else{
                UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/6, 5, MainS_Width/6, 80*PXSCALEH) text:@"" fontSize:12*PXSCALEH color:[UIColor blackColor] align:@"center"];
                titleLabel.tag = 100+i;
                [contentView addSubview:titleLabel];
            }
        }
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setModel:(PeijianModel *)model
{
    _model = model;
    ((UILabel*)[self.contentView viewWithTag:100]).text = _model.pjmc;
    ((UILabel*)[self.contentView viewWithTag:101]).text = _model.pjbm;
    ((UILabel*)[self.contentView viewWithTag:102]).text = _model.sl;
    ((UILabel*)[self.contentView viewWithTag:103]).text = _model.ssj;
    ((UILabel*)[self.contentView viewWithTag:104]).text = [NSString stringWithFormat:@"%.2f",[_model.sl floatValue]*[_model.ssj floatValue]];

}

-(void)btnSelect:(UIButton*)btn{
//    switch (btn.tag) {
//        case 110:
//            [self deletePeijianData];
//            break;
//        case 111:
//
//            break;
//        default:
//            break;
//    }
    if(self.block){
        self.block(btn.tag);
    }
}


@end
