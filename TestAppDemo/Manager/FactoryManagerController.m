//
//  FactoryManagerController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "FactoryManagerController.h"
#import "ZXBHeader.h"
#import "EBDropdownListView.h"
@interface FactoryManagerController ()

@end

@implementation FactoryManagerController


-(void) viewWillAppear:(BOOL)animated
{
  self.navigationItem.title = @"车间管理";
}

-(void) initView
{
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"待领工",@"修理中",@"待质检",@"已完工", nil];
    //初始化UISegmentedControl
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    segment.frame = CGRectMake(0, 65, self.view.frame.size.width, 40);
    segment.backgroundColor = [UIColor grayColor];
    //去掉中间的分割线
   
 
//    [segment setDividerImage:_dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
    segment.layer.masksToBounds = YES;               //    默认为no，不设置则下面一句无效
    segment.layer.cornerRadius = 0;               //    设置圆角大小，同UIView
    segment.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    segment.layer.borderColor =   [UIColor whiteColor].CGColor;
    //segment.frame = CGRectMake(0, 0.15029*CFG, 0.2716*CFW, 0.0814*CFG); // 0.3642*CFW
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    //    选中的颜色
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    //    未选中的颜色
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //添加到主视图
    [self.view addSubview:segment];
    

    //下拉列表
    EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"item1"];
    EBDropdownListView *dropdownListView = [[EBDropdownListView alloc] initWithDataSource:@[item1, item1, item1, item1]];
    
    dropdownListView.frame = CGRectMake(20, segment.frame.origin.y+segment.frame.size.height+10, 80, 30);
    dropdownListView.selectedIndex = 2;
    dropdownListView.layer.cornerRadius = 6;
    dropdownListView.layer.borderWidth = 1;
    dropdownListView.layer.masksToBounds = YES;
    [dropdownListView setViewBorder:0.5 borderColor:SetColor(@"#F1A2B4", 1) cornerRadius:2];
    [self.view addSubview:dropdownListView];
   

    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(MainS_Width-20-50, segment.frame.origin.y+segment.frame.size.height+10, 50, 30);
    imageView2.layer.cornerRadius = 6;
    imageView2.layer.masksToBounds = YES;
    //自适应图片宽高比例
//    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];
    
    //添加搜索框
    UITextField * textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(dropdownListView.frame.origin.x+dropdownListView.frame.size.width+10, segment.frame.origin.y+segment.frame.size.height+10,imageView2.frame.origin.x-20-100, 30)];
    textFieldSearch.placeholder = @" 输入";
    textFieldSearch.layer.borderWidth = 1;
    textFieldSearch.layer.masksToBounds = YES;
    textFieldSearch.layer.cornerRadius = 6;
    textFieldSearch.layer.borderColor = SetColor(@"#F1A2B4", 1).CGColor;
    [self.view addSubview:textFieldSearch];
    
    //排序方式
    UIImage* upImage = [UIImage imageNamed:@"sjx_up"];
    UIImage* downImage = [UIImage imageNamed:@"sjx_down"];
    
    UIView* enterFactoryView = [[UIView alloc] initWithFrame:CGRectMake(40, textFieldSearch.frame.origin.y+textFieldSearch.frame.size.height+10,(MainS_Width-80)/3, 20)];
    UIButton* enterFactoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
    enterFactoryBtn.tag = 1000;
    [enterFactoryBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
  
    [enterFactoryBtn setImage:downImage forState:UIControlStateNormal];
    [enterFactoryBtn setImage:upImage forState:UIControlStateSelected];
//    UIImageView* imageViewEnterFactory = [[UIImageView alloc] initWithImage:imageEnterFactory];
//    imageViewEnterFactory.frame = CGRectMake(0,0,30,30) ;
//    imageViewEnterFactory.tag = 1000;
//    [enterFactoryView addSubview:imageViewEnterFactory];
    [enterFactoryView addSubview:enterFactoryBtn];
    UILabel* enterFactoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,0, (MainS_Width-80)/3-30-10, 20)];
    enterFactoryLabel.text = @"进厂时间";
    [enterFactoryView addSubview:enterFactoryLabel];
    [enterFactoryView setTag:100];
    [self.view addSubview:enterFactoryView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderBy:)];
    enterFactoryView.userInteractionEnabled = YES;
    [enterFactoryView addGestureRecognizer:tap];
    
    UIView* interchangeView = [[UIView alloc] initWithFrame:CGRectMake(enterFactoryView.frame.origin.x+enterFactoryView.frame.size.width, textFieldSearch.frame.origin.y+textFieldSearch.frame.size.height+10,(MainS_Width-80)/3, 20)];
//    UIImage* interchangeViewImage = [UIImage imageNamed:@"sjx_down"];
//    UIImageView* interchangeImageView = [[UIImageView alloc] initWithImage:interchangeViewImage];
//    interchangeImageView.frame = CGRectMake(0,0,30,30) ;
//    [interchangeView addSubview:interchangeImageView];
    UIButton* interchangeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
    interchangeBtn.tag = 1001;
    [interchangeBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [interchangeBtn setImage:downImage forState:UIControlStateNormal];
    [interchangeBtn setImage:upImage forState:UIControlStateSelected];
    [interchangeView addSubview:interchangeBtn];
    UILabel* interchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,0, (MainS_Width-80)/3-30-10, 20)];
    interchangeLabel.text = @"交车时间";
    interchangeView.tag = 101;
    [interchangeView addSubview:interchangeLabel];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderBy:)];
    interchangeView.userInteractionEnabled = YES;
    [interchangeView addGestureRecognizer:tap2];
    [self.view addSubview:interchangeView];
    
    UIImage* right_now_noImage = [UIImage imageNamed:@"right_now_no"];
    UIImage* right_now = [UIImage imageNamed:@"right_now"];

    UIView* myTaskView = [[UIView alloc] initWithFrame:CGRectMake(interchangeView.frame.origin.x+interchangeView.frame.size.width, textFieldSearch.frame.origin.y+textFieldSearch.frame.size.height+10,(MainS_Width-80)/3, 20)];
    UIButton* myTaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
    myTaskBtn.tag = 1002;
    [myTaskBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [myTaskBtn setImage:right_now_noImage forState:UIControlStateNormal];
    [myTaskBtn setImage:right_now forState:UIControlStateSelected];
    myTaskView.tag = 102;

    [myTaskView addSubview:myTaskBtn];
    UILabel* myTaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,0, (MainS_Width-80)/3-30-10, 20)];
    myTaskLabel.text = @"我的任务";
    [myTaskView addSubview:myTaskLabel];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderBy:)];
    myTaskView.userInteractionEnabled = YES;
    [myTaskView addGestureRecognizer:tap3];
    [self.view addSubview:myTaskView];
    
    
}
-(void) viewDidLoad
{
    [self initView];
  
}

#pragma mark -排序
-(void)orderBy:(UITapGestureRecognizer *)tap{
    NSInteger tag =  tap.view.tag;
    if(tag==100){
        //进厂
        UIButton* btn = [tap.view viewWithTag:1000];
        btn.selected = !btn.selected;
    }else if(tag==101){
        //交车
        UIButton* btn = [tap.view viewWithTag:1001];
        btn.selected = !btn.selected;
    }else if(tag==102){
        //交车
        UIButton* btn = [tap.view viewWithTag:1002];
        btn.selected = !btn.selected;
    }}

-(void)sendAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

@end

