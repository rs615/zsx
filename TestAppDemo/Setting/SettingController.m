//
//  SettingController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//
#import "SettingController.h"
#import "LoginController.h"
#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define GZDeviceHeight ([UIScreen mainScreen].bounds.size.height)
@interface SettingController()

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
    LoginController* loginPage = [[LoginController alloc] init];
    
    [self jumpViewControllerAndCloseSelf:loginPage];

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


-(void) viewDidLoad
{
    [self initView];
}
@end
