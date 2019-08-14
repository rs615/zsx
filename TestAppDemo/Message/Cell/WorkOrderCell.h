//
//  WorkOrderCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/14.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OrderModel.h"
#define kCellIdentifier_WorkOrderCell @"WorkOrderCell"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) OrderModel *model;


@end
NS_ASSUME_NONNULL_END
