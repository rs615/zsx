//
//  PaigongCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PaigongInfoModel.h"
#define kCellIdentifier_PaigongCell @"PaigongCell"

NS_ASSUME_NONNULL_BEGIN

@interface PaigongCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) PaigongInfoModel *model;
@property (strong, nonatomic) UIButton *checkBtn;

@end

NS_ASSUME_NONNULL_END
