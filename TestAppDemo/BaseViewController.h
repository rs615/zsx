//
//  BaseViewController.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBHeader.h"
#import "PublicFunction.h"
#import "MBProgressHUD+PX.h"
#import "AFNetworking.h"
#import "HNBankView.h"
#import "HttpRequestManager.h"
#import "MJExtension.h"
#import "DataBaseTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

-(void)setNavTitle:(NSString *)title withleftImage:(NSString *)leftImage withleftAction:(SEL)leftAction  withRightImage:(NSString *)righImage  rightAction:(SEL)rightaction withVC:(id)VC;

-(void)loadCarList:(NSString*)previous_xh;

@end

NS_ASSUME_NONNULL_END
