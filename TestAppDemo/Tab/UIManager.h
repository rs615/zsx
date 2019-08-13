//
//  UIManager.h
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TabViewController.h"

@interface UIManager : NSObject

@property (nonatomic, strong) TabViewController *tabbarViewController;

+ (UIManager*)sharedInstance;

- (void)popToRootVCAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
