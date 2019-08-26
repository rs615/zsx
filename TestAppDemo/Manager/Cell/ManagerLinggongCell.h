//
//  ManagerLinggongCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/26.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManageInfoModel.h"
#define kCellIdentifier_ManagerLinggongCell @"ManagerLinggongCell"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagerLinggongCell : UITableViewCell
@property (nonatomic, strong) ManageInfoModel *model;
@property (strong, nonatomic) UIButton *checkBtn;
+(instancetype)cellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
