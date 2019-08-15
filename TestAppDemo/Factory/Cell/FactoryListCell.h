//
//  FactoryListCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/15.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ManageInfoModel.h"
#define kCellIdentifier_FactoryListCell @"FactoryListCell"
NS_ASSUME_NONNULL_BEGIN

@interface FactoryListCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ManageInfoModel *model;


@end

NS_ASSUME_NONNULL_END
