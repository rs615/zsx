//
//  TabViewController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "TabViewController.h"
#import "UIManager.h"
#import "HomeViewController.h"
#import "FactoryManagerController.h"
#import "FactoryIntroduceController.h"
#import "MessageInfoController.h"
#import "SettingController.h"


@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     HomeViewController *item1 = [[HomeViewController alloc] init];
    FactoryManagerController *item2 = [[FactoryManagerController alloc] init];
     FactoryIntroduceController *item3 = [[FactoryIntroduceController alloc] init];
     MessageInfoController *item4 = [[MessageInfoController alloc] init];
    SettingController *item5 = [[SettingController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:item1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:item2];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:item3];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:item4];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:item5];
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
    [self addChildViewController:nav5];
    nav1.tabBarItem.title = @"车辆接待";
    nav1.tabBarItem.selectedImage=[UIImage imageNamed:@"recever_hand_gray"];
    nav1.tabBarItem.image = [UIImage imageNamed:@"recever_hand_blue"];
    nav2.tabBarItem.title = @"车间管理";
    nav2.tabBarItem.selectedImage=[UIImage imageNamed:@"factory_gray"];
    nav2.tabBarItem.image = [UIImage imageNamed:@"factory_blue"];
    nav3.tabBarItem.title = @"整厂概况";
    nav3.tabBarItem.selectedImage=[UIImage imageNamed:@"condition_gray"];
    nav3.tabBarItem.image = [UIImage imageNamed:@"condition_blue"];
    nav4.tabBarItem.title = @"信息中心";
    nav4.tabBarItem.selectedImage=[UIImage imageNamed:@"msg_gray"];
    nav4.tabBarItem.image = [UIImage imageNamed:@"msg_blue"];
    nav5.tabBarItem.title = @"设置";
    nav5.tabBarItem.selectedImage=[UIImage imageNamed:@"setting_gray"];
    nav5.tabBarItem.image = [UIImage imageNamed:@"setting_blue"];
    [UIManager sharedInstance].tabbarViewController = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
