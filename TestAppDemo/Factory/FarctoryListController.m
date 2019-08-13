//
//  FarctoryListController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "FarctoryListController.h"
#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define GZDeviceHeight ([UIScreen mainScreen].bounds.size.height)

@interface FarctoryListController ()

@end

@implementation FarctoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

-(void)initView{
    UIView* searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(0, 80, GZDeviceWidth, 40);
    UITextField * textFieldCpSearch = [[UITextField alloc]initWithFrame:CGRectMake(GZDeviceWidth*0.1, 0, GZDeviceWidth*0.7, 40)];
    textFieldCpSearch.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    textFieldCpSearch.placeholder = @"车牌";
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,39, GZDeviceWidth*0.7, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [textFieldCpSearch addSubview:lineView];
    
    [searchView addSubview:textFieldCpSearch];
    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(GZDeviceWidth*0.8, 0, GZDeviceWidth*0.1, 40);
    imageView2.layer.cornerRadius = 8;
    imageView2.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [searchView addSubview:imageView2];
    
    
    [self.view addSubview:searchView];
    
    UIView* redView = [[UIView alloc] init];
    redView.frame = CGRectMake(0,130, GZDeviceWidth, 50);
    redView.backgroundColor = [UIColor colorWithRed:(250/255.0f) green:( 233/255.0f) blue:(252/255.0f) alpha:1.0f];
    UILabel* selectLabel = [[UILabel alloc] init];
    selectLabel.frame = CGRectMake(20, 10, GZDeviceWidth*0.3, 30);
    selectLabel.text = @"估价中";
    selectLabel.backgroundColor = [UIColor colorWithRed:(250/255.0f) green:( 255/255.0f) blue:(255/255.0f) alpha:1.0f];
   
    UILabel* timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(GZDeviceWidth*0.6, 10, GZDeviceWidth*0.3, 30);
    timeLabel.text = @"按时间降序排列";
    timeLabel.textColor = [UIColor blueColor];
    [redView addSubview:selectLabel];
    [redView addSubview:timeLabel];
    [self.view addSubview:redView];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
