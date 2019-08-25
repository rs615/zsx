//
//  ProjectCell.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/16.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProjectModel.h"
#define kCellIdentifier_ProjectCell @"ProjectCell"
typedef void (^btnProClick)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface ProjectCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, copy) btnProClick block;


@end

NS_ASSUME_NONNULL_END


