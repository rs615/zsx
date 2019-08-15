//
//  HomeViewController.m
//  TestAppDemo
//  车辆接待
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchCarViewController.h"
#import "CarInfoModel.h"
#import "ToolsObject.h"
#import "ProjectOrderViewController.h"
#import "HNAlertView.h"
#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define GZDeviceHeight ([UIScreen mainScreen].bounds.size.height)

@interface HomeViewController ()
@property (nonatomic, weak) UIView* baseView;
@property (nonatomic, weak) UIView* moreView;
@property (nonatomic, strong) CarInfoModel *carInfo;
@property (nonatomic,strong)UITextField *textFieldCp;
@property (nonatomic,strong)UITextField *textFieldCjh;
@property (nonatomic,strong)UITextField *textFieldCx;
@property (nonatomic,strong)UITextField *textFieldGls;
@property (nonatomic,strong)UITextField *textFieldSxr;
@property (nonatomic,strong)UITextField *textFieldSjh;
@property (nonatomic,strong)UITextField *textFieldChezhu;
@property (nonatomic,strong)UITextField *textFieldGzms;
@property (nonatomic,strong)UITextField *textFieldKeysNo;
@property (nonatomic,strong)UITextField *textFieldTjr;
@property (nonatomic,strong)UITextField *textFieldMemo;
@property (nonatomic,strong)UITextField *textFieldNSDate;
@property (nonatomic,strong)MBProgressHUD *progress;

@end

@implementation HomeViewController

-(void) viewWillAppear:(BOOL)animated
{
     self.navigationItem.title = @"车辆接待";
}

-(void)initView
{
    UIImage* image = [UIImage imageNamed:@"take_photo"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 15, GZDeviceWidth, 200);
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(175, 165, 100, 30);
    label.text=@"拍摄车牌";
    [self.view addSubview:label];
    UITextField * textField3 = [[UITextField alloc]initWithFrame:CGRectMake(50, 195, 260, 30)];
    textField3.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    textField3.placeholder = @"姓名/卡号/手机号";
    textField3.tag = 1000;
    // 将控件添加到当前视图上
    [self.view addSubview:textField3];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,29, 259, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [textField3 addSubview:lineView];
    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(302, 200, 50, 30);
    imageView2.layer.cornerRadius = 8;
    imageView2.layer.masksToBounds = YES;
    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];
    //添加搜索事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchCar:)];
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:tap];
    
    
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"基本信息",@"更多信息", nil];
    //初始化UISegmentedControl
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    segment.frame = CGRectMake(0, 235, self.view.frame.size.width, 40);
    segment.backgroundColor = [UIColor grayColor];
    segment.layer.masksToBounds = YES;               //    默认为no，不设置则下面一句无效
    segment.layer.cornerRadius = 0;               //    设置圆角大小，同UIView
    segment.layer.borderWidth = 2;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
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
  
    //当选中不同的segment时,会触发不同的点击事件
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    
    UIView* jbView = [[UIView alloc] init];
    
    self.baseView = jbView;
    self.baseView.frame = CGRectMake(0, 275, GZDeviceWidth, 200);
    UILabel* labelCp = [[UILabel alloc] init];
    labelCp.frame = CGRectMake(100, 0, 50, 30);
    labelCp.text = @"车牌";
    [self.baseView addSubview:labelCp];
    
    
    _textFieldCp = [[UITextField alloc]initWithFrame:CGRectMake(160, 0, 200, 30)];
    _textFieldCp.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldCp.placeholder = @"必填";
    // 将控件添加到当前视图上
    [self.baseView addSubview:_textFieldCp];
    
    
    UILabel* labelCjh = [[UILabel alloc] init];
    labelCjh.frame = CGRectMake(90, 30, 60, 30);
    labelCjh.text = @"车架号";
    [self.baseView addSubview:labelCjh];
    
    _textFieldCjh = [[UITextField alloc]initWithFrame:CGRectMake(160, 30, 200, 30)];
    _textFieldCjh.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldCjh.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.baseView addSubview:_textFieldCjh];
    
    
    
    UILabel* labelCx = [[UILabel alloc] init];
    labelCx.frame = CGRectMake(100, 60, 50, 30);
    labelCx.text = @"车型";
    [self.baseView addSubview:labelCx];
    
    _textFieldCx = [[UITextField alloc]initWithFrame:CGRectMake(160, 60, 200, 30)];
    _textFieldCx.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldCx.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.baseView addSubview:_textFieldCx];
    
    
    UILabel* labelGls = [[UILabel alloc] init];
    labelGls.frame = CGRectMake(90, 90, 60, 30);
    labelGls.text = @"公里数";
    [self.baseView addSubview:labelGls];
    
    _textFieldGls= [[UITextField alloc]initWithFrame:CGRectMake(160, 90, 200, 30)];
    _textFieldGls.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldGls.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.baseView addSubview:_textFieldGls];
    
    UILabel* labelSxr = [[UILabel alloc] init];
    labelSxr.frame = CGRectMake(90, 120, 60, 30);
    labelSxr.text = @"送修人";
    [self.baseView addSubview:labelSxr];
    
    _textFieldSxr= [[UITextField alloc]initWithFrame:CGRectMake(160, 120, 200, 30)];
    _textFieldSxr.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldSxr.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.baseView addSubview:_textFieldSxr];
    
    
    
    UILabel* labelSjh = [[UILabel alloc] init];
    labelSjh.frame = CGRectMake(90, 150, 60, 30);
    labelSjh.text = @"手机号";
    [self.baseView addSubview:labelSjh];
    
    _textFieldSjh= [[UITextField alloc]initWithFrame:CGRectMake(160, 150, 200, 30)];
    _textFieldSjh.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldSjh.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.baseView addSubview:_textFieldSjh];
    
    [self.view  addSubview:self.baseView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0,460, GZDeviceWidth, 2)];
    lineView2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:lineView2];
    [self initMoreView];
    
    UIButton *buttonGz=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    buttonGz.backgroundColor = [UIColor greenColor];
    buttonGz.frame = CGRectMake(80, 470, 100, 40);
    [buttonGz setTitle:@"关注" forState:UIControlStateNormal];
    [buttonGz addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *buttonJc=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    buttonJc.backgroundColor = [UIColor greenColor];
    buttonJc.frame = CGRectMake(240, 470, 100, 40);
    [buttonJc setTitle:@"接车" forState:UIControlStateNormal];
    [buttonJc addTarget:self action:@selector(pickUpCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonGz];
    [self.view addSubview:buttonJc];

}

-(void) initMoreView
{
   UIView* gdView = [[UIView alloc] init];
    self.moreView = gdView;
    self.moreView.frame = CGRectMake(0, 275, GZDeviceWidth, 200);
    UILabel* labelCp = [[UILabel alloc] init];
    labelCp.frame = CGRectMake(100, 0, 50, 30);
    labelCp.text = @"车主";
    [self.moreView addSubview:labelCp];
    
    
    _textFieldChezhu = [[UITextField alloc]initWithFrame:CGRectMake(160, 0, 200, 30)];
    _textFieldChezhu.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldChezhu.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.moreView addSubview:_textFieldChezhu];
    
    
    UILabel* labelCjh = [[UILabel alloc] init];
    labelCjh.frame = CGRectMake(90, 30, 60, 30);
    labelCjh.text = @"推荐人";
    [self.moreView addSubview:labelCjh];
    
    _textFieldTjr = [[UITextField alloc]initWithFrame:CGRectMake(160, 30, 200, 30)];
    _textFieldTjr.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldTjr.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.moreView addSubview:_textFieldTjr];
    
    
    
    UILabel* labelCx = [[UILabel alloc] init];
    labelCx.frame = CGRectMake(70, 60, 80, 30);
    labelCx.text = @"故障描述";
    [self.moreView addSubview:labelCx];
    
    _textFieldGzms = [[UITextField alloc]initWithFrame:CGRectMake(160, 60, 200, 30)];
    _textFieldGzms.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldGzms.placeholder = @"输入";
    
    // 将控件添加到当前视图上
    [self.moreView addSubview:_textFieldGzms];
    
    
    UILabel* labelGls = [[UILabel alloc] init];
    labelGls.frame = CGRectMake(70, 90, 80, 30);
    labelGls.text = @"钥匙牌号";
    [self.moreView addSubview:labelGls];
    
    _textFieldKeysNo= [[UITextField alloc]initWithFrame:CGRectMake(160, 90, 200, 30)];
    _textFieldKeysNo.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldKeysNo.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.moreView addSubview:_textFieldKeysNo];
    
    UILabel* labelSxr = [[UILabel alloc] init];
    labelSxr.frame = CGRectMake(50, 120, 110, 30);
    labelSxr.text = @"预交车时间";
    [self.moreView addSubview:labelSxr];
    
    _textFieldNSDate= [[UITextField alloc]initWithFrame:CGRectMake(160, 120, 200, 30)];
    _textFieldNSDate.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldNSDate.placeholder = @"选择日期";
    // 将控件添加到当前视图上
    [self.moreView addSubview:_textFieldNSDate];
    
    
    
    UILabel* labelSjh = [[UILabel alloc] init];
    labelSjh.frame = CGRectMake(100, 150, 50, 30);
    labelSjh.text = @"备注";
    [self.moreView addSubview:labelSjh];
    
    _textFieldMemo= [[UITextField alloc]initWithFrame:CGRectMake(160, 150, 200, 30)];
    _textFieldMemo.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    _textFieldMemo.placeholder = @"输入";
    // 将控件添加到当前视图上
    [self.moreView addSubview:_textFieldMemo];
    
    [self.view  addSubview:self.moreView];
    self.moreView.hidden = YES;
}




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


#pragma mark - 搜索车辆
-(void)searchCar:(UITapGestureRecognizer *)tap{
    UITextField* textField = [self.view viewWithTag:1000];
    __weak HomeViewController *safeSelf = self;

    SearchCarViewController *vc  =[[SearchCarViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.block = ^(CarInfoModel* model){
//        NSLog(@"%@",model.mobile);
        safeSelf.textFieldCp.text = model.mc;
        safeSelf.textFieldCjh.text = model.cjhm;
        safeSelf.textFieldCx.text = model.cx;
        safeSelf.textFieldGls.text = model.gls;
        safeSelf.textFieldSxr.text = model.linkman;
        safeSelf.textFieldSjh.text = model.mobile;
        safeSelf.textFieldChezhu.text = model.cz;
        safeSelf.textFieldTjr.text = model.custom5;
        safeSelf.textFieldGzms.text = model.gzms;
        safeSelf.textFieldKeysNo.text = model.keys_no;
        safeSelf.textFieldNSDate.text = model.ns_date;
        safeSelf.textFieldMemo.text = model.memo;

    };
    vc.searchName = textField.text;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void) viewDidLoad
{
    [self initView];
    int count = [[DataBaseTool shareInstance] querySearchListNum];
    if(count==0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadCarList:@"0"];
        });
    }
}

//加载数据
-(void)loadCarList:(NSString*)previous_xh{
    __weak HomeViewController *safeSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_plate_number";
    dict[@"company_code"] = @"A";
    dict[@"previous_xh"] = previous_xh;
   
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            //请求成功
            //插入数据库
            NSArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dic in items) {
                CarInfoModel *model = [CarInfoModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }
            [[DataBaseTool shareInstance] insertCarListData:dataArr];
            //继续调用
            NSString* tmpPrevious_xh = [responseObject objectForKey:@"Previous_xh"];
            [safeSelf loadCarList:tmpPrevious_xh];
        }else{
            
            
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 接车
-(void)pickUpCar:(UIButton *)sender{
    NSString* linkman = _textFieldSxr.text;
    NSString* mobile = _textFieldSjh.text;
    NSString* mc = _textFieldCp.text;
    NSString* cjh = _textFieldCjh.text;
    NSString* cx = _textFieldCx.text;
    NSString* cz = _textFieldChezhu.text;
    NSString* tjr = _textFieldTjr.text;
    NSString* gzms = _textFieldGzms.text;
    NSString* keys_no = _textFieldKeysNo.text;
    NSString* nsDate = _textFieldNSDate.text;
    NSString* memo = _textFieldMemo.text;
    NSString* gls = _textFieldGls.text;

    if([mc isEqualToString:@""]){
        [ToolsObject show:@"车牌不能为空" With:self];
        return;
    }
    if(mc.length < 5){
        [ToolsObject show:@"车牌号输入有误" With:self];
        return;
    }
    if([linkman isEqualToString:@""]){
        [ToolsObject show:@"报修人不能为空" With:self];
        return;
    }
    if([mobile isEqualToString:@""]){
        [ToolsObject show:@"手机号不能为空" With:self];
        return;
    }
    if(![ToolsObject isMobileNumber:mobile]){
        [ToolsObject show:@"手机号输入有误" With:self];
        return;
    }
    CarInfoModel* model = [[CarInfoModel alloc] init];
    model.mc = mc;
    model.mobile = mobile;
    model.cjhm = cjh;
    model.cx = cx;
    model.cz = cz;
    model.gzms = gzms;
    model.keys_no = keys_no;
    model.ns_date = nsDate;
    model.memo = memo;
    model.linkman = linkman;
    model.gls = gls;
    model.custom5 = tjr;
    model.fdjhm = @"";
    model.jsd_id = @"";
    model.openid = @"";
    NSMutableArray* array = [[DataBaseTool shareInstance] queryCarListData:mc isLike:false];
    if(array.count==0){
        //新增新的car
        [self uploadNewCar:model];
    }else{
        //更新
        CarInfoModel* tmpModel = [array objectAtIndex:0];
        model.customer_id = tmpModel.customer_id;
        model.phone = tmpModel.phone;
        model.ID = tmpModel.ID;
        model.vipnumber = tmpModel.vipnumber;
        [self uploadOldCar:model];
    }
}


#pragma mark - 关注
-(void)attention:(UIButton *)sender{
    __weak HomeViewController *safeSelf = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_get_wxgzh_account";//上传
    dict[@"company_code"] = @"A";
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            
        }
    } failure:^(NSError * _Nonnull error) {
        [ToolsObject show:@"网络错误" With:safeSelf];
        [safeSelf.progress hideAnimated:YES];
    }];

}


#pragma mark - 上传新车信息
-(void)uploadNewCar:(CarInfoModel *)model{
    _progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak HomeViewController *safeSelf = self;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_upload_customer_info";//上传
    dict[@"plate_number"] = model.mc;
    dict[@"cz"]=model.cz;
    dict[@"phone"]=model.phone;
    dict[@"mobile"]=model.mobile;
    dict[@"linkman"]=model.linkman;
    dict[@"custom5"]=model.custom5;
    dict[@"cx"]=model.cx;
    dict[@"cjhm"]=model.cjhm;
    dict[@"fdjhm"]=model.fdjhm;
    dict[@"oprater_code"] = @"superuser";
    dict[@"company_code"] = @"A";
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSString* customer_id = [responseObject objectForKey:@"customer_id"];
            model.customer_id = customer_id;
            //新增本地数据库
            [[DataBaseTool shareInstance] insertCarInfo:model];
            //检查当前是否已进厂
            [safeSelf checkHasNotComplete:model];
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            [ToolsObject show:msg With:safeSelf];
            [safeSelf.progress hideAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [ToolsObject show:@"网络错误" With:safeSelf];
        [safeSelf.progress hideAnimated:YES];
    }];
}

#pragma mark - 检查当前车辆是否已进进厂
-(void)checkHasNotComplete:(CarInfoModel*)model{
    __weak HomeViewController *safeSelf = self;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_check_repair_list_cp";//检测
    dict[@"customer_id"] = model.customer_id;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSString* jsd_id = [responseObject objectForKey:@"jsd_id"];
            NSString* jcr =  [responseObject objectForKey:@"jcr"];
            NSString* jc_date =  [responseObject objectForKey:@"jc_date"];
            model.jsd_id = jsd_id;
            //车辆已进厂未完工
            //更新本地数据库
            [[DataBaseTool shareInstance] updateCarInfo:model];
            //显示进场Dialog
            UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,270*PXSCALE,80*PXSCALEH)];
            UILabel *jdrLabel = [PublicFunction getlabel:CGRectMake(20, 10*PXSCALEH, contentView.bounds.size.width-40, 30) text:[NSString stringWithFormat:@"接待人员: %@",jcr] fontSize:14 color:SetColor(@"#111111", 1.0) align:@"left"];
            [contentView addSubview:jdrLabel];
            UILabel *jcDateLabel = [PublicFunction getlabel:CGRectMake(20, 10*PXSCALEH+jdrLabel.frame.origin.y+jdrLabel.bounds.size.height, contentView.bounds.size.width-40, 30) text:[NSString stringWithFormat:@"进厂时间: %@",jc_date] fontSize:14 color:SetColor(@"#111111", 1.0) align:@"left"];
            [contentView addSubview:jcDateLabel];
            HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"进入该车" withSurceBtnTitle:@"返回接车" WithMsg:@"" withTitle:@"该车辆已进场" contentView: contentView];
            alertView.contentView = [[UIView alloc] initWithFrame:CGRectMake(alertView.contentView.frame.origin.x, alertView.contentView.frame.origin.y,  alertView.contentView.bounds.size.width, 150)];
//            alertView.contentView.backgroundColor = [UIColor redColor];
            [alertView showHNAlertView:^(NSInteger index) {
                if(index == 0){
                    [safeSelf enterProject:jsd_id];
                }else{
                    
                }
            }];
            [safeSelf.progress hideAnimated:YES];
        }else{
            //车辆未进厂,生成接车单
            [self createPickUpOrder:model];
        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf.progress hideAnimated:YES];
        [ToolsObject show:@"网络错误" With:safeSelf];
    }];
}




#pragma mark - 上传更新旧车信息
-(void)uploadOldCar:(CarInfoModel *)model{
    __weak HomeViewController *safeSelf = self;
    _progress = [ToolsObject showLoading:@"加载中" with:self];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_update_customer_info";//更新
    dict[@"cz"]=model.cz;
    dict[@"phone"]=model.phone;
    dict[@"mobile"]=model.mobile;
    dict[@"linkman"]=model.linkman;
    dict[@"custom5"]=model.custom5;
    dict[@"cx"]=model.cx;
    dict[@"cjhm"]=model.cjhm;
    dict[@"fdjhm"]=model.fdjhm;
    dict[@"customer_id"] = model.customer_id;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            //更新本地数据库
            [[DataBaseTool shareInstance] updateCarInfo:model];
            [safeSelf checkHasNotComplete:model];

        }
    } failure:^(NSError * _Nonnull error) {
        [ToolsObject show:@"网络错误" With:safeSelf];

    }];
}

#pragma mark - 进入工单
-(void)enterProject:(NSString*)jsd_id{
    ProjectOrderViewController *vc  =[[ProjectOrderViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.jsd_id = jsd_id;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 生成接车单
-(void)createPickUpOrder:(CarInfoModel*) model {
    __weak HomeViewController *safeSelf = self;
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_upload_repair_list_main";//接车单
    dict[@"company_code"] = @"A";
    dict[@"cz"]=model.cz;
    dict[@"plate_number"] = model.mc;
    dict[@"ns_date"] = dateStr;
    dict[@"ywg_date"] = dateStr;
    dict[@"xllb"] = @"";
    dict[@"jclc"] = model.gls;
    dict[@"keys_no"] = model.keys_no;
    dict[@"memo"] = model.memo;
    dict[@"oprater_code"] = @"superuser";
    dict[@"phone"]=model.phone;
    dict[@"mobile"]=model.mobile;
    dict[@"linkman"]=model.linkman;
    dict[@"custom5"]=model.custom5;
    dict[@"cx"]=model.cx;
    dict[@"cjhm"]=model.cjhm;
    dict[@"fdjhm"]=model.fdjhm;
    dict[@"customer_id"] = model.customer_id;
    dict[@"jsd_id"] = @"";
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSString* jsd_id = [responseObject objectForKey:@"jsd_id"];
            if(![model.gzms isEqualToString:@""]&&model.gzms !=NULL){
                //上传故障描述
                [safeSelf uploadGuZhang:model];
            }else{
                //进入工单页面
                [safeSelf.progress hideAnimated:YES];
                [safeSelf enterProject:jsd_id];

            }
            //sp.putString(Constance.JSD_ID,jsd_id);
            //sp.putString(Constance.CUSTOMER_ID,carInfo.getCustomer_id());
        }else{
            [safeSelf.progress hideAnimated:YES];
            NSString* msg = [responseObject objectForKey:@"msg"];
            [ToolsObject show:msg With:safeSelf];
        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf.progress hideAnimated:YES];
        [ToolsObject show:@"网络错误" With:safeSelf];
    }];
}

#pragma mark - 上传故障
-(void)uploadGuZhang:(CarInfoModel*)model {
    __weak HomeViewController *safeSelf = self;
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_update_fault_info";//故障信息
    dict[@"customer_id"] = model.customer_id;
    dict[@"car_fault"] = model.gzms;
    dict[@"days"] = dateStr;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            //进入工单页面
            [safeSelf.progress hideAnimated:YES];

        }else{
            [safeSelf.progress hideAnimated:YES];
            NSString* msg = [responseObject objectForKey:@"msg"];
            [ToolsObject show:msg With:self];
        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf.progress hideAnimated:YES];
        [ToolsObject show:@"网络错误" With:safeSelf];
        
    }];
}

@end
