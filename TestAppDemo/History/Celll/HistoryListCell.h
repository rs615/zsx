//
//  HistoryListCell.h
//  TestAppDemo
//
//  Created by 涂程 on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ManageModel.h"
#define kCellIdentifier_WorkOrderCell @"HistoryListCell"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryListCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ManageModel *model;


@end
NS_ASSUME_NONNULL_END
