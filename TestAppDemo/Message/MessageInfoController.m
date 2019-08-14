//
//  MessageInfoController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "MessageInfoController.h"
#import "PerformanceController.h"
#import "WorkOrderQueryViewController.h"
#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
@interface MessageInfoController ()

@end

@implementation MessageInfoController

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"信息中心";
}


-(void)initView
{
    UIView* item1 = [[UIView alloc] init];
    item1.frame = CGRectMake(0, 60, GZDeviceWidth, 90);
    item1.backgroundColor = [UIColor colorWithRed:(247/255.0f) green:( 249/255.0f) blue:(250/255.0f) alpha:1.0f];
    
    UIView* wdjxView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth/2, 90)];

    UIImage* image1 = [UIImage imageNamed:@"center_person_myself"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image1];
    imageView.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelUpdate = [[UILabel alloc] init];
    labelUpdate.frame = CGRectMake(65, 60, 120, 30);
    labelUpdate.text = @"我的绩效";
    
    wdjxView.tag = 100;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAction:)];
    wdjxView.userInteractionEnabled = YES;
    [wdjxView addGestureRecognizer:tap0];

    [wdjxView addSubview:labelUpdate];
    [wdjxView addSubview:imageView];
    [item1 addSubview:wdjxView];
    
    UIView* khcxView =  [[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2, 0, GZDeviceWidth/2, 90)];
    khcxView.tag = 101;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAction:)];
    khcxView.userInteractionEnabled = YES;
    [khcxView addGestureRecognizer:tap1];
    UIImage* image2 = [UIImage imageNamed:@"center_query"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelQuery = [[UILabel alloc] init];
    labelQuery.frame = CGRectMake(65, 60, 120, 30);
    labelQuery.text = @"客户查询";
    
    
    UIView* line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(GZDeviceWidth/2, 0, 1, 90);
    line1.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    
    [item1 addSubview:line1];
    [khcxView addSubview:labelQuery];
    [khcxView addSubview:imageView2];
    [item1 addSubview:khcxView];

    [self.view addSubview:item1];
    
    UIView* vline1 = [[UIView alloc] init];
    vline1.frame = CGRectMake(0, 150, GZDeviceWidth, 1);
    vline1.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
     [self.view addSubview:vline1];
    
    
    UIView* item2 = [[UIView alloc] init];
    item2.frame = CGRectMake(0, 151, GZDeviceWidth, 90);
    item2.backgroundColor = [UIColor colorWithRed:(247/255.0f) green:( 249/255.0f) blue:(250/255.0f) alpha:1.0f];
    
    UIView* cwglView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth/2, 90)];
    cwglView.tag = 102;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAction:)];
    cwglView.userInteractionEnabled = YES;
    [cwglView addGestureRecognizer:tap2];
    UIImage* image3 = [UIImage imageNamed:@"center_money_manage"];
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:image3];
    imageView3.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelMoney = [[UILabel alloc] init];
    labelMoney.frame = CGRectMake(65, 60, 120, 30);
    labelMoney.text = @"财务管理";
    [cwglView addSubview:labelMoney];
    [cwglView addSubview:imageView3];
    [item2 addSubview:cwglView];
    
    UIView* txzxView =  [[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2, 0, GZDeviceWidth/2, 90)];
    txzxView.tag = 103;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAction:)];
    txzxView.userInteractionEnabled = YES;
    [txzxView addGestureRecognizer:tap3];
    UIImage* image4 = [UIImage imageNamed:@"center_notify"];
    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:image4];
    imageView4.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView4.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelNotify = [[UILabel alloc] init];
    labelNotify.frame = CGRectMake(65, 60, 120, 30);
    labelNotify.text = @"提醒中心";
    
    
    UIView* line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(GZDeviceWidth/2, 0, 1, 90);
    line2.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    
    [item2 addSubview:line2];
    [txzxView addSubview:labelNotify];
    [txzxView addSubview:imageView4];
    [item2 addSubview:txzxView];
    
    UIView* vline2 = [[UIView alloc] init];
    vline2.frame = CGRectMake(0, 241, GZDeviceWidth, 1);
    vline2.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    [self.view addSubview:vline2];
    
    [self.view addSubview:item2];

    
    UIView* item3 = [[UIView alloc] init];
    item3.frame = CGRectMake(0, 242, GZDeviceWidth, 90);
    item3.backgroundColor = [UIColor colorWithRed:(247/255.0f) green:( 249/255.0f) blue:(250/255.0f) alpha:1.0f];
    
    UIView* gdcxView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth/2, 90)];
    UIImage* image5 = [UIImage imageNamed:@"center_work_page"];
    UIImageView* imageView5= [[UIImageView alloc] initWithImage:image5];
    imageView5.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView5.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelOrder = [[UILabel alloc] init];
    labelOrder.frame = CGRectMake(65, 60, 120, 30);
    labelOrder.text = @"工单查询";
    gdcxView.tag = 104;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAction:)];
    gdcxView.userInteractionEnabled = YES;
    [gdcxView addGestureRecognizer:tap4];
    [gdcxView addSubview:labelOrder];
    [gdcxView addSubview:imageView5];
    [item3 addSubview:gdcxView];
    
    
    UIView* jxglView =  [[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2, 0, GZDeviceWidth/2, 90)];
    jxglView.tag = 105;
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAction:)];
    jxglView.userInteractionEnabled = YES;
    [jxglView addGestureRecognizer:tap5];
    UIImage* image6 = [UIImage imageNamed:@"center_level"];
    UIImageView* imageView6 = [[UIImageView alloc] initWithImage:image6];
    imageView6.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView6.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelLevel= [[UILabel alloc] init];
    labelLevel.frame = CGRectMake(65, 60, 120, 30);
    labelLevel.text = @"绩效管理";
    UIView* vline3 = [[UIView alloc] init];
    vline3.frame = CGRectMake(GZDeviceWidth/2, 0, 1, 90);
    vline3.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    [item3 addSubview:vline3];
    [jxglView addSubview:labelLevel];
    [jxglView addSubview:imageView6];
    [item3 addSubview:jxglView];
    [self.view addSubview:item3];
    UIView* vline4 = [[UIView alloc] init];
    vline4.frame = CGRectMake(0, 331, GZDeviceWidth, 1);
    vline4.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    [self.view addSubview:vline4];
    
}


#pragma mark - 搜索车辆
-(void)sendAction:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    UIViewController* vc = nil;
    switch (tag) {
        case 100://  我的绩效
            vc  =[[PerformanceController alloc] init];
            break;
        case 101://  客户查询
            
            break;
        case 102://  财务管理
            
            break;
        case 103://  提醒中心
            
            break;
        case 104://  工单查询
            vc = [[WorkOrderQueryViewController alloc] init];
            break;
        case 105://  绩效管理
            
            break;
        default:
            break;
            
    }
    if(vc!=nil){
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }

    
}

-(void) viewDidLoad
{
    [self initView];
}
@end
