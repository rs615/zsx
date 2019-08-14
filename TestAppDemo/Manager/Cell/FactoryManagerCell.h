//
//  FactoryManagerCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/14.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageInfoModel.h"
#define kCellIdentifier_FactoryManagerCell @"FactoryManagerCell"

NS_ASSUME_NONNULL_BEGIN

@interface FactoryManagerCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ManageInfoModel *model;


@end

NS_ASSUME_NONNULL_END
