//
//  LoginController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "LoginController.h"
#import "TabViewController.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"
#import "ToolsObject.h"
#import "HttpRequestManager.h"
#import "MBProgressHUD+PX.h"

@interface LoginController ()
@property (nonatomic,strong)UITextField *factoryNameField;
@property (nonatomic,strong)UITextField *userNameField;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)MBProgressHUD* progress;

@end

@implementation LoginController
-(void) createUI
{
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image=[UIImage imageNamed:@"zsx_back_login"];
    [self.view insertSubview:backImageView atIndex:0];
    

//    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 100, 280, 30)];
//    // 设置输入框界面风格,枚举如下:
//    // UITextBorderStyleNone        // 无风格
//    // UITextBorderStyleLine        // 线性风格
//    // UITextBorderStyleBezel       // bezel风格
//    // UITextBorderStyleRoundedRect // 边框风格
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    // 设置提示文字
//    textField.placeholder = @"厂家/分店名称";
//    // 将控件添加到当前视图上
//    [self.view addSubview:textField];
//    [[NSUserDefaults standardUserDefaults] stringForKey:FACTORYNAME];
//
//    UITextField * textField2 = [[UITextField alloc]initWithFrame:CGRectMake(80, 150, 280, 30)];
//    textField2.borderStyle = UITextBorderStyleRoundedRect;
//    // 设置提示文字
//    textField2.placeholder = @"请输入用户名";
//    // 将控件添加到当前视图上
//    [self.view addSubview:textField2];
//    UITextField * textField3 = [[UITextField alloc]initWithFrame:CGRectMake(80, 200, 280, 30)];
//    textField3.borderStyle = UITextBorderStyleRoundedRect;
//    // 设置提示文字
//    textField3.placeholder = @"请输入密码";
//    // 将控件添加到当前视图上
//    [self.view addSubview:textField3];
//    //类方法创建button
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(80, 260, 280, 40);
//    [btn setTitle:@"登录" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor blueColor]];
//    //添加到视图并显示
//    [self.view addSubview:btn];
//
//    //在controller中设置按钮的目标-动作，其中目标是self，也就是控制器自身，动作是用目标提供的BtnClick:方法，
//    [btn addTarget:self
//                          action:@selector(BtnClick:)
//                forControlEvents:UIControlEventTouchUpInside];
    UIImageView* backgroundImageView = [PublicFunction getImageView:CGRectMake(0, 0, MainS_Width, MainS_Height) imageName:@"zsx_back_login"];
    [self.view addSubview:backgroundImageView];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(10*PXSCALE, 0, MainS_Width-20*PXSCALE, 270*PXSCALEH)];
    contentView.backgroundColor = SetColor(@"#ffffff", 0.33);

    contentView.center = CGPointMake(backgroundImageView.center.x, backgroundImageView.center.y);//登录局中
    [self.view addSubview:contentView];
    _factoryNameField  = [PublicFunction getTextFieldInControl:self frame:CGRectMake(10*PXSCALE, 30*PXSCALEH, contentView.bounds.size.width-20*PXSCALE, 40*PXSCALEH) tag:100 returnType:nil text:@"" placeholder:@"修理厂名称/分店名称"];
    _factoryNameField.backgroundColor = SetColor(@"#ffffff", 0.53);
    [contentView addSubview:_factoryNameField];

    
    _userNameField  = [PublicFunction getTextFieldInControl:self frame:CGRectMake(10*PXSCALE, 20*PXSCALEH+_factoryNameField.frame.origin.y+40*PXSCALEH, contentView.bounds.size.width-20*PXSCALE, 40*PXSCALEH) tag:100 returnType:nil text:@"" placeholder:@"请输入用户名"];
    _userNameField.backgroundColor = SetColor(@"#ffffff", 0.53);
    [contentView addSubview:_userNameField];
    
    _passwordField  = [PublicFunction getTextFieldInControl:self frame:CGRectMake(10*PXSCALE, 20*PXSCALEH+_userNameField.frame.origin.y+40*PXSCALEH, contentView.bounds.size.width-20*PXSCALE, 40*PXSCALEH) tag:100 returnType:nil text:@"" placeholder:@"请输入密码"];
    _passwordField.backgroundColor = SetColor(@"#ffffff", 0.53);
    _passwordField.secureTextEntry = YES;
    [contentView addSubview:_passwordField];
    
    UIButton* loginBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(10*PXSCALE, 10*PXSCALEH+_passwordField.frame.origin.y+40*PXSCALEH, contentView.bounds.size.width-20*PXSCALE, 40*PXSCALEH) imageName:nil title:@"登录" clickAction:@selector(btnClick:)];
//    loginBtn.userInteractionEnabled = YES;
    loginBtn.backgroundColor = SetColor(@"#32b16c", 1);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:loginBtn];

    NSString* userName = [ToolsObject getUserName];
    if(userName!=nil){
        _userNameField.text = userName;
    }
    NSString* password = [ToolsObject getPasword];
    if(password!=nil){
        _passwordField.text = password;
    }
    NSString* factoryName = [ToolsObject getFactoryName];
    if(factoryName!=nil){
        _factoryNameField.text = factoryName;
    }
    BOOL isHasLogin = [ToolsObject isHasLogin];
    if(isHasLogin){
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabViewController alloc] init];
    }
}


//MyView中的按钮的事件
- (void)btnClick:(UIButton *)btn
{
    if([_factoryNameField.text isEqualToString:@""]){
        [ToolsObject show:@"修理厂名称/分店名称未填写" With:self];
        return;
    }
    if([_userNameField.text isEqualToString:@""]){
        [ToolsObject show:@"请输入用户名" With:self];
        return;
    }
    
    if([_passwordField.text isEqualToString:@""]){
        [ToolsObject show:@"请输入密码" With:self];
        return;
    }
    
    [self checkLoginDate];
    
//    TabViewController* homePage = [[TabViewController alloc] init];
//
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homePage];
//    homePage.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#F0F0F0"];
//
//    [self presentViewController:navController animated:YES completion:nil];
//
//    [self.navigationController pushViewController:homePage animated:YES];//从当前界面到nextVC这个界面
//
//    [UIApplication sharedApplication].keyWindow.rootViewController = homePage;

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

-(void)checkLoginDate{
    __weak LoginController *safeSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"sjsoft_SQL";
    dict[@"function"] = @"sp_fun_check_service_validity";
    dict[@"data_source"] = _factoryNameField.text;
    dict[@"operater_code"] =_userNameField.text;
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"true"]){
            //请求成功
            NSString* endDateStr = [responseObject objectForKey:@"service_end_date"];
            if(endDateStr!=nil&&![endDateStr isEqualToString:@""]){
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate* endDate = [inputFormatter dateFromString:endDateStr];
                NSDate *datenow = [NSDate date];
                if(endDate.timeIntervalSinceNow-datenow.timeIntervalSinceNow){
                    [ToolsObject saveDataSouceName:[responseObject objectForKey:@"Data_Source_name"]];
                    [safeSelf login];
                }else{
                    if(endDateStr.length>10){
                        endDateStr = [endDateStr substringToIndex:10];
                    }
                    [ToolsObject show:[NSString stringWithFormat:@"服务有效期限已经过了，请联系首佳软件进行续费。 过期时间：%@",endDateStr] With:safeSelf];
                }
            }else{
                [safeSelf login];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf.progress hideAnimated:YES];
        [ToolsObject show:@"服务异常" With:safeSelf];
    }];
}

#pragma 登录
-(void)login{
    __weak LoginController *safeSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_check_user_state_login";
    dict[@"operater_code"] = _userNameField.text;
    dict[@"operater_ip"] = @"121.43.148.193";
    dict[@"password"] = _passwordField.text;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        [safeSelf.progress hideAnimated:YES];
        if([[responseObject objectForKey:@"state"] isEqualToString:@"true"]){
//            [ToolsObject save]
            [ToolsObject savePassword:safeSelf.passwordField.text];
            [ToolsObject saveUserName:safeSelf.userNameField.text];
            [ToolsObject saveFactoryName:safeSelf.factoryNameField.text];
            [ToolsObject saveCompCode:[responseObject objectForKey:@"comp_code"]];
            [ToolsObject saveChineseName:[responseObject objectForKey:@"chinese_name"]];
            [ToolsObject saveHaseLogin:YES];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[TabViewController alloc] init];

        }else{
            [ToolsObject show:@"服务异常" With:safeSelf];
        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf.progress hideAnimated:YES];
        [ToolsObject show:@"服务异常" With:safeSelf];
    }];
}
@end
