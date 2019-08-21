//
//  SelfPartsCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "SelfPartsCell.h"
#import "PublicFunction.h"
#import "ZXBHeader.h"

@implementation SelfPartsCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelfPartsCell];
    if(cell==nil){
        cell = [[SelfPartsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_SelfPartsCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 90*PXSCALEH)];
        NSArray* titleArr = @[@"名称:",@"数量:"];
        contentView.backgroundColor = SetColor(@"#E5CCD0", 1);

        for(int i=0;i<titleArr.count;i++){
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, i*30*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/6, 30*PXSCALEH) text:[titleArr objectAtIndex:i] size:14 align:@"center"];
            [contentView addSubview:titleLabel];
            titleLabel.backgroundColor = [UIColor clearColor];

            UITextField* valueTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*30*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/6*5, 30*PXSCALEH) tag:i returnType:@""];
            [valueTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            [contentView addSubview:valueTextField];
            
        }
        [self.contentView addSubview:contentView];

    }
    
    return self;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _model.name = textField.text;
            break;
        case 1:
            _model.shuliang = textField.text;
            break;
        default:
            break;
    }
}

- (void)setModel:(SelfPartsModel *)model
{
    _model = model;
    
}
@end
