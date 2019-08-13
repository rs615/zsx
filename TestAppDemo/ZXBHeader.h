//
//  ZXBHeader.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//
#import "UIColor+Hex.h"

#ifndef ZXBHeader_h
#define ZXBHeader_h
//宏定义

#endif /* ZXBHeader_h */

#define  MAXWIDTH       [UIScreen mainScreen].bounds.size.width
#define  MAXHEIGHT      [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define Font(size)    [UIFont systemFontOfSize:size*PXSCALE]
///比例系数
#define PXSCALE  MAXWIDTH/375
#define PXSCALEH  MAXHEIGHT/667
// MainScreen Height&Width
#define MainS_Height      [[UIScreen mainScreen] bounds].size.height
#define MainS_Width       [[UIScreen mainScreen] bounds].size.width
#define NavBarHeight 64
#define navTitleFont 17

// 判断网络
#define NetworkIsStatusNotReachable [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable
// 没网的提示
#define NotNetworkTip [MBProgressHUD showError:@"请检查网络连接"]


// 十六进制颜色设置
#define SetColor(color,a) [UIColor colorwithHExString:[NSString stringWithFormat:@"%@",color] alpha:a]
#define UIColorFromHex(s)   [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

// 线的颜色
#define   LineColor         SetColor(@"#e0e0e0",1.0)

#define  TitleColor         SetColor(@"#333333",1.0)

#define  radioBGColorf5       SetColor(@"#f5f5f5",1.0)   //电台背景颜色


/**
 * RGB 配置颜色
 */
#define    UIColorFromRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

/**
 * 16进制配置颜色
 */
#define UIColorHexFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
