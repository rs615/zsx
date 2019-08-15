//
//  ProjectOrderViewController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectOrderViewController.h"
#import "ProjectModel.h"
#import "PeijianModel.h"
#import "OrderCarInfoModel.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
@interface ProjectOrderViewController ()
@property (nonatomic, strong) UIView* baseView;
@property (nonatomic, strong) UIView* moreView;
@property (nonatomic,strong)NSString* errorMsg;

@end

@implementation ProjectOrderViewController

-(void) viewWillAppear:(BOOL)animated
{
}


-(void)initView
{
    [self setNavTitle:@"工单" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, MainS_Width, 40*PXSCALEH)];
    view.backgroundColor = SetColor(@"#A58BBA", 1);
    UIImageView* headImgView = [PublicFunction getImageView:CGRectMake(10*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_person"];
    UILabel* personLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/4, 0, MainS_Width/4, 40*PXSCALE) text:@"陈明" size:14 align:@"left"];
    [personLabel setTextColor:[UIColor whiteColor]];
    personLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:headImgView];
    [view addSubview:personLabel];
    UIImageView* carImgView = [PublicFunction getImageView:CGRectMake(MainS_Width/2-10*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_yellow"];
    UILabel* carLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/4*3, 0, MainS_Width/4, 40*PXSCALE) text:@"陈明" size:14 align:@"left"];
    [carLabel setTextColor:[UIColor whiteColor]];
    carLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:carLabel];
    [view addSubview:carImgView];
    [self.view addSubview:view];

    
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"项目",@"配件", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    segment.frame = CGRectMake(0, view.frame.origin.y+view.frame.size.height+2*PXSCALEH, MainS_Width, 40*PXSCALEH);
    segment.backgroundColor = [UIColor grayColor];
    segment.layer.masksToBounds = NO;               //    默认为no，不设置则下面一句无效
    segment.layer.cornerRadius = 0;               //    设置圆角大小，同UIView
    segment.layer.borderWidth = 0;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    //segment.frame = CGRectMake(0, 0.15029*CFG, 0.2716*CFW, 0.0814*CFG); // 0.3642*CFW
    segment.selectedSegmentIndex = 0;
    //    segment.tintColor = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    //    选中的颜色
    
    [segment setTintColor:hotPinkColor];
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    //    未选中的颜色
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //添加到主视图
    [self.view addSubview:segment];
    
    //当选中不同的segment时,会触发不同的点击事件
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];
}

#pragma 初始化h数据
-(void)initData{
    __weak ProjectOrderViewController *safeSelf = self;

    //这里查询了本地数据
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [self getProjectListData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [self getPjListData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [self getJsdInfo:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
        }
        dispatch_group_leave(group);
    }];
    
    
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
    });
}

#pragma 结算单
-(void)getJsdInfo:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_repair_list_main";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [OrderCarInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 配件列表
-(void)getPjListData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_jsdmx_pjclmx";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [PeijianModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 项目列表
-(void)getProjectListData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_jsdmx_xlxm";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [ProjectModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma segment选择
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.baseView.hidden = NO;
            self.moreView.hidden = YES;
            break;
        case 1:
            self.baseView.hidden = YES;
            self.moreView.hidden = NO;
            
            break;
        default:
            NSLog(@"3");
            break;
    }
}


-(void) viewDidLoad
{
    [self initView];
    [self initData];
}
@end
