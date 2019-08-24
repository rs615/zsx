//
//  MoneyModel.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/24.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyModel : NSObject
@property (nonatomic , assign) double money;
@property (nonatomic , assign) double  sxf;
@property (nonatomic , copy) NSString* moneyDesc;
@end

NS_ASSUME_NONNULL_END
