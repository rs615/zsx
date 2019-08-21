//
//  PeijianCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/16.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PeijianModel.h"
#define kCellIdentifier_PeijianCell @"PeijianCell"
typedef void (^btnClick)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface PeijianCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) PeijianModel *model;
@property (nonatomic, copy) btnClick block;

@end

NS_ASSUME_NONNULL_END
