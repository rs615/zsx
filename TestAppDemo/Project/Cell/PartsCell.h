//
//  PartsCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartsModel.h"
#import <UIKit/UIKit.h>
#define kCellIdentifier_PartsCell @"PartsCell"

NS_ASSUME_NONNULL_BEGIN

@interface PartsCell : UITableViewCell
@property (nonatomic, strong) PartsModel *model;
@property (strong, nonatomic) UIButton *checkBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
NS_ASSUME_NONNULL_END
