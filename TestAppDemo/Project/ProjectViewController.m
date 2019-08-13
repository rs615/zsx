//
//  ProjectViewController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectViewController.h"
#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
@interface ProjectViewController ()

@end

@implementation ProjectViewController

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"车辆接待";
}


-(void)initView
{
    UIView* item1 = [[UIView alloc] init];
    item1.frame = CGRectMake(GZDeviceWidth*0.1, 60, GZDeviceWidth*0.8, 30);
    item1.backgroundColor = [UIColor colorWithRed:(247/255.0f) green:( 249/255.0f) blue:(250/255.0f) alpha:1.0f];
    
    UILabel* labelUpdate = [[UILabel alloc] init];
    labelUpdate.frame = CGRectMake(65, 60, 120, 30);
    labelUpdate.text = @"公里数";
    [item1 addSubview:labelUpdate];
    
    
    UIImage* image2 = [UIImage imageNamed:@"center_query"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(GZDeviceWidth/2+80, 15, 40, 40);
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelQuery = [[UILabel alloc] init];
    labelQuery.frame = CGRectMake(GZDeviceWidth/2+65, 60, 120, 30);
    labelQuery.text = @"客户查询";
    
    
    UIView* line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(GZDeviceWidth/2, 0, 1, 90);
    line1.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    
    [item1 addSubview:line1];
    [item1 addSubview:labelQuery];
    [item1 addSubview:imageView2];
    [self.view addSubview:item1];
    
    UIView* vline1 = [[UIView alloc] init];
    vline1.frame = CGRectMake(0, 150, GZDeviceWidth, 1);
    vline1.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    [self.view addSubview:vline1];
    
    
    UIView* item2 = [[UIView alloc] init];
    item2.frame = CGRectMake(0, 151, GZDeviceWidth, 90);
    item2.backgroundColor = [UIColor colorWithRed:(247/255.0f) green:( 249/255.0f) blue:(250/255.0f) alpha:1.0f];
    
    UIImage* image3 = [UIImage imageNamed:@"center_money_manage"];
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:image3];
    imageView3.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelMoney = [[UILabel alloc] init];
    labelMoney.frame = CGRectMake(65, 60, 120, 30);
    labelMoney.text = @"财务管理";
    [item2 addSubview:labelMoney];
    [item2 addSubview:imageView3];
    
    
    UIImage* image4 = [UIImage imageNamed:@"center_notify"];
    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:image4];
    imageView4.frame = CGRectMake(GZDeviceWidth/2+80, 15, 40, 40);
    //自适应图片宽高比例
    imageView4.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelNotify = [[UILabel alloc] init];
    labelNotify.frame = CGRectMake(GZDeviceWidth/2+65, 60, 120, 30);
    labelNotify.text = @"提醒中心";
    
    
    UIView* line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(GZDeviceWidth/2, 0, 1, 90);
    line2.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    
    [item2 addSubview:line2];
    [item2 addSubview:labelNotify];
    [item2 addSubview:imageView4];
    [self.view addSubview:item2];
    
    UIView* vline2 = [[UIView alloc] init];
    vline2.frame = CGRectMake(0, 241, GZDeviceWidth, 1);
    vline2.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    [self.view addSubview:vline2];
    
    
    
    
    
    UIView* item3 = [[UIView alloc] init];
    item3.frame = CGRectMake(0, 242, GZDeviceWidth, 90);
    item3.backgroundColor = [UIColor colorWithRed:(247/255.0f) green:( 249/255.0f) blue:(250/255.0f) alpha:1.0f];
    
    UIImage* image5 = [UIImage imageNamed:@"center_work_page"];
    UIImageView* imageView5= [[UIImageView alloc] initWithImage:image5];
    imageView5.frame = CGRectMake(80, 15, 40, 40);
    //自适应图片宽高比例
    imageView5.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelOrder = [[UILabel alloc] init];
    labelOrder.frame = CGRectMake(65, 60, 120, 30);
    labelOrder.text = @"工单查询";
    [item3 addSubview:labelOrder];
    [item3 addSubview:imageView5];
    
    
    UIImage* image6 = [UIImage imageNamed:@"center_level"];
    UIImageView* imageView6 = [[UIImageView alloc] initWithImage:image6];
    imageView6.frame = CGRectMake(GZDeviceWidth/2+80, 15, 40, 40);
    //自适应图片宽高比例
    imageView6.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* labelLevel= [[UILabel alloc] init];
    labelLevel.frame = CGRectMake(GZDeviceWidth/2+65, 60, 120, 30);
    labelLevel.text = @"绩效管理";
    
    
    UIView* vline3 = [[UIView alloc] init];
    vline3.frame = CGRectMake(GZDeviceWidth/2, 0, 1, 90);
    vline3.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    
    [item3 addSubview:vline3];
    [item3 addSubview:labelLevel];
    [item3 addSubview:imageView6];
    [self.view addSubview:item3];
    
    UIView* vline4 = [[UIView alloc] init];
    vline4.frame = CGRectMake(0, 331, GZDeviceWidth, 1);
    vline4.backgroundColor = [UIColor colorWithRed:(213/255.0f) green:( 213/255.0f) blue:(213/255.0f) alpha:1.0f];
    [self.view addSubview:vline4];
    
}


-(void) viewDidLoad
{
    [self initView];
}
@end
