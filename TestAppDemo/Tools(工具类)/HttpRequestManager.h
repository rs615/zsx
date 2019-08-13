//
//  HttpRequestManager.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define DEFULTURL @"http://121.43.148.193:5555"

NS_ASSUME_NONNULL_BEGIN
typedef void (^httpSuccess)(id responseObject);
//失败的回调
typedef void (^httpFailure)(NSError *error);

@interface HttpRequestManager : NSObject

// post 请求
+ (void)HttpPostCallBack:(NSString*)Url  Parameters:(NSDictionary*)dict success:(httpSuccess)success failure:(httpFailure)failure;

// get  请求
+ (void)HttpGetCallBack:(NSString*)Url  Parameters:(NSDictionary*)dict success:(httpSuccess)success failure:(httpFailure)failure;



@end

NS_ASSUME_NONNULL_END
