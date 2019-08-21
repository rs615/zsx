//
//  ProjectCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/16.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectCell.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"

@implementation ProjectCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProjectCell];
    if(cell==nil){
        cell = [[ProjectCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_ProjectCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 80*PXSCALEH)];
        contentView.backgroundColor = lightGrayColor;
        NSArray* titleArr = @[@"项目名称",@"性质",@"修理费",@"优惠",@"操作"];
        for(int i=0;i<titleArr.count;i++){
       
            if(i==titleArr.count-1){
                UIView* btnView = [[UIView alloc] initWithFrame:CGRectMake(i*MainS_Width/5, 0, MainS_Width/5, 80*PXSCALEH)];
                UIButton* deleteBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((MainS_Width/5-30)/2, 5*PXSCALEH, 30, 30) imageName:@"minus_img" title:@"" clickAction:@selector(btnSelect:)];
                deleteBtn.tag = 110;
                UIButton* editBtn = [PublicFunction getButtonInControl:self frame:CGRectMake((MainS_Width/5-30)/2, deleteBtn.frame.origin.y+deleteBtn.bounds.size.height+5*PXSCALEH, 30, 30) imageName:@"edit" title:@"" clickAction:@selector(btnSelect:)];
                editBtn.tag = 111;
                [btnView addSubview:deleteBtn];
                [btnView addSubview:editBtn];
            
                [contentView addSubview:btnView];

            }else{
                UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/5, 5, MainS_Width/5, 80*PXSCALEH) text:@"" fontSize:12*PXSCALEH color:[UIColor blackColor] align:@"center"];
                titleLabel.tag = 100+i;
                [contentView addSubview:titleLabel];
            }
        }
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setModel:(ProjectModel *)model
{
    _model = model;
    ((UILabel*)[self.contentView viewWithTag:100]).text = model.xlxm;
    ((UILabel*)[self.contentView viewWithTag:101]).text = model.wxgz;
    ((UILabel*)[self.contentView viewWithTag:102]).text = model.xlf;
    ((UILabel*)[self.contentView viewWithTag:103]).text = model.zk;
//    ((UILabel*)[self.contentView viewWithTag:104]).text = model.wxgz;
}

-(void)btnSelect:(UIButton*)btn{
    if(self.block){
        self.block(btn.tag);
    }
}
@end
