//
//  SelfPartsCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SelfPartsModel.h"
#define kCellIdentifier_SelfPartsCell @"SelfPartsCell"

NS_ASSUME_NONNULL_BEGIN

@interface SelfPartsCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) SelfPartsModel *model;

@end

NS_ASSUME_NONNULL_END
