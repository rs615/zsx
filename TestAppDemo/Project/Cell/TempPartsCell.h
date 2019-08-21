//
//  TempPartsCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TempPartsModel.h"
#define kCellIdentifier_TempPartsCell @"TempPartsCell"

NS_ASSUME_NONNULL_BEGIN

@interface TempPartsCell : UITableViewCell
@property (nonatomic, strong) TempPartsModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
