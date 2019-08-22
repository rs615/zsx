//
//  LoginController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "LoginController.h"
#import "TabViewController.h"

@interface LoginController ()

@end

@implementation LoginController
-(void) createUI
{
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image=[UIImage imageNamed:@"zsx_back_login"];
    [self.view insertSubview:backImageView atIndex:0];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 100, 280, 30)];
    // 设置输入框界面风格,枚举如下:
    // UITextBorderStyleNone        // 无风格
    // UITextBorderStyleLine        // 线性风格
    // UITextBorderStyleBezel       // bezel风格
    // UITextBorderStyleRoundedRect // 边框风格
    textField.borderStyle = UITextBorderStyleRoundedRect;
    // 设置提示文字
    textField.placeholder = @"厂家/分店名称";
     textField.text=@"首佳演示";
    // 将控件添加到当前视图上
    [self.view addSubview:textField];
    
    UITextField * textField2 = [[UITextField alloc]initWithFrame:CGRectMake(80, 150, 280, 30)];
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    // 设置提示文字
    textField2.placeholder = @"请输入用户名";
    textField2.text=@"superuser";
    // 将控件添加到当前视图上
    [self.view addSubview:textField2];
    UITextField * textField3 = [[UITextField alloc]initWithFrame:CGRectMake(80, 200, 280, 30)];
    textField3.borderStyle = UITextBorderStyleRoundedRect;
    // 设置提示文字
    textField3.placeholder = @"请输入密码";
    textField3.text = @"88204776";
    // 将控件添加到当前视图上
    [self.view addSubview:textField3];
    //类方法创建button
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(80, 260, 280, 40);
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    //添加到视图并显示
    [self.view addSubview:btn];
    
    //在controller中设置按钮的目标-动作，其中目标是self，也就是控制器自身，动作是用目标提供的BtnClick:方法，
    [btn addTarget:self
                          action:@selector(BtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    
}

//MyView中的按钮的事件
- (void)BtnClick:(UIButton *)btn
{
    TabViewController* homePage = [[TabViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homePage];
    homePage.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#F0F0F0"];
    
    [self presentViewController:navController animated:YES completion:nil];
    [self.navigationController pushViewController:homePage animated:YES];//从当前界面到nextVC这个界面
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
