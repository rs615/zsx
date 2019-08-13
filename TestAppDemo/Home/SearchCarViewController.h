//
//  SearchCarViewController.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchCarCell.h"
#import "CarInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SeachCarBlock)(CarInfoModel* model);

@interface SearchCarViewController : BaseViewController

@property (nonatomic,strong)NSString * searchName;
@property (nonatomic , copy) SeachCarBlock block;



@end

NS_ASSUME_NONNULL_END
