//
//  ProjectJiesuanViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectJiesuanViewController.h"
#import "ProjectShouYinViewController.h"
#import "JsBaseModel.h"
#import "JsPartModel.h"
#import "JsXmModel.h"
#import "JsCompModel.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface ProjectJiesuanViewController ()<UITableViewDelegate,UITableViewDataSource,UIPrintInteractionControllerDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,strong)JsBaseModel *jsBaseModel;
@property (nonatomic,strong)JsCompModel *jsCompModel;
@property (nonatomic, strong) NSMutableArray *partsData;
@property (nonatomic, strong) NSMutableArray *xmsData;
@property (nonatomic, assign) double totalXlf;
@property (nonatomic, assign) double totalZkMoney;
@property (nonatomic, assign) double totalPartSl;
@property (nonatomic, assign) double totalPartMoney;
@property (nonatomic, assign) double totalCb;

@end

@implementation ProjectJiesuanViewController{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"结算" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"home_icon" rightAction:@selector(backHome) withVC:self];
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
    UIImageView* headImgView = [PublicFunction getImageView:CGRectMake(MainS_Width/4-20*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_person"];
    UILabel* personLabel = [PublicFunction getlabel:CGRectMake(headImgView.frame.origin.x+headImgView.bounds.size.width+5*PXSCALE, 0, MainS_Width/4, 40*PXSCALE) text:_model.cz size:14 align:@"left"];
    [personLabel setTextColor:[UIColor whiteColor]];
    personLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:headImgView];
    [view addSubview:personLabel];
    UIImageView* carImgView = [PublicFunction getImageView:CGRectMake(MainS_Width/2+MainS_Width/4-30*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_yellow"];
    UILabel* carLabel = [PublicFunction getlabel:CGRectMake(carImgView.frame.origin.x+carImgView.bounds.size.width+5*PXSCALE, 0, MainS_Width/4, 40*PXSCALE) text:_model.mc size:14 align:@"left"];
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

-(void)selectItemBtnClick:(UIButton*)btn{
    
    switch (btn.tag) {
        case 120:
        case 121:
            //打印
            [self printData];
            break;
        case 122://取消
            [self backBtnClick];
            break;
        case 123:
            [self enterShouYin];
            break;
        default:
            break;
    }
}



#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1){
        return self.xmsData.count;
    }else if(section==2){
        return self.partsData.count;
    }else{
        return 1;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
    NSArray* valueArr;
    if(_jsBaseModel==nil){
        valueArr = @[@"",@"",@"",@"",@"",@"",@""];
    }else{
        valueArr = @[[ToolsObject getFactoryName],_jsBaseModel.cz,_jsBaseModel.cp,_jsBaseModel.cjhm,_jsBaseModel.cx,_jsBaseModel.jclc,_jsBaseModel.car_fault];
    }
    for (int i=0;i<titleArr.count; i++) {
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, i*30*PXSCALEH+40*PXSCALEH, MainS_Width/2-20*PXSCALE, 30*PXSCALEH) text:titleArr[i] fontSize:14 color:SetColor(@"#999999", 1) align:@"right"];
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width+10*PXSCALE, i*30*PXSCALEH+40*PXSCALEH, MainS_Width-(titleLabel.frame.origin.x+titleLabel.bounds.size.width+10*PXSCALE), 30*PXSCALEH) text:valueArr[i] fontSize:14 color:SetColor(@"#999999", 1) align:@"left"];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:valueLabel];
    }
    return cell;
}


#pragma 获取项目cell
-(UITableViewCell *)createProjectCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell1"];
    }
   
    if(indexPath.row==0){
        NSArray* titleArr = @[@"项目名称",@"修理费",@"优惠"];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*PXSCALE, 0, MainS_Width-20*PXSCALE, 1)];
        lineView.backgroundColor = SetColor(@"#999999", 1);
        [cell.contentView addSubview:lineView];
        for (int i=0; i<titleArr.count; i++) {
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE, 10*PXSCALEH, (MainS_Width-20*PXSCALE)/3, 30*PXSCALEH) text:titleArr[i] align:@"center"];
            [cell.contentView addSubview:titleLabel];
        }
    }
    JsXmModel* model = [self.xmsData objectAtIndex:indexPath.row];
    
    NSArray* valueArr = @[model.xlxm,model.xlf,model.zk];
    for (int i=0; i<valueArr.count; i++) {
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE, 0, (MainS_Width-20*PXSCALE)/3, 40*PXSCALEH) text:valueArr[i] align:@"center"];
        if(indexPath.row==0){
            valueLabel.frame = CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE, 40*PXSCALEH, (MainS_Width-20*PXSCALE)/3, 30*PXSCALEH);
        }
        [valueLabel setTextColor:SetColor(@"#999999", 1)];
        [cell.contentView addSubview:valueLabel];
    }
    
    if(indexPath.row==self.xmsData.count-1){
        NSArray* xjArr = @[@"小计",[NSString stringWithFormat:@"%.2f",_totalXlf],[NSString stringWithFormat:@"%.2f",_totalZkMoney]];
        for (int i=0; i<xjArr.count; i++) {
            UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE,40*PXSCALEH , (MainS_Width-20*PXSCALE)/3, 40*PXSCALEH) text:xjArr[i] align:@"center"];
            if(indexPath.row==0){
                valueLabel.frame = CGRectMake(i*(MainS_Width-20*PXSCALE)/3+20*PXSCALE,40*PXSCALEH , (MainS_Width-20*PXSCALE)/3, 80*PXSCALEH);
            }
            [valueLabel setTextColor:SetColor(@"#999999", 1)];
            [cell.contentView addSubview:valueLabel];
        }
    }
    
    return cell;
}


#pragma 获取配件cell
-(UITableViewCell *)createPeijianCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell2"];
    }
    
    JsPartModel* model = [self.partsData objectAtIndex:indexPath.row];
    if(indexPath.row==0){
        NSArray* titleArr = @[@"配件名称",@"数量",@"单价",@"金额"];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*PXSCALE, 0, MainS_Width-20*PXSCALE, 1)];
        lineView.backgroundColor = SetColor(@"#999999", 1);
        [cell.contentView addSubview:lineView];
        for (int i=0; i<titleArr.count; i++) {
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/4+20*PXSCALE, 10*PXSCALEH, (MainS_Width-20*PXSCALE)/4, 30*PXSCALEH) text:titleArr[i] align:@"center"];
            [cell.contentView addSubview:titleLabel];
        }
    }
    NSArray* valueArr = @[model.pjmc,[NSString stringWithFormat:@"%.2f",[model.sl floatValue]],@"0.00",[NSString stringWithFormat:@"%.2f",[model.ssj floatValue]]];
    for (int i=0; i<valueArr.count; i++) {
        UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/4+20*PXSCALE, 0, (MainS_Width-20*PXSCALE)/4, 30*PXSCALEH) text:valueArr[i] align:@"center"];
        if(indexPath.row==0){
            valueLabel.frame = CGRectMake(i*(MainS_Width-20*PXSCALE)/4+20*PXSCALE, 40*PXSCALEH, (MainS_Width-20*PXSCALE)/4, 30*PXSCALEH);
        }
        [valueLabel setTextColor:SetColor(@"#999999", 1)];
        [cell.contentView addSubview:valueLabel];
        
    }
 
    if(indexPath.row==self.partsData.count-1){
        NSArray* xjArr = @[@"小计",[NSString stringWithFormat:@"%.2f",_totalPartSl],@"0.00",[NSString stringWithFormat:@"%.2f",_totalPartMoney]];
        for (int i=0; i<xjArr.count; i++) {
            UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(i*(MainS_Width-20*PXSCALE)/4+20*PXSCALE,40*PXSCALEH , (MainS_Width-20*PXSCALE)/4, 30*PXSCALEH) text:xjArr[i] align:@"center"];
            [valueLabel setTextColor:SetColor(@"#999999", 1)];
            if(indexPath.row==0){
                valueLabel.frame = CGRectMake(i*(MainS_Width-20*PXSCALE)/4+20*PXSCALE,40*PXSCALEH , (MainS_Width-20*PXSCALE)/4, 70*PXSCALEH);
            }
            [cell.contentView addSubview:valueLabel];
        }
    }
    
    return cell;
}

#pragma 其他信息
-(UITableViewCell *)createOtherCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell3"];
    }
    UIView* lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10*PXSCALE, 1, MainS_Width-20*PXSCALE, 1)];
    lineView1.backgroundColor = SetColor(@"#999999", 1);
    [cell.contentView addSubview:lineView1];

    UILabel* yszjLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, 0, MainS_Width-40*PXSCALE, 40*PXSCALEH) text:[NSString stringWithFormat:@"应收总计:"] align:@"left"];
    [ToolsObject setBorderWithView:yszjLabel top:YES left:NO bottom:YES right:NO borderColor:SetColor(@"#99999", 1) borderWidth:1];
    [cell.contentView addSubview:yszjLabel];
    UILabel* addressLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, 40*PXSCALEH, MainS_Width-40*PXSCALE, 40*PXSCALEH) text:[NSString stringWithFormat:@"地址:%@",self.jsCompModel.address] align:@"left"];
    UILabel* phoneLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, 40*PXSCALEH*2, (MainS_Width-40*PXSCALE)/2, 40*PXSCALEH) text:[NSString stringWithFormat:@"电话:%@",self.jsCompModel.telphone] align:@"left"];

//    UILabel* czLabel = [PublicFunction getlabel:CGRectMake(phoneLabel.frame.origin.x+phoneLabel.bounds.size.width, 40*PXSCALEH*2, (MainS_Width-40*PXSCALE)/2, 40*PXSCALEH) text:[NSString stringWithFormat:@"传真:"] align:@"left"];
    [cell.contentView addSubview:addressLabel];
    [cell.contentView addSubview:phoneLabel];
//    [cell.contentView addSubview:czLabel];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*PXSCALE, phoneLabel.frame.origin.y+phoneLabel.bounds.size.height, MainS_Width-20*PXSCALE, 1)];
    lineView.backgroundColor = SetColor(@"#999999", 1);
    [cell.contentView addSubview:lineView];

    NSArray* titleArr = @[@"客户签字:",@"接待签字:",@"日期:",@"备注:",@"打印时间"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, i*40*PXSCALEH+phoneLabel.frame.origin.y+phoneLabel.bounds.size.height, (MainS_Width-40*PXSCALEH)/4, 40*PXSCALEH) text:titleArr[i] align:@"left"];
        if(i==titleArr.count-1){
            titleLabel.frame =CGRectMake(20*PXSCALE, i*40*PXSCALEH+phoneLabel.frame.origin.y+phoneLabel.bounds.size.height, MainS_Width-40*PXSCALEH, 40*PXSCALEH);
//            titleLabel.textAlignment=NSTextAlignmentLeft;
            NSDate* curDate = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [formatter stringFromDate:curDate];
            titleLabel.text = [NSString stringWithFormat:@"打印时间: %@",dateStr];
        }
        [cell.contentView addSubview:titleLabel];
    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.section);
    if(indexPath.section==0){
        return [self createJsdCell:tableView withIndexPath:indexPath];
    }else if(indexPath.section==1){
        return [self createProjectCell:tableView withIndexPath:indexPath];
    }else if(indexPath.section==2){
        return [self createPeijianCell:tableView withIndexPath:indexPath];
    }else if(indexPath.section==3){
        return [self createOtherCell:tableView withIndexPath:indexPath];

    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 260*PXSCALEH;
    }else if(indexPath.section==1){
        if(indexPath.row==0||indexPath.row==self.xmsData.count-1){
            if(self.xmsData.count==1){
                return 100*PXSCALEH;

            }
            
            return 80*PXSCALEH;
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0||indexPath.row==self.partsData.count-1){
            if(self.partsData.count==1){
                return 100*PXSCALEH;
                
            }
            return 80*PXSCALEH;
        }
    }else if(indexPath.section==3){
        return 320*PXSCALEH;
    }
    return 40*PXSCALEH;
}

-(void)textFieldValueChanged:(UITextField *)textField{
    
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
        for(JsPartModel* model in safeSelf.partsData){
            double tmpDob = [model.ssj doubleValue];
            double tmpSl = [model.sl doubleValue];
            safeSelf.totalPartSl+=tmpSl;
            safeSelf.totalPartMoney+=tmpDob;
            safeSelf.totalCb += model.cb==nil?0:[model.cb doubleValue];
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
            double tmpSl = [model.xlf doubleValue];
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

#pragma 获取基本数据
-(void)uploadMoney:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_repair_main_money";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"zje"] = [NSString stringWithFormat:@"%.2f",_totalXlf+_totalPartMoney];
    dict[@"wxfzj"] = [NSString stringWithFormat:@"%.2f",_totalXlf];
    dict[@"clfzj"] = [NSString stringWithFormat:@"%.2f",_totalPartMoney];
    dict[@"totalCb"] = [NSString stringWithFormat:@"%.2f",_totalCb];
//    dataMap.put("zje", Float.parseFloat(totalPartMoney+totalXlf+"")+"");
//    dataMap.put("wxfzj", Float.parseFloat(totalXlf+"")+"");
//    dataMap.put("clfzj", Float.parseFloat(totalPartMoney+"")+"");
//    dataMap.put("totalCb", Float.parseFloat(totalCb+"")+"");
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

-(void)enterShouYin{
    //同步数据
    __weak ProjectJiesuanViewController* safeSelf = self;
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    [self uploadMoney:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            ProjectShouYinViewController* vc = [[ProjectShouYinViewController alloc] init];
            vc.model = safeSelf.model;
            vc.totalZkMoney = [NSString stringWithFormat:@"%.2f",safeSelf.totalZkMoney];
            [safeSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (UIImage *)getImage:(UITableView *)cell

{
    UIImage* viewImage = nil;
    UITableView *scrollView = self.tableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
         CGPoint savedContentOffset = scrollView.contentOffset;
         CGRect savedFrame = scrollView.frame;
         scrollView.contentOffset = CGPointZero;
         scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
         [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
         viewImage = UIGraphicsGetImageFromCurrentImageContext();
         scrollView.contentOffset = savedContentOffset;
        
         scrollView.frame = savedFrame;
    }
    
    UIGraphicsEndImageContext();
    return viewImage;
    
}

-(void)printData{
    UIPrintInteractionController* printer = [UIPrintInteractionController sharedPrintController];
    printer.delegate = self;
    
    //配置打印信息
    UIPrintInfo *prinfo = [UIPrintInfo printInfo];
    prinfo.outputType = UIPrintInfoOutputGeneral;//可打印文本、图形、图像
    //    Pinfo.jobName = @"Print for xiaodui";//可选属性，用于在打印中心中标识打印作业
    prinfo.duplex = UIPrintInfoDuplexNone;//双面打印绕长边翻页，NONE为禁止双面
    prinfo.orientation = UIPrintInfoOrientationPortrait;//打印纵向还是横向
    
    //    Pinfo.printerID = @"";//指定默认打印机，也可以使用UIPrintInteractionControllerDelegate来知悉
    printer.printInfo = prinfo;
    
    //内容
//    _jsBaseModel.jsd_id = _model.jsd_id;
//    _jsBaseModel.totalXlf = _totalXlf;
//    _jsBaseModel.totalPartMoney = _totalPartMoney;
//    _jsBaseModel.totalZkMoney = _totalZkMoney;
//    _jsBaseModel.totalPartSl = _totalPartSl;
//    if(_jsCompModel!=nil){
//        _jsBaseModel.compName = _jsCompModel.company_name;
//        _jsCompModel.address = _jsCompModel.address;
//        _jsBaseModel.telphone = _jsCompModel.telphone;
//
//    }
    self.tableView.tableHeaderView.hidden = YES;
    UIImage* image = [self getImage:self.tableView];
    self.tableView.tableHeaderView.hidden = NO;
    printer.printingItem = image;
//    NSMutableString* content = [[NSMutableString alloc] initWithCapacity:10];
//    [content appendString:@"<FH><FB><center>首佳软件</center></FB></FH>"];
//    [content appendString:@" <FH2>"];
//    [content appendString:[NSString stringWithFormat:@"<center> 结算单号： %@  预完工时间：%@",_jsBaseModel.jsd_id,_jsBaseModel.jc_date]];
//    UIViewPrintFormatter* viewFormatter = [self.tableView viewPrintFormatter];
//    printer.printFormatter = viewFormatter;
    
//    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 300)];
//    [textView addSubview:self.tableView];
//    printer.printFormatter = [textView viewPrintFormatter];
//    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:content];
//    printer.printFormatter = textFormatter;
    //    printer.showsPageRange = NO;
    [printer presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
        if (!completed && error) {
            NSLog(@"Error");
        }
    }];
    
    
}
@end
