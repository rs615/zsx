//
//  SettingController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//
#import "SettingController.h"
#import "LoginController.h"
#import "HttpRequestManager.h"
#import "MBProgressHUD+PX.h"
#import "ToolsObject.h"
#import "FirstIconInfoModel.h"
#import "PartsModel.h"
#import "RepairInfoModel.h"
#import "DataBaseTool.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "HnAlertView.h"
#import "RequestIPAddress.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define GZDeviceHeight ([UIScreen mainScreen].bounds.size.height)
@interface SettingController()
@property (nonatomic,strong)NSString* errorMsg;
@property (nonatomic,strong)MBProgressHUD *progress;

@end

@implementation SettingController

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"设置";
    
}

-(void)initView
{
    UIView* item1 = [[UIView alloc] init];
    item1.frame = CGRectMake(0, 60, GZDeviceWidth, 60);
    item1.backgroundColor = [UIColor colorWithRed:(250/255.0f) green:( 233/255.0f) blue:(252/255.0f) alpha:1.0f];
    
    UIImage* image1 = [UIImage imageNamed:@"check_update"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image1];
    imageView.frame = CGRectMake(20, 15, 30, 30);
    //自适应图片宽高比例
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelUpdate = [[UILabel alloc] init];
    labelUpdate.frame = CGRectMake(70, 15, 80, 30);
    labelUpdate.text = @"更新数据";
    [item1 addSubview:labelUpdate];
    
    [item1 addSubview:imageView];
    [self.view addSubview:item1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateData:)];
    item1.userInteractionEnabled = YES;
    [item1 addGestureRecognizer:tap];
    
    
    UIView* item2 = [[UIView alloc] init];
    item2.frame = CGRectMake(0, 120, GZDeviceWidth, 60);
    item2.backgroundColor = [UIColor colorWithRed:(225/255.0f) green:( 250/255.0f) blue:(215/255.0f) alpha:1.0f];
    
    UIImage* image2 = [UIImage imageNamed:@"reset_pwd"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(20, 15, 30, 30);
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelPwd = [[UILabel alloc] init];
    labelPwd.frame = CGRectMake(70, 15, 80, 30);
    labelPwd.text = @"修改密码";
    [item2 addSubview:labelPwd];
    
    [item2 addSubview:imageView2];
    [self.view addSubview:item2];
  
    
    
    UIView* item3 = [[UIView alloc] init];
    item3.frame = CGRectMake(0, 180, GZDeviceWidth, 60);
    item3.backgroundColor = [UIColor colorWithRed:(250/255.0f) green:( 233/255.0f) blue:(252/255.0f) alpha:1.0f];
    
    UIImage* image3 = [UIImage imageNamed:@"contact_us"];
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:image3];
    imageView3.frame = CGRectMake(20, 15, 30, 30);
    //自适应图片宽高比例
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelData = [[UILabel alloc] init];
    labelData.frame = CGRectMake(70, 15, 80, 30);
    labelData.text = @"更新数据";
    [item3 addSubview:labelData];
    
    [item3 addSubview:imageView3];
    [self.view addSubview:item3];
    
    
    
    
    
    UIView* item4 = [[UIView alloc] init];
    item4.frame = CGRectMake(0, 240, GZDeviceWidth, 60);
    item4.backgroundColor = [UIColor colorWithRed:(225/255.0f) green:( 250/255.0f) blue:(215/255.0f) alpha:1.0f];
    
    UIImage* image4 = [UIImage imageNamed:@"check_update"];
    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:image4];
    imageView4.frame = CGRectMake(20, 15, 30, 30);
    //自适应图片宽高比例
    imageView4.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelCheck = [[UILabel alloc] init];
    labelCheck.frame = CGRectMake(70, 15, 80, 30);
    labelCheck.text = @"检查更新";
    [item4 addSubview:labelCheck];
    
    [item4 addSubview:imageView4];
    [self.view addSubview:item4];
    
    
    
    
    UIView* item5 = [[UIView alloc] init];
    item5.frame = CGRectMake(0, 300, GZDeviceWidth, 60);
    item5.backgroundColor = [UIColor colorWithRed:(250/255.0f) green:( 233/255.0f) blue:(252/255.0f) alpha:1.0f];
    
    UIImage* image5 = [UIImage imageNamed:@"quit_btn"];
    UIImageView* imageView5 = [[UIImageView alloc] initWithImage:image5];
    imageView5.frame = CGRectMake(20, 15, 30, 30);
    //自适应图片宽高比例
    imageView5.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelLogout = [[UILabel alloc] init];
    labelLogout.frame = CGRectMake(70, 15, 80, 30);
    labelLogout.text = @"退出登录";
    [item5 addSubview:labelLogout];
    
    [item5 addSubview:imageView5];
    [self.view addSubview:item5];
    
    //添加手势
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout)];
    
    [item5 addGestureRecognizer:tapGesture];
    
    
}
-(void) logout
{
    
    __weak SettingController* safeSelf = self;
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:@"您确定要退出登录吗?" withTitle:@"提示" contentView: nil];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            
            safeSelf.progress = [ToolsObject showLoading:@"加载中" with:safeSelf];
            [safeSelf loginOut:^(NSString *errorMsg, id result) {
                if(![errorMsg isEqualToString:@""]){
                    [ToolsObject show:errorMsg With:safeSelf];
                }else{
                    [ToolsObject saveHaseLogin:NO];
                    LoginController *vc = [[LoginController alloc] init];
                    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = nvc;
                }
            }];
        }else{
            
        }
    }];

//    [self jumpViewControllerAndCloseSelf:loginPage];
//    for(UIViewController*temp in self.navigationController.viewControllers) {
//        if([temp isKindOfClass:[LoginController class]]){
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
}


-(void)jumpViewControllerAndCloseSelf:(UIViewController *)vc{
    
    NSArray *viewControlles = self.navigationController.viewControllers;
    
        NSMutableArray *newviewControlles = [NSMutableArray array];
    
      if ([viewControlles count] > 0) {
        
            for (int i=0; i < [viewControlles count]-1; i++) {
            
                    [newviewControlles addObject:[viewControlles objectAtIndex:i]];
            
                }
        
        }//首佳演示
    
    [newviewControlles addObject:vc];
    
    [self.navigationController setViewControllers:newviewControlles animated:YES];
    
}



//更新数据
#pragma 更新数据
-(void)updateData:(UITapGestureRecognizer *)tap{
    //这里查询了本地数据
    __weak SettingController *safeSelf = self;
    self.errorMsg = @"";
    self.progress = [ToolsObject showLoading:@"加载中" with:self];

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getFirstIconList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }
        dispatch_group_leave(group);
    }];
    
   
    dispatch_group_enter(group);
    
    [self getPersonRepairList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_enter(group);
    
    [self getPartsList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }
        dispatch_group_leave(group);
    }];
    
    
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [safeSelf.progress hideAnimated:YES];
        if(![safeSelf.errorMsg isEqualToString:@""]){
            [ToolsObject show:safeSelf.errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"更新数据成功！" With:safeSelf];

        }
        
    });
}

#pragma 获取第一页的数据
-(void)getFirstIconList:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_maintenance_category";//车间管理
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [FirstIconInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            [[DataBaseTool shareInstance] insertFirstIconListData:array];
            callback(@"",items);

        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

-(void)loginOut:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_user_logout";//车间管理
    dict[@"operater_code"] = [ToolsObject getUserName];//车间管理
    dict[@"operater_ip"]= [RequestIPAddress getIPAddress:YES];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"true"]){
            callback(@"",nil);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


#pragma 更新修理数据
-(void)getPersonRepairList:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repairman";//车间管理
    dict[@"company_code"] = @"A";//车间管理
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [RepairInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个

            [[DataBaseTool shareInstance] insertRepairListData:array];
            callback(@"",items);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 更新配件数据
-(void)getPartsList:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_stock";//车间管理
    dict[@"comp_code"] = @"A";//车间管理
    dict[@"pjbm"] = @"";//车间管理
    dict[@"cd"] = @"";//车间管理
    dict[@"ck"] = @"";//车间管理

    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [PartsModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个

            [[DataBaseTool shareInstance] insertPartsListData:array];
            callback(@"",items);

        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


-(void) viewDidLoad
{
    [self initView];
}

@end
