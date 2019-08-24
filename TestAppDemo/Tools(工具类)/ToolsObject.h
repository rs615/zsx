//
//  ToolsObject.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//
//工具类
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ZXBHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolsObject : NSObject

+(BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  没有图片的提示
 *
 *  @param title      提示语
 *  @param controller 控制器
 */
+ (void)show:(NSString *)title
        With:(UIViewController *)controller;

//加载框

+(MBProgressHUD *)showLoading:(NSString *)title with:(UIViewController *)contoller;

+(NSDate *)stringToDate:(NSString *)dateStr;

+(void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

+ (void)saveDataSouceName:(NSString *)dataSourceName;
+ (NSString *)getDataSouceName;


+ (void)saveUserName:(NSString *)userName;

+ (NSString *)getUserName;

+ (NSString *)getPasword;


+ (void)savePassword:(NSString *)password;

+ (NSString *)getFactoryName;


+ (void)saveFactoryName:(NSString *)factory;

+ (NSString *)getCompCode;

+ (void)saveCompCode:(NSString *)code;


+ (NSString *)getChineseName;


+ (void)saveChineseName:(NSString *)chineseName;


+ (BOOL)isHasLogin;


+ (void)saveHaseLogin:(BOOL)hasLogin;
+(CGRect)getStringFrame:(NSString *)str withFont:(NSInteger)fontSize withMaxSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
