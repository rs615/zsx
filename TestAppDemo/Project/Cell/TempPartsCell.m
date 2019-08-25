//
//  TempPartsCell.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "TempPartsCell.h"
#import "PublicFunction.h"
#import "ZXBHeader.h"

@implementation TempPartsCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    id cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TempPartsCell];
    if(cell==nil){
        cell = [[TempPartsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier_TempPartsCell];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 170*PXSCALEH)];
        contentView.backgroundColor = SetColor(@"#E5CCD0", 1);
        NSArray* titleArr = @[@"名称:",@"进价:",@"销价:",@"数量:"];
        for(int i=0;i<titleArr.count;i++){
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, i*30*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/6, 30*PXSCALEH) text:[titleArr objectAtIndex:i] size:14 align:@"center"];
            [contentView addSubview:titleLabel];
            titleLabel.backgroundColor = [UIColor clearColor];

             UITextField* valueTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*30*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/6*5, 30*PXSCALEH) tag:i returnType:@""];
            if(i!=0){
                valueTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
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
            _model.jinjia = textField.text;
            break;
        case 2:
            _model.xiaojia = textField.text;
            break;
        case 3:
            _model.shuliang = textField.text;
            break;
        default:
            break;
    }
}

- (void)setModel:(TempPartsModel *)model
{
    _model = model;
   
}


@end
