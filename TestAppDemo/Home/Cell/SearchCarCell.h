//
//  SearchCarCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfoModel.h"

#define kCellIdentifier_SearchCarCell @"SearchCarCell"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCarCell : UITableViewCell

@property (nonatomic, strong) CarInfoModel *model;

@end

NS_ASSUME_NONNULL_END
