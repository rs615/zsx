//
//  MangerLinggongViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/26.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "MangerLinggongViewController.h"
#import "ProjectOrderViewController.h"
#import "ProjectPaigongViewController.h"
#import "ManagerLinggongCell.h"
#import "HNLinkageView.h"
#import "HNAlertView.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface MangerLinggongViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MangerLinggongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"领工" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"home_icon" rightAction:@selector(backHome) withVC:self];
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

#pragma 初始化view
-(void)initView{
    [self.view addSubview:[self createTopView]];
    [self.view addSubview:[self createAllSelectView]];
    //添加tableview
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,150*PXSCALEH+NavBarHeight , MainS_Width, MainS_Height-(110*PXSCALEH+NavBarHeight+60*PXSCALEH+40*PXSCALEH))];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCarCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier_SearchCarCell];
    //    //self.tableView.contentInset=UIEdgeInsetsMake(0.0, 0, 0, 0);//tableview scrollview的contentview的顶点相对于scrollview的位置
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self createBottomView]];
}

-(UIView*)createAllSelectView{
    UIView* allSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 110*PXSCALEH+NavBarHeight, MainS_Width, 40*PXSCALEH)];
    allSelectView.backgroundColor = lightBlueColor;
    UIButton *btn = [PublicFunction getButtonInControl:self frame:CGRectMake(20*PXSCALEH, 10*PXSCALEH, 20*PXSCALEH, 20*PXSCALEH) imageName:@"right_now_no" title:nil clickAction:@selector(selectItemBtnClick:)];
    btn.tag = 900;
    [btn setImage:[UIImage imageNamed:@"right_now_no"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"right_now"] forState:UIControlStateSelected];
    
    [allSelectView addSubview:btn];
    
    UILabel* allSelectLabel = [PublicFunction getlabel:CGRectMake(50*PXSCALE, 0, MainS_Width/3*2, 40*PXSCALEH) text:@"全选/取消全选"];
    
    [allSelectView addSubview:allSelectLabel];
    [self.view addSubview:allSelectView];
    
    return allSelectView;
}

#pragma topView
-(UIView*)createTopView{
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, MainS_Width, 110*PXSCALEH)];
    topView.backgroundColor = SetColor(@"#eeeeee", 1);
    UIImageView* leftView = [PublicFunction getImageView:CGRectMake(0, 0, MainS_Width/3, 110*PXSCALEH) imageName:@"car_bk_yel"];
    UILabel* cpLabel = [PublicFunction getlabel:CGRectMake(0, 110*PXSCALEH-30*PXSCALEH, MainS_Width/3, 30*PXSCALEH) text:_model.cp];
    cpLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:leftView];
    [leftView addSubview:cpLabel];
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/3+20*PXSCALE, 0, MainS_Width/3*2-20*PXSCALE, 110*PXSCALEH)];
    UIImageView* dlgImgView = [PublicFunction getImageView:CGRectMake(20*PXSCALE, 5*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"gou_blue"];
    UIImageView* dpgImgView = [PublicFunction getImageView:CGRectMake(20*PXSCALE+40*PXSCALE, 5*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"gou_blue"];

    UILabel* dlgLabel = [PublicFunction getlabel:CGRectMake(0, dlgImgView.frame.origin.y+20*PXSCALEH, 50*PXSCALE, 30*PXSCALEH) text:@"待领工" align:@"center"];
    dlgLabel.font = [UIFont fontWithName:@"Arial" size:13];
    UILabel* dpgLabel = [PublicFunction getlabel:CGRectMake(45*PXSCALE, dlgImgView.frame.origin.y+20*PXSCALEH, 50*PXSCALE, 30*PXSCALEH) text:@"待派工" align:@"center"];
    dpgLabel.font = [UIFont fontWithName:@"Arial" size:13];

    [rightView addSubview:dlgImgView];
    [rightView addSubview:dlgLabel];
    [rightView addSubview:dpgImgView];
    [rightView addSubview:dpgLabel];
    [topView addSubview:rightView];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:_model.jc_date];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString* dateStr = [dateFormatter stringFromDate:date] !=nil ?[dateFormatter stringFromDate:date] :@"";

    NSDate *tcDate = [dateFormatter dateFromString:_model.ywg_date];
    NSString* tcDateStr = [dateFormatter stringFromDate:tcDate] !=nil ?[dateFormatter stringFromDate:tcDate] :@"";
    UILabel* enterDateLabel = [PublicFunction getlabel:CGRectMake(0, 50*PXSCALEH, MainS_Width/3*2, 30*PXSCALE) text:[NSString stringWithFormat:@"进厂时间: %@",dateStr] align:@"left"];
    
    UILabel* yjtcLabel = [PublicFunction getlabel:CGRectMake(0, 80*PXSCALEH, MainS_Width/3*2, 30*PXSCALE) text:[NSString stringWithFormat:@"提车时间: %@",tcDateStr] align:@"left"];
    [rightView addSubview:enterDateLabel];
    [rightView addSubview:yjtcLabel];
    return topView;
}

#pragma bottomView
-(UIView*)createBottomView{
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainS_Height-50*PXSCALEH, MainS_Width, 60*PXSCALEH)];
    NSArray* array ;
    if([_model.states isEqualToString:@"待领工"]){
        array = @[@"调整派工",@"领工"];
    }else if([_model.states isEqualToString:@"修理中"]){
        array = @[@"换人",@"加人",@"退工",@"施工完毕"];
    }else if([_model.states isEqualToString:@"待质检"]){
        array = @[@"返工",@"检验通过"];
    }else if([_model.states isEqualToString:@"已完工"]){
        array = @[@"取消检验",@"去工单"];
    }
    CGFloat btnWidth =(MainS_Width-70*PXSCALE)/4;
    CGFloat btnHeight = 40*PXSCALEH;
    CGFloat offsetX = array.count==2?(MainS_Width-(btnWidth*2+10*PXSCALE))/2:20*PXSCALE;

    for(int i=0;i<array.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%4*(btnWidth+10*PXSCALE)+offsetX, i/4*(btnHeight+10*PXSCALEH), btnWidth, btnHeight) imageName:@"" title:[array objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 110+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:btn];
    }
    
    return bottomView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerLinggongCell* cell = [ManagerLinggongCell cellWithTableView:tableView];
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85*PXSCALEH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ManagerLinggongCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    ManageInfoModel* model = cell.model;
    model.isChecked = !model.isChecked;
    cell.model = model;
    //        NSString* checkedImgName = model.isSelected?@"right_now":@"right_now_no";
    //        [cell.checkBtn setImage:[UIImage imageNamed:checkedImgName] forState:(UIControlStateNormal)];
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
}

#pragma item click
-(void)selectItemBtnClick:(UIButton*)btn{
    if(btn.tag == 900){
        //全选
        btn.selected = !btn.selected;
        for (ManageInfoModel* model in self.dataSource) {
            model.isChecked = btn.selected;
        }
        [self.tableView reloadData];
    }else{
        if([_model.states isEqualToString:@"待领工"]){
            switch (btn.tag) {
                case 110:
                    [self toPaigong];
                    break;

                case 111:
                    [self lingGong];
                    break;
                    
                default:
                    break;
            }
        }else if([_model.states isEqualToString:@"修理中"]){
            switch (btn.tag) {
                case 110:
                    [self huanRen];
                    break;
                case 111:
                    [self jiaRen];
                    break;
                case 112:
                    [self tuiGong];
                    break;
                case 113:
                    [self finishWork];
                    break;
                    
                default:
                    break;
            }
        }else if([_model.states isEqualToString:@"待质检"]){
            switch (btn.tag) {
                case 110:
                    [self fanGong];
                    break;
                case 111:
                    [self crossJianYan];
                    break;
                default:
                    break;
            }
        }else if([_model.states isEqualToString:@"已完工"]){
            switch (btn.tag) {
                case 110:
                    [self cancleJianYan];
                    break;
                case 111:
                    [self toWorkOrder];
                    break;
                default:
                    break;
            }
        }
        
    }
   
}

#pragma 返工
-(void)fanGong{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;
    
    [self postFanGong:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"已返工" With:safeSelf];
            [safeSelf initData];
        }
    }];
}

#pragma 取消检验
-(void)cancleJianYan{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;
    
    [self postCancleJianYan:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"取消检验成功" With:safeSelf];
            [safeSelf initData];
        }
    }];
}

#pragma 检验通过
-(void)crossJianYan{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;
    
    [self postCrossJianYan:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"检验通过" With:safeSelf];
            [safeSelf initData];
        }
    }];
}

#pragma 去工单
-(void)toWorkOrder{
    ProjectOrderViewController* vc = [[ProjectOrderViewController alloc] init];
    CarInfoModel* item = [[CarInfoModel alloc] init];
    item.cjhm = _model.cjhm;
    item.mc = _model.cp;
    item.cx  = _model.cx;
    item.jsd_id = _model.jsd_id;
    vc.model = item;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma 换人
-(void)huanRen{
    [self showDialog:@"换人"];

    
}

-(void)showDialog:(NSString*)title{
    __weak MangerLinggongViewController* safeSelf = self;
    NSString* xhStr = @"";
    for (ManageInfoModel* model in self.dataSource) {
        if(model.isChecked){
            if([xhStr isEqualToString:@""]){
                xhStr = model.xh;
            }else{
                xhStr = [NSString stringWithFormat:@"%@,%@",xhStr,model.xh];
            }
        }
    }
    if([xhStr isEqualToString:@""]){
        [ToolsObject show:@"您还未选择" With:self];
        return;
    }
    NSMutableArray* dataArr = [NSMutableArray array];
    RepairInfoModel* initModel = [[RepairInfoModel alloc] init];
    initModel.xlz = @"全部";
    NSMutableArray* allData = [[DataBaseTool shareInstance] queryRepairPersonListData:@"全部"];
    initModel.children = allData;
    [dataArr addObject:initModel];
    
    NSMutableArray* childData = [[DataBaseTool shareInstance] queryRepairZuListData];
    
    for (int i=0;i<childData.count; i++) {
        RepairInfoModel* model = [childData objectAtIndex:i];
        NSMutableArray* data = [[DataBaseTool shareInstance] queryRepairPersonListData:model.xlz];
        if(data.count>0){
            model.children = data;
            [dataArr addObject:model];
        }
    }
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,200*PXSCALEH)];
    HNLinkageView* linkageView = [[HNLinkageView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 200*PXSCALEH) dataArr:dataArr block:^(NSMutableArray * _Nonnull dataArray) {
        
    }];
    [contentView addSubview:linkageView];
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:title contentView: contentView];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            NSMutableArray* dataArr = linkageView.rightDataArray;
            NSString* choosePersonStr = @"";
            for (RepairInfoModel* model in dataArr) {
                if(model.isSelected){
                    if([choosePersonStr isEqualToString:@""]){
                        choosePersonStr = [NSString stringWithFormat:@"%@",model.xlg];
                    }else{
                        choosePersonStr=[NSString stringWithFormat:@"%@,%@",choosePersonStr,model.xlg];
                    }
                    
                }
            }
            
            if(![choosePersonStr isEqualToString:@""]){
                self.progress = [ToolsObject showLoading:@"加载中" with:self];
                if([title isEqualToString:@"换人"]){
                    [self realReplaceMan:^(NSString *errorMsg, id result) {
                        [safeSelf.progress hideAnimated:YES];
                        if(![errorMsg isEqualToString:@""]){
                            [ToolsObject show:errorMsg With:safeSelf];
                        }else{
                            [ToolsObject show:@"换人成功" With:safeSelf];
                            [safeSelf initData];
                        }
                    } xhStr:xhStr choosePersons:choosePersonStr];
                }else if([title isEqualToString:@"加人"]){
                    [self realAddMan:^(NSString *errorMsg, id result) {
                        [safeSelf.progress hideAnimated:YES];
                        if(![errorMsg isEqualToString:@""]){
                            [ToolsObject show:errorMsg With:safeSelf];
                        }else{
                            [ToolsObject show:@"加人成功" With:safeSelf];
                            [safeSelf initData];
                        }
                    } xhStr:xhStr choosePersons:choosePersonStr];
                }
            }
            
            
            
        }else{
            
        }
    }];
}

#pragma 退工
-(void)tuiGong{
    NSString* xhStr = @"";
    for (ManageInfoModel* model in self.dataSource) {
        if(model.isChecked){
            if([xhStr isEqualToString:@""]){
                xhStr = model.xh;
            }else{
                xhStr = [NSString stringWithFormat:@"%@,%@",xhStr,model.xh];
            }
        }
    }
    if([xhStr isEqualToString:@""]){
        [ToolsObject show:@"您还未选择" With:self];
        return;
    }
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;

    [self postTuiGong:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"退工成功" With:safeSelf];
            [safeSelf initData];
        }
    } xhStr:xhStr];

}

#pragma 领工
-(void)lingGong{
    
    NSString* xhStr = @"";
    for (ManageInfoModel* model in self.dataSource) {
        if(model.isChecked){
            if([xhStr isEqualToString:@""]){
                xhStr = model.xh;
            }else{
                xhStr = [NSString stringWithFormat:@"%@,%@",xhStr,model.xh];
            }
        }
    }
    if([xhStr isEqualToString:@""]){
        [ToolsObject show:@"您还未选择" With:self];
        return;
    }
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;
    
    [self postLingGong:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"领工成功" With:safeSelf];
            [safeSelf initData];
        }
    } xhStr:xhStr];
}

#pragma 加人
-(void)jiaRen{
    [self showDialog:@"加人"];
}

#pragma 施工完毕
-(void)finishWork{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;
    
    [self postFinishWork:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            [ToolsObject show:@"施工完毕" With:safeSelf];
            [safeSelf initData];
        }
    }];
}

#pragma 派工
-(void)toPaigong{
    //跳转派工
    ProjectPaigongViewController* vc = [[ProjectPaigongViewController alloc] init];
    CarInfoModel* item = [[CarInfoModel alloc] init];
    item.cjhm = _model.cjhm;
    item.mc = _model.cp;
    item.cx  = _model.cx;
    item.jsd_id = _model.jsd_id;
    vc.model = item;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma 初始化数据
-(void)initData{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    __weak MangerLinggongViewController* safeSelf = self;
    [self getLinggongData:^(NSString *errorMsg, id result) {
        [safeSelf.progress hideAnimated:YES];
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            safeSelf.dataSource = result;
            [safeSelf.tableView reloadData];
        }
    }];
}

#pragma 退工
-(void)postTuiGong:(asyncCallback)callback xhStr:(NSString*)xhStr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_jsdmx_xlxm_xlg";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"xh_list"] = xhStr;
    dict[@"assign"] = @"";

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

#pragma 退工
-(void)postLingGong:(asyncCallback)callback xhStr:(NSString*)xhStr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_jsdmx_xlxm_xlg";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"xh_list"] = xhStr;
    dict[@"assign"] = [ToolsObject getChineseName];
    
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

#pragma 通过检验
-(void)postCrossJianYan:(asyncCallback)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_repair_list_state";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"states"] = @"";
    dict[@"xm_state"] = @"已完工";

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


#pragma 取消检验
-(void)postCancleJianYan:(asyncCallback)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_repair_list_state";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"states"] = @"修理中";
    dict[@"xm_state"] = @"待质检";
    
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



#pragma 施工完毕
-(void)postFinishWork:(asyncCallback)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_repair_list_state";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"states"] = @"已完工";
    dict[@"xm_state"] = @"已完工";

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



#pragma 返工
-(void)postFanGong:(asyncCallback)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_repair_list_state";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"states"] = @"修理中";
    dict[@"xm_state"] = @"修理中";
    
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

#pragma 加入
-(void)realAddMan:(asyncCallback)callback xhStr:(NSString*)xhStr choosePersons:(NSString*)persons{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_jsdmx_xlxm_xlg";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"xh_list"] = xhStr;
    dict[@"assign"] = persons;
    
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

#pragma 替换人员
-(void)realReplaceMan:(asyncCallback)callback xhStr:(NSString*)xhStr choosePersons:(NSString*)persons{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_jsdmx_xlxm_xlg";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    dict[@"xh_list"] = xhStr;
    dict[@"assign"] = persons;
    
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

-(void)getLinggongData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repair_project_schedule";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [ManageInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            callback(@"",array);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma mark - Getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
