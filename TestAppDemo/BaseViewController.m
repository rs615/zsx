//
//  BaseViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "CarInfoModel.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setNavTitle:(NSString *)title withleftImage:(NSString *)leftImage withleftAction:(SEL)leftAction  withRightImage:(NSString *)righImage  rightAction:(SEL)rightaction withVC:(id)VC{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainS_Width, NavBarHeight)];
    //    titleView.backgroundColor = [UIColor whiteColor];
    //先添加左侧按钮
    UIButton *leftBtn = [PublicFunction getButtonInControl:VC frame:CGRectMake(8, 21, 35, 35) imageName:leftImage title:nil clickAction:leftAction];
    leftBtn.tag = 10004;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleView addSubview:leftBtn];
    
    UILabel *titleLabel = [PublicFunction getlabel:CGRectMake((MainS_Width-150)/2, 21, 150, 40) text:title fontSize:navTitleFont color:SetColor(@"#111111", 1.0) align:@"center"];
    titleLabel.tag = 10002;
    [titleView addSubview:titleLabel];
    
    UIButton *rightBtn = [PublicFunction getButtonInControl:VC frame:CGRectMake(MainS_Width-35-8, leftBtn.frame.origin.y, 35, 35) imageName:righImage title:nil clickAction:rightaction];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.tag = 10003;
    [titleView addSubview:rightBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight-1, MainS_Width, 1)];
    line.backgroundColor = radioBGColorf5;
    line.tag = 10001;
    [titleView addSubview:line];
    titleView.tag = 10000;
    [self.view addSubview:titleView];
}


//返回
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
