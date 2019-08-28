//
//  PerformanceController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/18.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "PerformanceController.h"
#import "BRPickerView.h"

typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface PerformanceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *sgjxLabel;
@property (nonatomic, strong) UILabel *xsjxLabel;
@property (nonatomic, strong) UIView* baseView;
@property (nonatomic, strong) UIView* moreView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;

@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic,strong)NSMutableDictionary* cardData;
@property (nonatomic,strong)NSMutableDictionary* jieDaiData;
@property (nonatomic,strong)NSMutableDictionary* shiGongData;
@property (nonatomic,strong)NSMutableArray* yejiGroupListData;
@property (nonatomic,strong)NSMutableArray* shigongGroupListData;

@end

@implementation PerformanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的绩效" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"home_icon" rightAction:@selector(backHome) withVC:self];
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, MainS_Width, 40*PXSCALEH)];
    view.backgroundColor = SetColor(@"#A58BBA", 1);
    UILabel* nameLabel =  [PublicFunction getlabel:CGRectMake(0, 0, MainS_Width/2,  40*PXSCALEH) text:[NSString stringWithFormat:@"姓名:%@",[ToolsObject getUserName]] fontSize:navTitleFont color:[UIColor whiteColor] align:@"center"];
    UILabel* jxsjLabel =  [PublicFunction getlabel:CGRectMake( MainS_Width/2, 0, MainS_Width/2,  40*PXSCALEH) text:@"当月绩效数据" fontSize:navTitleFont color:[UIColor whiteColor] align:@"center"];
    [view addSubview:nameLabel];
    [view addSubview:jxsjLabel];
    [self.view addSubview:view];
    
    _sgjxLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, view.frame.origin.y+view.bounds.size.height, (MainS_Width-40*PXSCALE)/2,  40*PXSCALEH) text:@"施工绩效:" fontSize:14 color:[UIColor blackColor] align:@"left"];
    _xsjxLabel = [PublicFunction getlabel:CGRectMake(_sgjxLabel.frame.origin.x+_sgjxLabel.frame.size.width, view.frame.origin.y+view.frame.size.height, (MainS_Width-40*PXSCALE)/2,  40*PXSCALEH) text:@"销售绩效:" fontSize:14 color:[UIColor blackColor] align:@"left"];
    [self.view addSubview:_sgjxLabel];
    [self.view addSubview:_xsjxLabel];
    
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"销售",@"施工", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    segment.frame = CGRectMake(0, _sgjxLabel.frame.origin.y+_sgjxLabel.frame.size.height, MainS_Width, 40*PXSCALEH);
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
    
    __weak PerformanceController *safeSelf = self;
    
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString* startDateStr = [NSString stringWithFormat:@"%@01",[dateStr substringToIndex:dateStr.length-2]];
    _startDateLabel = [PublicFunction getlabel:CGRectMake(70*PXSCALE, segment.frame.origin.y+segment.bounds.size.height+10*PXSCALEH, (MainS_Width-160*PXSCALE)/2, 40*PXSCALEH) text:startDateStr fontSize:15 color:SetColor(@"#111111", 1.0) align:@"center"];
    _startDateLabel.backgroundColor = SetColor(@"#E6E4E7", 1);
    _startDateLabel.tag = 1000;
    _endDateLabel = [PublicFunction getlabel:CGRectMake(MainS_Width-70*PXSCALEH-_startDateLabel.bounds.size.width, _startDateLabel.frame.origin.y, (MainS_Width-160*PXSCALE)/2, 40*PXSCALEH) text:dateStr fontSize:15 color:SetColor(@"#111111", 1.0) align:@"center"];
    _endDateLabel.backgroundColor = SetColor(@"#E6E4E7", 1);
    _endDateLabel.tag = 1001;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    _startDateLabel.userInteractionEnabled = YES;
    [_startDateLabel addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    _endDateLabel.userInteractionEnabled = YES;
    [_endDateLabel addGestureRecognizer:tap2];
    UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(_startDateLabel.frame.origin.x+_startDateLabel.bounds.size.width,  _startDateLabel.frame.origin.y, 20*PXSCALE, 40) text:@"至" fontSize:navTitleFont color:SetColor(@"#111111", 1.0) align:@"center"];
    
    [self.view addSubview:_endDateLabel];
    [self.view addSubview:_startDateLabel];
    [self.view addSubview:titleLabel];
    
    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(_endDateLabel.frame.origin.y+_endDateLabel.bounds.size.width+10*PXSCALE, _startDateLabel.frame.origin.y+5*PXSCALEH, 40, 30);
    imageView2.layer.cornerRadius = 6;
    imageView2.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];

    //添加搜索事件
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:tap0];
    
    //baseview
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _startDateLabel.bounds.size.height+_startDateLabel.frame.origin.y+10*PXSCALEH, MainS_Width, 40*5*PXSCALEH)];
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width/3-10*PXSCALE, 40*5*PXSCALEH)];
    leftView.backgroundColor = SetColor(@"#F7E3E2", 1);
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/3-10*PXSCALE, 0, MainS_Width-leftView.bounds.size.width, 40*5*PXSCALEH)];
    rightView.backgroundColor = lightGrayColor;
    
    
    NSArray* saleArray = @[@"接待次数",@"销售项目数",@"销售总金额",@"销售利润",@"销售绩效"];
    for(int i=0;i<saleArray.count;i++){
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0 ,40*PXSCALE*i, leftView.bounds.size.width, 40*PXSCALEH) text:[saleArray objectAtIndex:i] fontSize:15 color:SetColor(@"#111111", 1.0) align:@"center"];
        [leftView addSubview:titleLabel];
        UILabel* valueLabel =  [PublicFunction getlabel:CGRectMake(titleLabel.frame.origin.x+10*PXSCALE,40*PXSCALE*i, titleLabel.bounds.size.width, 40*PXSCALEH) text:@"" fontSize:15 color:SetColor(@"#111111", 1.0) align:@"left"];
        valueLabel.tag = 100+i;
        [rightView addSubview:valueLabel];
    }
    
    [_baseView addSubview:leftView];
    [_baseView addSubview:rightView];
    [self.view addSubview:_baseView];
    
    //更多view
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, _startDateLabel.bounds.size.height+_startDateLabel.frame.origin.y+10*PXSCALEH, MainS_Width, 40*6*PXSCALEH)];

    NSArray* sgArray = @[@"施工次数",@"施工项目数",@"项目总额",@"项目利润",@"总工时",@"施工绩效"];
    UIView* leftMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width/3-10*PXSCALE, 40*6*PXSCALEH)];
    leftMoreView.backgroundColor = SetColor(@"#F7E3E2", 1);
    UIView* rightMoreView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/3-10*PXSCALE, 0, MainS_Width-leftMoreView.bounds.size.width, 40*6*PXSCALEH)];
    rightMoreView.backgroundColor = lightGrayColor;

    for(int i=0;i<sgArray.count;i++){
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0 ,40*PXSCALE*i, leftMoreView.bounds.size.width, 40*PXSCALEH) text:[sgArray objectAtIndex:i] fontSize:15 color:SetColor(@"#111111", 1.0) align:@"center"];
        [leftMoreView addSubview:titleLabel];
        UILabel* valueLabel =  [PublicFunction getlabel:CGRectMake(titleLabel.frame.origin.x+10*PXSCALE,40*PXSCALE*i, titleLabel.bounds.size.width, 40*PXSCALEH) text:@"" fontSize:15 color:SetColor(@"#111111", 1.0) align:@"left"];
        valueLabel.tag = 110+i;
        [rightMoreView addSubview:valueLabel];
    }
    [_moreView addSubview:leftMoreView];
    [_moreView addSubview:rightMoreView];
    [self.view addSubview:_moreView];
    _moreView.hidden = YES;

    NSArray* array = @[@"项目名称",@"销售项目数",@"销售总额",@"销售利润",@"销售绩效"];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.frame.origin.y+_baseView.bounds.size.height+10*PXSCALEH, MainS_Width, 40*PXSCALEH)];
    UIView* valueBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*PXSCALEH, MainS_Width, 40*PXSCALEH)];
    valueBackgroundView.backgroundColor = lightGrayColor;
    for(int i=0;i<array.count;i++){
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/5 ,0, MainS_Width/5, 40*PXSCALEH) text:[array objectAtIndex:i] fontSize:12 color:SetColor(@"#111111", 1.0) align:@"center"];
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/5 , 0, MainS_Width/5, 40*PXSCALEH) text:@"" fontSize:12 color:SetColor(@"#111111", 1.0) align:@"center"];
        valueLabel.tag = 120+i;
        [_bottomView addSubview:titleLabel];
        [valueBackgroundView addSubview:valueLabel];
    }
    [_bottomView addSubview:valueBackgroundView];
    [self.view addSubview:_bottomView];
//
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,_bottomView.frame.origin.y+_bottomView.bounds.size.height, MainS_Width, MainS_Height-_baseView.frame.origin.y-_baseView.bounds.size.height-60*PXSCALEH)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}


-(void)initData{
    __weak PerformanceController *safeSelf = self;

    self.progress = [ToolsObject showLoading:@"加载中" with:self];
  
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [self getCardListData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.cardData = result;
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);

    [self getJieDaiData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.jieDaiData = result;
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);

    [self getShigongData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.shiGongData = result;
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);

   
    [self getYejiFenzuData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.yejiGroupListData = result;
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);

    
    [self getShigongFenzuData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.shigongGroupListData = result;
        }
        dispatch_group_leave(group);
    }];
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [safeSelf.progress hideAnimated:YES];

        if(![safeSelf.errorMsg isEqualToString:@""]){
            [ToolsObject show:safeSelf.errorMsg With:safeSelf];
        }
        [safeSelf updateCard];
        [safeSelf updateJieChe];
        [safeSelf updateShigong];
        [safeSelf.tableView reloadData];
    });
   
}

#pragma segment选择
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.baseView.hidden = NO;
            self.moreView.hidden = YES;
            self.bottomView.frame = CGRectMake(0, _baseView.frame.origin.y+_baseView.bounds.size.height+10*PXSCALEH, MainS_Width, 40*PXSCALEH);
            self.tableView.frame = CGRectMake(0 ,_bottomView.frame.origin.y+_bottomView.bounds.size.height, MainS_Width, MainS_Height-_baseView.frame.origin.y-_baseView.bounds.size.height-60*PXSCALEH);
            [self.tableView reloadData];
            break;
        case 1:
            self.baseView.hidden = YES;
            self.moreView.hidden = NO;
            self.bottomView.frame = CGRectMake(0, _moreView.frame.origin.y+_moreView.bounds.size.height+10*PXSCALEH, MainS_Width, 40*PXSCALEH);
            self.tableView.frame = CGRectMake(0 ,_bottomView.frame.origin.y+_bottomView.bounds.size.height, MainS_Width, MainS_Height-_moreView.frame.origin.y-_moreView.bounds.size.height-60*PXSCALEH);
            [self.tableView reloadData];

            break;
        default:
            NSLog(@"3");
            break;
    }
}


-(void)selectDate:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    __weak PerformanceController *safeSelf = self;
    
    if(tag==1000){
        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:BRDatePickerModeYMD defaultSelValue:_startDateLabel.text minDate:nil maxDate:[ToolsObject stringToDate:_endDateLabel.text] isAutoSelect:NO themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            safeSelf.startDateLabel.text = selectValue;
        }];
        
    }else if(tag==1001){
        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:BRDatePickerModeYMD defaultSelValue:_endDateLabel.text minDate:[ToolsObject stringToDate:_startDateLabel.text] maxDate:nil isAutoSelect:NO themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            safeSelf.endDateLabel.text = selectValue;
        }];
    }

}

-(void)getCardListData:(asyncCallback)callback{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_query_achievement";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"employee"] = @"superuser";
    dict[@"dates"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDateLabel.text];
    dict[@"datee"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDateLabel.text];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableDictionary* dict = [items objectAtIndex:0];
            callback(@"",dict);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取接车数据
-(void)getJieDaiData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_query_achievement_sale";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"employee"] = @"superuser";
    dict[@"dates"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDateLabel.text];
    dict[@"datee"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDateLabel.text];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableDictionary* dict = [items objectAtIndex:0];
            callback(@"",dict);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取施工数据
-(void)getShigongData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_query_achievement_repair";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"employee"] = @"superuser";
    dict[@"dates"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDateLabel.text];
    dict[@"datee"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDateLabel.text];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableDictionary* dict = [items objectAtIndex:0];
            callback(@"",dict);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取销售业绩分组数据
-(void)getYejiFenzuData:(asyncCallback)callback{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_query_achievement_collect";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"employee"] = @"superuser";
    dict[@"dates"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDateLabel.text];
    dict[@"datee"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDateLabel.text];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
//            NSMutableDictionary* dict = [items objectAtIndex:0];
            callback(@"",items);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


#pragma 获取施工分组数据
-(void)getShigongFenzuData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_query_achievement_collect_repair";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"employee"] = @"superuser";
    dict[@"dates"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDateLabel.text];
    dict[@"datee"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDateLabel.text];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
//            NSMutableDictionary* dict = [items objectAtIndex:0];
            callback(@"",items);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 更新卡片数据
-(void)updateCard{
    if(self.cardData.count>0){
        self.sgjxLabel.text = [NSString stringWithFormat:@"施工绩效:%@",[self.cardData objectForKey:@"repair_achievement"]];
        self.xsjxLabel.text = [NSString stringWithFormat:@"销售绩效:%@",[self.cardData objectForKey:@"sale_achievement"]];
    }
    
}

#pragma 分组数据
-(void)updateGroup:(NSMutableDictionary*)dict{
    ((UILabel*)[self.view viewWithTag:120]).text = [dict objectForKey:@"service_time"];
    ((UILabel*)[self.view viewWithTag:121]).text = [dict objectForKey:@"sale_time"];
    ((UILabel*)[self.view viewWithTag:122]).text = [dict objectForKey:@"sale_money"];
    ((UILabel*)[self.view viewWithTag:123]).text = [dict objectForKey:@"sale_profit"];
    ((UILabel*)[self.view viewWithTag:124]).text = [dict objectForKey:@"sale_achievement"];
}


#pragma 接车
-(void)updateJieChe{
    if(self.jieDaiData.count>0){
        ((UILabel*)[self.view viewWithTag:100]).text = [self.jieDaiData objectForKey:@"service_time"];
        ((UILabel*)[self.view viewWithTag:101]).text = [self.jieDaiData objectForKey:@"sale_time"];
        ((UILabel*)[self.view viewWithTag:102]).text = [self.jieDaiData objectForKey:@"sale_money"];
        ((UILabel*)[self.view viewWithTag:103]).text = [self.jieDaiData objectForKey:@"sale_profit"];
        ((UILabel*)[self.view viewWithTag:104]).text = [self.jieDaiData objectForKey:@"sale_achievement"];
    }
    
}

#pragma 施工
-(void)updateShigong{
    if(self.shiGongData.count>0){
        ((UILabel*)[self.view viewWithTag:110]).text = [self.shiGongData objectForKey:@"service_time"];
        ((UILabel*)[self.view viewWithTag:111]).text = [self.shiGongData objectForKey:@"repair_time"];
        ((UILabel*)[self.view viewWithTag:112]).text = [self.shiGongData objectForKey:@"repair_money"];
        ((UILabel*)[self.view viewWithTag:113]).text = [self.shiGongData objectForKey:@"repair_profit"];
        ((UILabel*)[self.view viewWithTag:114]).text = [self.shiGongData objectForKey:@"hours"];
        ((UILabel*)[self.view viewWithTag:115]).text = [self.shiGongData objectForKey:@"repair_achievement"];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!self.baseView.hidden){
        return self.yejiGroupListData.count;
    }else{
        return self.shigongGroupListData.count;
    }
    
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
    cell.selectedBackgroundView = [[UIView alloc] init];
    //就这两句代码
    cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 40*PXSCALEH)];
    
    NSMutableDictionary* dict;
    if(!self.baseView.hidden){
        dict = [self.yejiGroupListData objectAtIndex:indexPath.row];
        
    }else{
        dict = [self.shigongGroupListData objectAtIndex:indexPath.row];

    }
    NSArray* array = @[@"项目名称",@"销售项目数",@"销售总额",@"销售利润",@"销售绩效"];
    NSString* serviceTime = dict[@"service_time"]!=nil?dict[@"service_time"]:@"";
    NSString* sale_time = dict[@"sale_time"]!=nil?dict[@"sale_time"]:@"";
    NSString* sale_money = dict[@"sale_money"]!=nil?dict[@"sale_money"]:@"";
    NSString* sale_profit = dict[@"sale_profit"]!=nil?dict[@"sale_profit"]:@"";
    NSString* sale_achievement = dict[@"sale_achievement"]!=nil?dict[@"sale_achievement"]:@"";
    
    NSArray* valueArr = @[serviceTime,sale_time,sale_money,sale_profit,sale_achievement];
    for(int i=0;i<array.count;i++){
        //            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/5 ,0, MainS_Width/5, 40*PXSCALEH) text:[array objectAtIndex:i] fontSize:12 color:SetColor(@"#111111", 1.0) align:@"center"];
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/5 , 0, MainS_Width/5, 40*PXSCALEH) text:valueArr[i] fontSize:12 color:SetColor(@"#111111", 1.0) align:@"center"];
        [contentView addSubview:valueLabel];
    }
    [cell.contentView addSubview:contentView];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40*PXSCALEH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}


#pragma 搜索内容
-(void)searchContent:(UITapGestureRecognizer *)tap{
    [self initData];
}



#pragma mark - Getters
- (NSMutableDictionary *)shiGongData
{
    if (!_shiGongData) {
        _shiGongData = [NSMutableDictionary dictionary];
    }
    return _shiGongData;
}

#pragma mark - Getters
- (NSMutableDictionary *)cardData
{
    if (!_cardData) {
        _cardData = [NSMutableDictionary dictionary];
    }
    return _cardData;
}

#pragma mark - Getters
- (NSMutableDictionary *)jieDaiData
{
    if (!_jieDaiData) {
        _jieDaiData = [NSMutableDictionary dictionary];
    }
    return _jieDaiData;
}

#pragma mark - Getters
- (NSMutableArray *)yejiGroupListData
{
    if (!_yejiGroupListData) {
        _yejiGroupListData = [NSMutableArray array];
    }
    return _yejiGroupListData;
}

#pragma mark - Getters
- (NSMutableArray *)shigongGroupListData
{
    if (!_shigongGroupListData) {
        _shigongGroupListData = [NSMutableArray array];
    }
    return _shigongGroupListData;
}



@end
