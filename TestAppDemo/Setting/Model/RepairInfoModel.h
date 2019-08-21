//
//  RepairInfoModel.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/19.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RepairInfoModel : NSObject
@property (nonatomic , assign) int ID;
@property (nonatomic , copy)  NSString* xlz;
@property (nonatomic , copy)  NSString* xlg;
@property (nonatomic , assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
