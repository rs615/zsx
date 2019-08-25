//
//  ProjectOrderViewController.h
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfoModel.h"
#import "BaseViewController.h"

@interface ProjectOrderViewController : BaseViewController
@property (nonatomic, strong) CarInfoModel* model;
@property (nonatomic, strong) NSString* jsd_id;
@property (nonatomic, assign) BOOL isNeedRefresh;//是否需要刷新


@end
