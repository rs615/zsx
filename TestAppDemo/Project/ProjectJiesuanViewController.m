//
//  ProjectJiesuanViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectJiesuanViewController.h"
#import "JsBaseModel.h"
#import "JsPartModel.h"
#import "JsXmModel.h"
#import "JsCompModel.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface ProjectJiesuanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,strong)JsBaseModel *jsBaseModel;
@property (nonatomic,strong)JsCompModel *jsCompModel;
@property (nonatomic, strong) NSMutableArray *partsData;
@property (nonatomic, strong) NSMutableArray *xmsData;
@property (nonatomic, assign) double totalXlf;
@property (nonatomic, assign) double totalZkMoney;

@end

@implementation ProjectJiesuanViewController{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"结算" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)initView{
    [self initContentView];
    [self initBottomView];
}


-(void)initContentView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,NavBarHeight , MainS_Width, MainS_Height-NavBarHeight-100*PXSCALEH)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self createTopView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(UIView*)createTopView{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, MainS_Width, 40*PXSCALEH)];
    view.backgroundColor = SetColor(@"#A58BBA", 1);
    UIImageView* headImgView = [PublicFunction getImageView:CGRectMake(10*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_person"];
    UILabel* personLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/4, 0, MainS_Width/4, 40*PXSCALE) text:_model.cz size:14 align:@"left"];
    [personLabel setTextColor:[UIColor whiteColor]];
    personLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:headImgView];
    [view addSubview:personLabel];
    UIImageView* carImgView = [PublicFunction getImageView:CGRectMake(MainS_Width/2-10*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_yellow"];
    UILabel* carLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/4*3, 0, MainS_Width/4, 40*PXSCALE) text:_model.mc size:14 align:@"left"];
    [carLabel setTextColor:[UIColor whiteColor]];
    carLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:carLabel];
    [view addSubview:carImgView];
    return view;
}

#pragma 底部bottom
-(void)initBottomView{
    UIView* baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(20*PXSCALE, MainS_Height-100*PXSCALEH, MainS_Width-20*PXSCALE, 100*PXSCALEH)];
    CGFloat btnWidth = (baseBottomView.bounds.size.width-40*PXSCALE)/3;
    CGFloat btnHeight = 40*PXSCALEH;
    NSArray* projectMenuArr = @[@"单联打印",@"双联打印",@"取消结算",@"收银"];
    for(int i=0;i<projectMenuArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE), i/3*(btnHeight+10*PXSCALEH), btnWidth, btnHeight) imageName:@"" title:[projectMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
      
        btn.backgroundColor = lightGreenColor;
        btn.tag = 120+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if(i==projectMenuArr.count-1){
            btn.frame = CGRectMake(0, i/3*(btnHeight+10*PXSCALEH), MainS_Width-40*PXSCALE, btnHeight);
        }
        [baseBottomView addSubview:btn];
        
    }
    [self.view addSubview:baseBottomView];
    
}


#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        if(_jsBaseModel!=nil){
            return 1;
        }
    }else if(section==1){
        return 1;
    }else if(section==2){
        return self.xmsData.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma 获取结算单cell
-(UITableViewCell *)createJsdCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    UILabel* jsdLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, 10*PXSCALEH, (MainS_Width-20*PXSCALE)/2, 30*PXSCALEH) text:[NSString stringWithFormat:@"结算单号: %@",_model.jsd_id] align:@"left"];
    NSString* ywg_date = _jsBaseModel.ywg_date;
    if(ywg_date.length>10){
        ywg_date = [ywg_date substringToIndex:10];
    }
    UILabel* yu_dateLabel = [PublicFunction getlabel:CGRectMake(jsdLabel.frame.origin.x+jsdLabel.bounds.size.width, 10*PXSCALEH, (MainS_Width-2*10*PXSCALE)/2, 30*PXSCALEH) text:[NSString stringWithFormat:@"预完工日期: %@",ywg_date] align:@"left"];
    [cell.contentView addSubview:jsdLabel];
    [cell.contentView addSubview:yu_dateLabel];
    
    NSArray* titleArr = @[@"修理厂名称:",@"客户名称:",@"车牌:",@"车架号:",@"车型:",@"进厂历程:",@"故障描述:"];
    NSArray* valueArr = @[[ToolsObject getFactoryName],_jsBaseModel.cz,_jsBaseModel.cp,_jsBaseModel.cjhm,_jsBaseModel.cx,_jsBaseModel.jclc,_jsBaseModel.car_fault];
    for (int i=0;i<titleArr.count; i++) {
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, i*30*PXSCALEH+40*PXSCALEH, MainS_Width/2-20*PXSCALE, 30*PXSCALEH) text:titleArr[i] fontSize:14 color:SetColor(@"#999999", 1) align:@"right"];
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width+10*PXSCALE, i*30*PXSCALEH+40*PXSCALEH, MainS_Width-(titleLabel.frame.origin.x+titleLabel.bounds.size.width+10*PXSCALE), 30*PXSCALEH) text:valueArr[i] fontSize:14 color:SetColor(@"#999999", 1) align:@"left"];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:valueLabel];
    }
    return cell;
}

#pragma 获取项目title cell
-(UITableViewCell *)createProjectTitleCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell1"];
    }
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*PXSCALE, 0, MainS_Width-20*PXSCALE, 1)];
    lineView.backgroundColor = SetColor(@"#999999", 1);
    [cell.contentView addSubview:lineView];
    NSArray* titleArr = @[@"项目名称",@"修理费",@"优惠"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE, 0, (MainS_Width-20*PXSCALE)/3, 40*PXSCALEH) text:titleArr[i] align:@"center"];
        [cell.contentView addSubview:titleLabel];
    }
    return cell;
}

#pragma 获取项目cell
-(UITableViewCell *)createProjectCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell2"];
    }
    
    JsXmModel* model = [self.xmsData objectAtIndex:indexPath.row];
    NSArray* titleArr = @[@"项目名称",@"修理费",@"优惠"];
    NSArray* valueArr = @[model.xlxm,model.xlf,model.zk];
    for (int i=0; i<titleArr.count; i++) {
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE, 0, (MainS_Width-20*PXSCALE)/3, 30*PXSCALEH) text:valueArr[i] align:@"center"];
        [valueLabel setTextColor:SetColor(@"#999999", 1)];
        [cell.contentView addSubview:valueLabel];
    
    }
    if(indexPath.row==self.xmsData.count-1){
        NSArray* xjArr = @[@"小计",[NSString stringWithFormat:@"%.2f",_totalXlf],[NSString stringWithFormat:@"%.2f",_totalZkMoney]];
        for (int i=0; i<xjArr.count; i++) {
            UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE,30*PXSCALEH , (MainS_Width-20*PXSCALE)/3, 30*PXSCALEH) text:xjArr[i] align:@"center"];
            [valueLabel setTextColor:SetColor(@"#999999", 1)];
            [cell.contentView addSubview:valueLabel];
        }
    }
    
    return cell;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return [self createJsdCell:tableView withIndexPath:indexPath];
    }else if(indexPath.section==1){
       
        return [self createProjectTitleCell:tableView withIndexPath:indexPath];
    }else if(indexPath.section==2){
        return [self createProjectCell:tableView withIndexPath:indexPath];

    }
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 260*PXSCALEH;
        
    }else if(indexPath.section==1){
        return 40*PXSCALEH;
    }else if(indexPath.section==2){
        return 40*PXSCALEH;
    }
    return 40*PXSCALEH;
}


#pragma 初始化数据
-(void)initData{
    self.errorMsg = @"";
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak ProjectJiesuanViewController* safeSelf = self;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getBaseData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.jsBaseModel = result;
        }
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getPjDataList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.partsData = result;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getXmDataList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.xmsData = result;
        }
        for (JsXmModel* model in safeSelf.xmsData) {
            float tmpSl = [model.xlf floatValue];
            safeSelf.totalXlf += tmpSl;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getCompanyData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.jsCompModel = result;
        }
        dispatch_group_leave(group);
    }];
    
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [safeSelf.progress hideAnimated:YES];
        [safeSelf.tableView reloadData];
    });

}

#pragma 获取基本数据
-(void)getBaseData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repair_list_main";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [JsBaseModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            callback(@"",[array objectAtIndex:0]);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取配件数据
-(void)getPjDataList:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_jsdmx_pjclmx";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [JsPartModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            callback(@"",array);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取项目数据
-(void)getXmDataList:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_jsdmx_xlxm";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [JsXmModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",array);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


#pragma 获取公司信息
-(void)getCompanyData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_get_company_info";//车间管理
    dict[@"company_code"] = [ToolsObject getCompCode];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [JsCompModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",[array objectAtIndex:0]);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


#pragma mark - Getters
- (NSMutableArray *)partsData
{
    if (!_partsData) {
        _partsData = [NSMutableArray array];
    }
    return _partsData;
}

#pragma mark - Getters
- (NSMutableArray *)xmsData
{
    if (!_xmsData) {
        _xmsData = [NSMutableArray array];
    }
    return _xmsData;
}
@end
