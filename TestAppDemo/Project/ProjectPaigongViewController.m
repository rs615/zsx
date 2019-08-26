//
//  ProjectPaigongViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectPaigongViewController.h"
#import "PaigongInfoModel.h"
#import "HNLinkageView.h"
#import "PaigongCell.h"
#import "HNAlertView.h"
#import "RepairInfoModel.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface ProjectPaigongViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic,strong)HNBankView *abankView;//缺省页
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,assign)int postNum;//缺省页
@property (nonatomic,assign)int allNum;//缺省页

@end
@implementation ProjectPaigongViewController



-(void) viewDidLoad
{
    [self initView];
    [self initData];
}

#pragma --------------------view

-(void)initView{
    [self setNavTitle:@"派工" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"home_icon" rightAction:@selector(backHome) withVC:self];
    [self initTopView];
    [self initContentView];
    [self initBottomView];
}

-(void)initTopView{
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
    [self.view addSubview:view];

}

-(void)initContentView{
    __weak ProjectPaigongViewController *safeSelf = self;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,40*PXSCALEH+NavBarHeight , MainS_Width, MainS_Height-40*PXSCALEH-60*PXSCALEH-NavBarHeight)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [safeSelf loadPaigongData];
    }] ;
    self.tableView.dataSource = self;
        if (NetworkIsStatusNotReachable) {     // 加载失败，网络原因
            NotNetworkTip;
        }
        else{
        }
    [self.view addSubview:self.tableView];
}

-(void)initBottomView{
    CGFloat btnWidth = (MainS_Width-60*PXSCALEH-40*PXSCALE)/3;
    CGFloat btnHeight = 40*PXSCALEH;

    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/2-(2*btnWidth+10*PXSCALE)/2, MainS_Height-60*PXSCALEH, 2*btnWidth+10*PXSCALE, 60*PXSCALEH)];

    NSArray* paigongMenuArr = @[@"派工",@"车间管理"];
    for(int i=0;i<paigongMenuArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE),10*PXSCALEH, btnWidth, btnHeight) imageName:@"" title:[paigongMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 110+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:btn];
    }
    [self.view addSubview:bottomView];

}


#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaigongCell* cell = [PaigongCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 170*PXSCALEH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaigongCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    PaigongInfoModel* model = cell.model;
    model.checked = !model.checked;
    cell.model = model;
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
}

#pragma mark - 属性
-(HNBankView *)abankView
{
    if(!_abankView){
        _abankView = [[HNBankView alloc]initWithBankViewFrame:CGRectMake(0,self.tableView.frame.origin.y, MainS_Width, self.tableView.frame.size.height) withImage:@"rijibenweikong" withMessgess:@"暂无数据"];
        [_abankView.agreenBut removeFromSuperview];
        //        [_abankView.agreenBut addTarget:self action:@selector(refreshManagerList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _abankView;
}

#pragma btn
-(void)selectItemBtnClick:(UIButton*)btn{
    switch (btn.tag) {
        case 110:
            [self showDialog];
            break;
        case 111:
            break;
        default:
            break;
    }
}

#pragma 显示对话框   
-(void)showDialog{
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
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"派工" contentView: contentView];
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
                [self updatePaigongData:^(NSString *errorMsg, id result) {
                    [self.progress hideAnimated:YES];
                    if([result isEqualToString:@"true"]){
                        [self.tableView reloadData];
                    }
                } persons:choosePersonStr];
            }
          
          
           
        }else{
            
        }
    }];
}


#pragma --------------------end view


#pragma 更新数据
-(void)updatePaigongData:(asyncCallback)newCallback persons:(NSString*)choosePersons{
    self.postNum = 0;
    self.allNum = 0;
    __weak ProjectPaigongViewController* safeSelf = self;
    NSString* isUpdate = @"false";
    BOOL isFinish = NO;
    for (int i=0;i<self.dataSource.count;i++) {
        PaigongInfoModel* model = [self.dataSource objectAtIndex:i];
        if(model.checked){
            self.allNum++;
        }
    }
    for (int i=0;i<_allNum;i++) {
        PaigongInfoModel* model = [self.dataSource objectAtIndex:i];
        [self toPGDataToServer:model choosePerson:choosePersons callback:^(NSString *errorMsg, id result) {
            safeSelf.postNum++;
            if([errorMsg isEqualToString:@""]){
                model.assign = choosePersons;
                model.checked = NO;
                [safeSelf.dataSource replaceObjectAtIndex:i withObject:model];
            }
            if(safeSelf.postNum>=safeSelf.allNum){
                newCallback(@"",@"true");
            }
           
        }];
    }
    if(_allNum==0){
        newCallback(@"",@"false");

    }
   
}


#pragma --------------------data
-(void)initData{
    [self loadPaigongData];
}

-(void)loadPaigongData{
    __weak ProjectPaigongViewController *safeSelf = self;
    self.progress = [ToolsObject showLoading:@"加载中" with:self];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_jsdmx_xlxm_assign";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;//车间管理
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [PaigongInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            safeSelf.dataSource = array;
            [safeSelf showView];
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            [safeSelf showErrorInfo:msg];

        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf showErrorInfo:@"网络错误"];
    }];
    
}

-(void)toPGDataToServer:(PaigongInfoModel*)model choosePerson:(NSString*)persons callback:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_jsdmx_xlxm_assign";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;//车间管理
    dict[@"xh"] = model.xh;//
    dict[@"assign"] = persons;//车间管理
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



#pragma mark - Getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma 显示空白view
-(void)showErrorInfo:(NSString*)error{
    self.abankView.titleLabel.text = error;
    [self.progress hideAnimated:YES];
    [self.view addSubview:self.abankView];
}

-(void)showView{
    if (self.abankView.superview) {
        [self.abankView removeFromSuperview];
    }
    [self.progress hideAnimated:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    
}
#pragma --------------------end data


@end
