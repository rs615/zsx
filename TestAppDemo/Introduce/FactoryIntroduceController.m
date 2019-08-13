//
//  FactoryIntroduceController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//
#import "FactoryIntroduceController.h"
#import "FarctoryListController.h"

@interface FactoryIntroduceController ()

@end

@implementation FactoryIntroduceController

-(void) viewWillAppear:(BOOL)animated
{
        self.navigationItem.title = @"整厂概况";
}

-(void) initView
{
    UILabel* label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(50, 100, 90, 30);
    label1.text=@"今日进厂";
    
    UILabel* label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(180, 100, 90, 30);
    label2.text=@"在厂车辆";
    
    UILabel* label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(280, 100, 90, 30);
    label3.text=@"今日出厂";
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    
    
    UILabel* labelText1 = [[UILabel alloc] init];
    labelText1.frame = CGRectMake(80, 140, 90, 30);
    labelText1.text=@"0";
    
    UILabel* labelText2 = [[UILabel alloc] init];
    labelText2.frame = CGRectMake(210, 140, 90, 30);
    labelText2.text=@"72";
    
    UILabel* labelText3 = [[UILabel alloc] init];
    labelText3.frame = CGRectMake(310, 140, 90, 30);
    labelText3.text=@"0";
    
    [self.view addSubview:labelText1];
    [self.view addSubview:labelText2];
    [self.view addSubview:labelText3];
    
    
    UIImage* image = [UIImage imageNamed:@"gray_back_introduce"];
    UIImageView* imageView1 = [[UIImageView alloc] initWithImage:image];
    imageView1.frame = CGRectMake(60, 180, 100, 120);
    imageView1.layer.cornerRadius = 0;
    imageView1.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView1];
    
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image];
    imageView2.frame = CGRectMake(160, 180, 100, 120);
    imageView2.layer.cornerRadius = 0;
    imageView2.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];
    
    
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:image];
    imageView3.frame = CGRectMake(260, 180, 100, 120);
    imageView3.layer.cornerRadius = 0;
    imageView3.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView3];
    
    
    
    UIImageView* imageView4= [[UIImageView alloc] initWithImage:image];
    imageView4.frame = CGRectMake(60, 290, 100, 120);
    imageView4.layer.cornerRadius = 0;
    imageView4.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView4.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView4];
    
    
    UIImageView* imageView5 = [[UIImageView alloc] initWithImage:image];
    imageView5.frame = CGRectMake(160, 290, 100, 120);
    imageView5.layer.cornerRadius = 0;
    imageView5.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView5.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView5];
    
    
    UIImageView* imageView6 = [[UIImageView alloc] initWithImage:image];
    imageView6.frame = CGRectMake(260, 290, 100, 120);
    imageView6.layer.cornerRadius = 0;
    imageView6.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView6.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView6];
    
    
    UIImageView* imageView7 = [[UIImageView alloc] initWithImage:image];
    imageView7.frame = CGRectMake(160, 400, 100, 120);
    imageView7.layer.cornerRadius = 0;
    imageView7.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView7.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView7];
    
    
    UILabel* labelCard1 = [[UILabel alloc] init];
    labelCard1.frame = CGRectMake(80, 200, 90, 30);
    labelCard1.textColor=[UIColor whiteColor];
    labelCard1.text=@"估价中";
    
    UILabel* labelCard2 = [[UILabel alloc] init];
    labelCard2.frame = CGRectMake(180, 200, 90, 30);
    labelCard2.textColor=[UIColor whiteColor];
    labelCard2.text=@"待派工";
    
    UILabel* labelCard3 = [[UILabel alloc] init];
    labelCard3.frame = CGRectMake(280, 200, 90, 30);
    labelCard3.textColor=[UIColor whiteColor];
    labelCard3.text=@"待领工";
    
    [self.view addSubview:labelCard1];
    [self.view addSubview:labelCard2];
    [self.view addSubview:labelCard3];
    
    
    
    UILabel* labelCardTxt1 = [[UILabel alloc] init];
    labelCardTxt1.frame = CGRectMake(60, 240, 90, 30);
    labelCardTxt1.textColor=[UIColor whiteColor];
    labelCardTxt1.textAlignment = UITextAlignmentCenter;
    labelCardTxt1.text=@"37";
    
    UILabel* labelCardTxt2 = [[UILabel alloc] init];
    labelCardTxt2.frame = CGRectMake(160, 240, 90, 30);
    labelCardTxt2.textColor=[UIColor whiteColor];
    labelCardTxt2.textAlignment = UITextAlignmentCenter;
    labelCardTxt2.text=@"13";
    
    UILabel* labelCardTxt3 = [[UILabel alloc] init];
    labelCardTxt3.frame = CGRectMake(260, 240, 90, 30);
    labelCardTxt3.textColor=[UIColor whiteColor];
    labelCardTxt3.textAlignment = UITextAlignmentCenter;
    labelCardTxt3.text=@"7";
    
    [self.view addSubview:labelCardTxt1];
    [self.view addSubview:labelCardTxt2];
    [self.view addSubview:labelCardTxt3];
    
    
    
    
    
    UILabel* labelCard4 = [[UILabel alloc] init];
    labelCard4.frame = CGRectMake(80, 310, 90, 30);
    labelCard4.textColor=[UIColor whiteColor];
    labelCard4.text=@"修理中";
    
    UILabel* labelCard5 = [[UILabel alloc] init];
    labelCard5.frame = CGRectMake(180, 310, 90, 30);
    labelCard5.textColor=[UIColor whiteColor];
    labelCard5.text=@"待质检";
    
    UILabel* labelCard6 = [[UILabel alloc] init];
    labelCard6.frame = CGRectMake(280, 310, 90, 30);
    labelCard6.textColor=[UIColor whiteColor];
    labelCard6.text=@"待结算";
    
    
    UILabel* labelCard7 = [[UILabel alloc] init];
    labelCard7.frame = CGRectMake(180, 420, 90, 30);
    labelCard7.textColor=[UIColor whiteColor];
    labelCard7.text=@"待出厂";
    
    
    [self.view addSubview:labelCard4];
    [self.view addSubview:labelCard5];
    [self.view addSubview:labelCard6];
    [self.view addSubview:labelCard7];
    
    
    
    UILabel* labelCardTxt4 = [[UILabel alloc] init];
    labelCardTxt4.frame = CGRectMake(60, 350, 90, 30);
    labelCardTxt4.textColor=[UIColor whiteColor];
    labelCardTxt4.textAlignment = UITextAlignmentCenter;
    labelCardTxt4.text=@"37";
    
    UILabel* labelCardTxt5 = [[UILabel alloc] init];
    labelCardTxt5.frame = CGRectMake(160, 350, 90, 30);
    labelCardTxt5.textColor=[UIColor whiteColor];
    labelCardTxt5.textAlignment = UITextAlignmentCenter;
    labelCardTxt5.text=@"13";
    
    UILabel* labelCardTxt6 = [[UILabel alloc] init];
    labelCardTxt6.frame = CGRectMake(260, 350, 90, 30);
    labelCardTxt6.textColor=[UIColor whiteColor];
    labelCardTxt6.textAlignment = UITextAlignmentCenter;
    labelCardTxt6.text=@"7";
    
    UILabel* labelCardTxt7 = [[UILabel alloc] init];
    labelCardTxt7.frame = CGRectMake(160, 460, 90, 30);
    labelCardTxt7.textColor=[UIColor whiteColor];
    labelCardTxt7.textAlignment = UITextAlignmentCenter;
    labelCardTxt7.text=@"13";
    
    [self.view addSubview:labelCardTxt4];
    [self.view addSubview:labelCardTxt5];
    [self.view addSubview:labelCardTxt6];
    [self.view addSubview:labelCardTxt7];
    
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetailPage)];
    [imageView1 addGestureRecognizer:singleTap];
    imageView1.userInteractionEnabled = YES;
    //在controller中设置按钮的目标-动作，其中目标是self，也就是控制器自身，动作是用目标提供的BtnClick:方法，
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetailPage)];
    [imageView1 addGestureRecognizer:tapGesture];
    
    
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:tapGesture];
    
    imageView3.userInteractionEnabled = YES;
    [imageView3 addGestureRecognizer:tapGesture];
    
    imageView4.userInteractionEnabled = YES;
    [imageView4 addGestureRecognizer:tapGesture];
    
     imageView5.userInteractionEnabled = YES;
    [imageView5 addGestureRecognizer:tapGesture];
   
    imageView6.userInteractionEnabled = YES;
    [imageView6 addGestureRecognizer:tapGesture];
    
    imageView7.userInteractionEnabled = YES;
    [imageView7 addGestureRecognizer:tapGesture];
    
   
  
}

-(void)toDetailPage
{
    FarctoryListController* homePage = [[FarctoryListController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homePage];
    homePage.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#F0F0F0"];
    [self presentViewController:navController animated:YES completion:nil];
    [self.navigationController pushViewController:homePage animated:YES];//从当前界面到nextVC这个界面
    
}

-(void) viewDidLoad
{
    
    [self initView];
}
@end
