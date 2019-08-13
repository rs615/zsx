//
//  UIManager.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//


#import "UIManager.h"

@implementation UIManager


static UIManager *sharedInstance = nil;
+ (UIManager*)sharedInstance {
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        if (sharedInstance == nil) {
            sharedInstance = [[UIManager alloc] init];
        }
    });
    return sharedInstance;
}

@end
