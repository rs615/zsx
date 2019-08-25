//
//  ProjectViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectViewController.h"
#import "OrderCarInfoModel.h"
#import "HnAlertView.h"
#import "ProjectSelectViewController.h"
#import "HistoryDataListController.h"
#import "ProjectOrderViewController.h"
#import "HomeViewController.h"
#import "BRPickerView.h"

typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface ProjectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,strong)OrderCarInfoModel *orderCarInfoModel;
@property (nonatomic,assign)BOOL isNeedRefresh;

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"项目首页" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma view start
-(void)initView{

    [self initContentView];
}



-(void)initContentView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,NavBarHeight , MainS_Width, MainS_Height-NavBarHeight)];
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

#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*PXSCALEH, MainS_Width, 280*PXSCALEH)];
        
        NSArray* titleArr = @[@"公里数",@"车架号",@"车型",@"预完工日期",@"故障描述",@"介绍人",@"备注"];
        NSString* gls = _orderCarInfoModel!=nil?_orderCarInfoModel.jclc:@"";
        NSString* cx = _orderCarInfoModel!=nil?_orderCarInfoModel.cx:@"";
        NSString* cjh = _orderCarInfoModel!=nil?_orderCarInfoModel.cjhm:@"";
        NSString* ywg_date = _orderCarInfoModel!=nil?_orderCarInfoModel.ywg_date:@"";
        if(ywg_date.length>10){
            ywg_date = [ywg_date substringToIndex:10];
        }
        NSString* gzms = _model.gzms;
        NSString* jsr = _orderCarInfoModel!=nil?_orderCarInfoModel.custom5:@"";
        NSString* memo = _orderCarInfoModel!=nil?_orderCarInfoModel.memo:@"";
        NSArray* valueArr = @[gls,cjh,cx,ywg_date,gzms,jsr,memo];
        for(int i=0;i<titleArr.count;i++){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20*PXSCALE, i*40*PXSCALEH, MainS_Width-40*PXSCALE, 40*PXSCALEH)];
            CGFloat viewWidth = view.bounds.size.width/3;
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0,0,viewWidth-10*PXSCALE, 40*PXSCALEH) text:[NSString stringWithFormat:@"%@",[titleArr objectAtIndex:i]] fontSize:14 color:[UIColor blackColor] align:@"right"];
            titleLabel.tag = 110+i;
            [view addSubview:titleLabel];

            if(i==titleArr.count-1){
                [ToolsObject setBorderWithView:view top:YES left:YES bottom:YES right:YES borderColor:lightGreenColor borderWidth:1];
            }else{
                [ToolsObject setBorderWithView:view top:YES left:YES bottom:NO right:YES borderColor:lightGreenColor borderWidth:1];
            }

            UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(viewWidth,0,viewWidth*2, 40*PXSCALEH) text:[valueArr objectAtIndex:i] fontSize:14 color:[UIColor blackColor] align:@"center"];
            [ToolsObject setBorderWithView:valueLabel top:NO left:YES bottom:NO right:NO borderColor:lightGreenColor borderWidth:1];
            valueLabel.tag = 120+i;
            [view addSubview:valueLabel];
            UIButton* editBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(viewWidth*3-30-10*PXSCALE,(40*PXSCALEH
                                                                                         -30)/2, 30, 30) imageName:@"edit" title:@"" clickAction:@selector(editBtnSelect:)];
            editBtn.tag = 100+i;
            [view addSubview:editBtn];

            [contentView addSubview:view];

        }
        [cell.contentView addSubview:contentView];
        
        return cell;

    }else if(indexPath.section==1){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 270*PXSCALEH)];
        
        NSArray* titleArr = @[@"项目选择",@"钣金喷漆",@"车辆检查",@"套餐业务",@"优惠券",@"历史记录",@"工单汇总",@"取消接车"];
        NSArray* imageArr = @[@"select_pro",@"car_door",@"check_plan",@"tc_work",@"you_ticket",@"history",@"work_order",@"cancle_reciver"];

        for(int i=0;i<titleArr.count;i++){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(i%3*MainS_Width/3, i/3*90*PXSCALEH, MainS_Width/3, 90*PXSCALEH)];
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, 90*PXSCALEH/2+30*PXSCALE/2, MainS_Width/3, 30*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:14 color:[UIColor blackColor] align:@"center"];
            UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake((MainS_Width/3-45*PXSCALE)/2, (90*PXSCALEH-45*PXSCALE-15*PXSCALE)/2, 45*PXSCALE,45*PXSCALE) imageName:[imageArr objectAtIndex:i] title:nil clickAction:@selector(btnSelect:)];
            btn.tag = 200+i;
            [view addSubview:btn];

            [view addSubview:titleLabel];
            [contentView addSubview:view];
        }
        [cell.contentView addSubview:contentView];
        
        return cell;
    }
    return nil;
   
}

#pragma 显示dialog
-(void)showDialog:(NSString*)title value:(NSString*)value data:(NSString*)data tag:(NSInteger)tag{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,60*PXSCALEH)];
    UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE,10*PXSCALEH, (contentView.bounds.size.width-20*PXSCALE)/4, 40*PXSCALEH) text:[NSString stringWithFormat:@"%@:",title] size:14 align:@"left"];
    [contentView addSubview:titleLabel];
    UITextField* valueTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, 10*PXSCALEH, (contentView.bounds.size.width-20*PXSCALE)/4*3, 40*PXSCALEH) tag:200 returnType:@""];
    valueTextField.text = value;
    valueTextField.placeholder = [NSString stringWithFormat:@"请输入"];
    [contentView addSubview:valueTextField];
    __weak ProjectViewController* safeSelf = self;
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"修改" contentView: contentView];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            [safeSelf updateData:data keyValue:valueTextField.text callback:^(NSString *errorMsg, id result) {
                if(![errorMsg isEqualToString:@""]){
                    [ToolsObject show:@"修改失败" With:safeSelf];
                }else{
                    //更新数据
                    safeSelf.isNeedRefresh = YES;
                    ((UILabel*)[safeSelf.view viewWithTag:tag+20]).text = valueTextField.text;
                    [ToolsObject show:@"修改成功" With:safeSelf];
                }
            }];
        }else{
            
        }
    }];
}

/*
 编辑
 */
-(void)editBtnSelect:(UIButton*)btn{
    UIView* parentView = [btn superview];
    UILabel* titleLabel = [parentView viewWithTag:btn.tag+10];
    UILabel* valueLabel = [parentView viewWithTag:btn.tag+20];
    NSArray* dataArr = @[@"jclc",@"cjhm",@"cx",@"ywg_date",@"gzms",@"custom5",@"memo"];
    if([titleLabel.text isEqualToString:@"预完工日期"]){
        //显示日期
        NSString* dateStr = ![valueLabel.text isEqualToString:@""]?valueLabel.text:nil;
        __weak ProjectViewController* safeSelf = self;
        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:BRDatePickerModeYMD defaultSelValue:dateStr minDate:nil maxDate:nil isAutoSelect:NO themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            [safeSelf updateData:@"ywg_date" keyValue:selectValue callback:^(NSString *errorMsg, id result) {
                if(![errorMsg isEqualToString:@""]){
                    [ToolsObject show:@"修改失败" With:safeSelf];
                }else{
                    //更新数据
                    valueLabel.text = selectValue;
                    [ToolsObject show:@"修改成功" With:safeSelf];
                }
            }];
        }];
    }else if([titleLabel.text isEqualToString:@"故障描述"]){
        //跳转
    }else{
        NSString* data = [dataArr objectAtIndex:btn.tag-100];
        [self showDialog:titleLabel.text value:valueLabel.text data:data tag:btn.tag];
    }
}

/*
 编辑
 */
-(void)btnSelect:(UIButton*)btn{
    switch (btn.tag) {
        case 200:
            [self enterProjectSelect];
            break;
        case 205:
            [self enterHistory];
            break;
        case 206:
            [self enterWorkOrder];
            break;
        case 207:
            [self cancleOrderCar];
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 290*PXSCALEH;

    }else{
        return 270*PXSCALEH;

    }
}


#pragma view end


#pragma data start
-(void)initData{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak ProjectViewController* safeSelf = self;
    [self getJsdInfo:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            safeSelf.orderCarInfoModel = [result objectAtIndex:0];
            [safeSelf.tableView reloadData];
        }
    }];
}

#pragma 结算单
-(void)getJsdInfo:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repair_list_main";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [OrderCarInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 取消接车
-(void)cancleReciver:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_delete_repair_list_main";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            callback(@"",nil);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 项目选择
-(void)enterProjectSelect{
    ProjectSelectViewController* vc = [[ProjectSelectViewController alloc] init];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterHistory{
    HistoryDataListController* vc = [[HistoryDataListController alloc] init];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)enterWorkOrder{

    BOOL isHave = NO;
    for(UIViewController*temp in self.navigationController.viewControllers) {
        if([temp isKindOfClass:[ProjectOrderViewController class]]){
            isHave = YES;
            ProjectOrderViewController* vc  = (ProjectOrderViewController*)temp;
            vc.isNeedRefresh = self.isNeedRefresh;
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    if(!isHave){
        ProjectOrderViewController* vc = [[ProjectOrderViewController alloc] init];
            vc.model = _model;
            [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma 取消接车
-(void)cancleOrderCar{
    __weak ProjectViewController* safeSelf = self;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,60*PXSCALEH)];
    UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE,10*PXSCALEH, (contentView.bounds.size.width-20*PXSCALE)/2, 40*PXSCALEH) text:[NSString stringWithFormat:@"%@",@"您确定要取消车牌号为:"] size:14 align:@"right"];
    [contentView addSubview:titleLabel];
    UILabel* valueLabel = [PublicFunction getlabel:CGRectMake((contentView.bounds.size.width-20*PXSCALE)/2+10*PXSCALE,10*PXSCALEH, (contentView.bounds.size.width-20*PXSCALE)/2, 40*PXSCALEH) text:[NSString stringWithFormat:@"%@:的接车吗？",_model.mc] size:14 align:@"left"];
    [valueLabel setTextColor:[UIColor blueColor]];
    [contentView addSubview:valueLabel];
   
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"提示" contentView: contentView];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            safeSelf.progress = [ToolsObject showLoading:@"加载中" with:safeSelf];
            [safeSelf cancleReciver:^(NSString *errorMsg, id result) {
                [safeSelf.progress hideAnimated:YES];
                if(![errorMsg isEqualToString:@""]){
                    [ToolsObject show:errorMsg With:safeSelf];
                }else{
                    for(UIViewController*temp in safeSelf.navigationController.viewControllers) {
                        if([temp isKindOfClass:[HomeViewController class]]){
                            [safeSelf.navigationController popToViewController:temp animated:YES];
                        }
                    }

                }
            }];
        }else{
            
        }
    }];
}

#pragma 更新car info
-(void)updateData:(NSString*)keyName keyValue:(NSString*)value callback:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_upload_repair_list_main_other";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;// 传过来
    dict[@"company_code"] = [ToolsObject getCompCode];
    dict[@"column_name"] = keyName;
    dict[@"data"] = value;
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak ProjectViewController* safeSelf = self;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        [safeSelf.progress hideAnimated:YES];
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            callback(@"",nil);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


#pragma data end

@end
