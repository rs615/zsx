//
//  PerformanceController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "PerformanceController.h"

@interface PerformanceController ()

@end

@implementation PerformanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的绩效" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//返回
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
