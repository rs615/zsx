//
//  ProjectOrderViewController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectOrderViewController.h"
#import "PeijianSelectViewController.h"
#import "ProjectPaigongViewController.h"
#import "ProjectSelectViewController.h"
#import "ProjectViewController.h"
#import "ProjectJiesuanViewController.h"
#import "ProjectModel.h"
#import "PeijianModel.h"
#import "OrderCarInfoModel.h"
#import "PeijianCell.h"
#import "ProjectCell.h"
#import "HNAlertView.h"
#import "TempPartsModel.h"

typedef void (^asyncCallback)(NSString* errorMsg,id result);

#define GZDeviceWidth ([UIScreen mainScreen].bounds.size.width)
@interface ProjectOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView* baseView;
@property (nonatomic, strong) UIView* moreView;
@property (nonatomic, strong) UIImageView* waigongImgView;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) NSMutableArray *peijianArray;
@property (nonatomic, strong) NSMutableArray *orderCarArray;
@property (nonatomic,strong)HNBankView *abankView;//缺省页


@end

@implementation ProjectOrderViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_isNeedRefresh){
        [self initData];
    }
}


-(void)initView
{
    [self setNavTitle:@"工单" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
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

    
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"项目",@"配件", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    segment.frame = CGRectMake(0, view.frame.origin.y+view.frame.size.height+2*PXSCALEH, MainS_Width, 40*PXSCALEH);
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
    
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, segment.frame.origin.y+segment.bounds.size.height, MainS_Width, MainS_Height-(segment.frame.origin.y+segment.bounds.size.height))];
    [self.view addSubview:self.baseView];
    
    self.moreView = [[UIView alloc] initWithFrame:CGRectMake(0, segment.frame.origin.y+segment.bounds.size.height, MainS_Width, MainS_Height-(segment.frame.origin.y+segment.bounds.size.height))];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , segment.frame.origin.y+segment.bounds.size.height , MainS_Width, MainS_Height-(segment.frame.origin.y+segment.bounds.size.height+10+100*PXSCALEH))];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCarCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier_SearchCarCell];
    //    //self.tableView.contentInset=UIEdgeInsetsMake(0.0, 0, 0, 0);//tableview scrollview的contentview的顶点相对于scrollview的位置
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    }] ;
    //第一次进来可以刷新
//    [self.tableView.mj_header beginRefreshing];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (NetworkIsStatusNotReachable) {     // 加载失败，网络原因
        NotNetworkTip;
        [self.view addSubview:self.abankView];
    }
    else{
        [self.view addSubview:self.tableView];
    }
    
    [self initBottomView];
    
    _waigongImgView = [PublicFunction getImageView:CGRectMake((MainS_Width-150)/2, (MainS_Height-100)/2, 150, 100) imageName:@"img_wg"];
    _waigongImgView.hidden = YES;
    [self.view addSubview:_waigongImgView];
}

#pragma 底部
-(void)initBottomView{
    UIView* baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(20*PXSCALE, self.baseView.bounds.size.height-100*PXSCALEH, MainS_Width-20*PXSCALE, 100*PXSCALEH)];
    CGFloat btnWidth = (baseBottomView.bounds.size.width-40*PXSCALE)/3;
    CGFloat btnHeight = 40*PXSCALEH;
    NSArray* projectMenuArr = @[@"钣金喷漆",@"项目库",@"临时项目",@"本车首页",@"全部完工",@"结算"];
    for(int i=0;i<projectMenuArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE), i/3*(btnHeight+10*PXSCALEH), btnWidth, btnHeight) imageName:@"" title:[projectMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 120+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [baseBottomView addSubview:btn];
    }
    [self.baseView addSubview:baseBottomView];
    UIView* moreBottomView = [[UIView alloc] initWithFrame:CGRectMake(20*PXSCALE, self.baseView.bounds.size.height-50*PXSCALEH, MainS_Width-20*PXSCALE, 60*PXSCALEH)];

    NSArray* peijianMenuArr = @[@"配件库",@"本车首页",@"结算"];
    for(int i=0;i<peijianMenuArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE), i/3*(btnHeight+10*PXSCALEH), btnWidth, btnHeight) imageName:@"" title:[peijianMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 110+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreBottomView addSubview:btn];
    }
    [self.moreView addSubview:moreBottomView];
}

#pragma btn
-(void)selectItemBtnClick:(UIButton*)btn{
    

    switch (btn.tag) {
        case 110:
            //新增配件库
            [self enterPeijianSelect];
            break;
        case 111://本车首页
            [self enterProject];
            break;
        case 112://结算
            [self enterProjectJiesuan];
            break;
            
        case 120://钣金喷漆
            break;
        case 121://项目库
            [self enterProjectSelect];

            break;
        case 122://临时项目
            [self showAddTempProDialog];
            break;
        case 123://本车首页
            [self enterProject];

            break;
        case 124://派工
            [self judgeToStatus];
            break;
        case 125://结算
            [self enterProjectJiesuan];
            break;
            
        default:
            break;
    }
}


#pragma 初始化h数据
-(void)initData{
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    _jsd_id = _model.jsd_id;
    __weak ProjectOrderViewController *safeSelf = self;

    //这里查询了本地数据
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [self getProjectListData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.projectArray = result;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [self getPjListData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.peijianArray = result;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [self getJsdInfo:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.orderCarArray = result;
        }
        dispatch_group_leave(group);
    }];
    
    
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [safeSelf.progress hideAnimated:YES];
        if(![safeSelf.errorMsg isEqualToString:@""]&&safeSelf.errorMsg!=nil){
            [ToolsObject show:safeSelf.errorMsg With:safeSelf];
        }
        if(safeSelf.moreView.hidden){
            safeSelf.dataSource = safeSelf.projectArray;
        }else{
            safeSelf.dataSource = safeSelf.peijianArray;
        }
        //更新当前状态的按钮
        OrderCarInfoModel* model = [safeSelf.orderCarArray objectAtIndex:0];
        UIButton* btn = (UIButton*)[safeSelf.baseView viewWithTag:124];
        if([model.djzt isEqualToString:@"待修"]||[model.djzt isEqualToString:@"处理中"]){
            [btn setTitle:@"派工" forState:UIControlStateNormal];
        }else if([model.djzt isEqualToString:@"已派工"]||[model.djzt isEqualToString:@"修理中"]){
            [btn setTitle:@"全部完工" forState:UIControlStateNormal];
        }else if([model.djzt isEqualToString:@"审核已结算"]){
            // 显示完工图片
            safeSelf.waigongImgView.hidden = NO;
            [btn setTitle:@"取消完工" forState:UIControlStateNormal];
        }else if([model.djzt isEqualToString:@"审核未结算"]){
            // 显示完工图片
            [btn setTitle:@"取消完工" forState:UIControlStateNormal];
            safeSelf.waigongImgView.hidden = NO;

        }else if([model.djzt isEqualToString:@"已出厂"]){
            /*
             OrderBeanInfo.allBtnUnable = true;
             paigong.setText("取消完工");
             yccType = true;
             djztUnable = true;
             total_jiesuan.setEnabled(false);
             project_ck.setEnabled(false);
             temp_pro.setEnabled(false);
             peijianku.setEnabled(false);
             total_jiesuan.setBackgroundColor(Color.parseColor("#cccccc"));
             project_ck.setBackgroundColor(Color.parseColor("#cccccc"));
             temp_pro.setBackgroundColor(Color.parseColor("#cccccc"));
             peijianku.setBackgroundColor(Color.parseColor("#cccccc"));
             mOrderAdapter.notifyDataSetChanged();
             mPeijianAdapter.notifyDataSetChanged();
            
            setJiesuanEable(true);
             */
            // 显示完工图片
            [btn setTitle:@"取消完工" forState:UIControlStateNormal];
        }
        if(safeSelf.dataSource.count==0){
//            [safeSelf.view addSubview:safeSelf.abankView];
        }else{
        }
        [safeSelf.tableView reloadData];
       

    });
}

#pragma 结算单
-(void)getJsdInfo:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_repair_list_main";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
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

#pragma 配件列表
-(void)getPjListData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_jsdmx_pjclmx";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [PeijianModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 项目列表
-(void)getProjectListData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"asa_to_sql";
    dict[@"function"] = @"sp_fun_down_jsdmx_xlxm";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [ProjectModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma segment选择
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.baseView.hidden = NO;
            self.moreView.hidden = YES;
            self.dataSource = self.projectArray;
            break;
        case 1:
            self.baseView.hidden = YES;
            self.moreView.hidden = NO;
            self.dataSource = self.peijianArray;

            break;
            
        default:
            NSLog(@"3");
            break;
    }
    [self.tableView reloadData];//刷新数据
}




#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0||section==2){
        return 1;
    }
    
    return self.dataSource.count;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma moreCell
-(UITableViewCell *)createMoreCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
        cell.selectedBackgroundView = [[UIView alloc] init];
        //就这两句代码
        cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];

        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 100*PXSCALEH)];
     
        NSArray* titleArr = @[@"配件名称",@"规格",@"数量",@"单价",@"合计",@"操作"];
        for(int i=0;i<titleArr.count;i++){
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/6, 0, MainS_Width/6, 40*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:14 color:[UIColor blackColor] align:@"center"];
            titleLabel.backgroundColor = lightBlueColor;
            [contentView addSubview:titleLabel];
        }
        [cell.contentView addSubview:contentView];
        
        return cell;
    }else if(indexPath.section==2){
      
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
        cell.selectedBackgroundView = [[UIView alloc] init];
        //就这两句代码
        cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];

        float totalMoneyFloat = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        for(PeijianModel* model in self.peijianArray){
            float totalMoney = [model.sl floatValue]*[model.ssj floatValue];
            totalMoneyFloat += totalMoney;
        }
        float totalPjfMoney = (float)(round(totalMoneyFloat*100))/100;

        NSString* zongyingshou = [NSString stringWithFormat:@"%.2f",totalPjfMoney];
        NSString* peijian = [NSString stringWithFormat:@"%.2f",totalMoneyFloat];
        NSString* peijianzk = [NSString stringWithFormat:@"0",0];//折扣这里又问题
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 90*PXSCALEH)];
        NSArray* titleArr = @[@"配件",@"配件打折:",@"总应收"];
        NSArray* valueArr = @[peijian,peijianzk,zongyingshou];

        for(int i=0;i<titleArr.count;i++){
            UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, i*40*PXSCALEH, MainS_Width, 40*PXSCALEH)];
            if(i%2==0){
                tmpView.backgroundColor = lightBlueColor;
            }else{
                tmpView.backgroundColor = lightGrayColor;
            }
            
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, 0, MainS_Width/2, 40*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:14 color:[UIColor blackColor] align:@"center"];
            UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/2, 0, MainS_Width/2, 40*PXSCALEH) text:@"" fontSize:14 color:[UIColor blackColor] align:@"center"];
            valueLabel.text = [valueArr objectAtIndex:i];
            [tmpView addSubview:titleLabel];
            [tmpView addSubview:valueLabel];
            [view addSubview:tmpView];
        }
        [cell.contentView addSubview:view];
        return cell;
    }else{
        PeijianCell* cell = [PeijianCell cellWithTableView:tableView];
        PeijianModel* model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
        cell.selectedBackgroundView = [[UIView alloc] init];
        //就这两句代码
        cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];

        cell.model = model;
        cell.block = ^(NSInteger index) {
            if(index==110){
                //删除
                [self showDeletePeijianDialog:model indexPath:indexPath];
            }else if(index==111){
                //编辑
                [self showUpdatePeijianDialog:model indexPath:indexPath];
            }
        };
        return cell;
    }
    
}


#pragma baseCell
-(UITableViewCell *)createBaseCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    OrderCarInfoModel* model = [[OrderCarInfoModel alloc] init];

    if(indexPath.section==0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(self.orderCarArray.count>0){
            model = [self.orderCarArray objectAtIndex:0];
        }
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 110*PXSCALEH)];
        UILabel* label = [PublicFunction getlabel:CGRectMake(10*PXSCALE, 10*PXSCALEH, MainS_Width/2-25*PXSCALE, 30*PXSCALEH) text:@"公里数:" size:13 align:@"left"];
        label.text = [NSString stringWithFormat:@"公里数:%@",model.jclc!=nil?model.jclc:@""];

        UIImageView* editImgView = [PublicFunction getImageView:CGRectMake( label.bounds.size.width+10*PXSCALE, 15*PXSCALEH, 15*PXSCALE, 15*PXSCALEH) imageName:@"edit"];
        
        UILabel* ywgLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/2, 10*PXSCALEH, MainS_Width/2-15*PXSCALE, 30*PXSCALEH) text:@"预完工日期:" size:13 align:@"left"];
        ywgLabel.text = [NSString stringWithFormat:@"预完工日期:%@",model.ywg_date!=nil?model.ywg_date:@""];

        UIImageView* ywgEditImgView = [PublicFunction getImageView:CGRectMake( ywgLabel.bounds.size.width+MainS_Width/2, 15*PXSCALEH, 15*PXSCALE, 15*PXSCALEH) imageName:@"edit"];
        
        UILabel* gzmsLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, label.bounds.size.height+label.frame.origin.y, MainS_Width-25*PXSCALE, 30*PXSCALEH) text:@"故障描述:" size:13 align:@"left"];
        gzmsLabel.text = [NSString stringWithFormat:@"故障描述:%@",model.car_fault!=nil?model.car_fault:@""];

        UIImageView* gzmsEditImgView = [PublicFunction getImageView:CGRectMake( gzmsLabel.bounds.size.width+10*PXSCALE, 15*PXSCALEH, 15*PXSCALE, 15*PXSCALEH) imageName:@"edit"];

        [contentView addSubview:gzmsEditImgView];
        [contentView addSubview:gzmsLabel];

        [contentView addSubview:ywgEditImgView];
        [contentView addSubview:ywgLabel];
        [contentView addSubview:editImgView];
        [contentView addSubview:label];
       
        NSArray* titleArr = @[@"项目名称",@"性质",@"修理费",@"优惠",@"操作"];
        for(int i=0;i<titleArr.count;i++){
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(i*MainS_Width/5, gzmsLabel.frame.origin.y+gzmsLabel.bounds.size.height, MainS_Width/5, 40*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:14 color:[UIColor blackColor] align:@"center"];
            titleLabel.backgroundColor = lightBlueColor;
            [contentView addSubview:titleLabel];
        }
        [cell.contentView addSubview:contentView];

        return cell;
    }else if(indexPath.section==2){
        float totalXlf = 0;
        float totalXlfZk = 0;
        for (ProjectModel* model in self.projectArray) {
            float xlf = [model.xlf floatValue];
            float xlfZk = [model.zk floatValue];
            totalXlf +=xlf;
            totalXlfZk +=xlfZk;
        }
        NSString* zongyingshou = [NSString stringWithFormat:@"总计:%.2f",totalXlf-totalXlfZk];
        NSString* gongshi = [NSString stringWithFormat:@"总计:%.2f",totalXlf];
        NSString* gszk = [NSString stringWithFormat:@"总计:%.2f",totalXlfZk];
        NSString* memo = model.memo!=nil?model.memo:@"";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 120*PXSCALEH)];
        NSArray* titleArr = @[@"工时",@"工时打折:",@"总应收",@"备注:"];
        NSArray* valueArr = @[gongshi,gszk,zongyingshou,memo];

        for(int i=0;i<titleArr.count;i++){
            UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, i*40*PXSCALEH, MainS_Width, 40*PXSCALEH)];
            if(i%2==0){
                tmpView.backgroundColor = lightBlueColor;
            }else{
                tmpView.backgroundColor = lightGrayColor;
            }
            UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, 0, MainS_Width/2, 40*PXSCALEH) text:[titleArr objectAtIndex:i] fontSize:14 color:[UIColor blackColor] align:@"center"];
            UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/2, 0, MainS_Width/2, 40*PXSCALEH) text:@"" fontSize:14 color:[UIColor blackColor] align:@"center"];
            valueLabel.text =[valueArr objectAtIndex:i]!=nil?[valueArr objectAtIndex:i]:@"";
            [tmpView addSubview:titleLabel];
            [tmpView addSubview:valueLabel];
            [view addSubview:tmpView];
        }
        [cell.contentView addSubview:view];
        return cell;
    }else{
        ProjectCell* cell = [ProjectCell cellWithTableView:tableView];
        ProjectModel* model = self.dataSource[indexPath.row];
        cell.model = model;
        cell.block = ^(NSInteger index) {
            if(index==110){
                //删除
                [self showDeleteDialog:model indexPath:indexPath];
            }else if(index == 111){
                [self showUpdateDialog:model indexPath:indexPath];
            }
        };
        return cell;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.moreView.hidden){
        return [self createBaseCell:tableView withIndexPath:indexPath];
    }else{
        return [self createMoreCell:tableView withIndexPath:indexPath];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(self.moreView.hidden){
            return 110*PXSCALEH;
        }else{
            return 40*PXSCALEH;
        }
    }else if(indexPath.section==2){
        if(self.moreView.hidden){
            return 150*PXSCALEH;
        }else{
            return 120*PXSCALEH;
        }
    }
    return 80*PXSCALEH;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}



#pragma mark - Getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Getters
- (NSMutableArray *)projectArray
{
    if (!_projectArray) {
        _projectArray = [NSMutableArray array];
    }
    return _projectArray;
}

#pragma mark - Getters
- (NSMutableArray *)peijianArray
{
    if (!_peijianArray) {
        _peijianArray = [NSMutableArray array];
    }
    return _peijianArray;
}

#pragma mark - Getters
- (NSMutableArray *)orderCarArray
{
    if (!_orderCarArray) {
        _orderCarArray = [NSMutableArray array];
    }
    return _orderCarArray;
}

#pragma 删除项目数据
-(void)showDeleteDialog:(ProjectModel*)model indexPath:(NSIndexPath*)indexPath{
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:[NSString stringWithFormat:@"确定删除: %@",model.xlxm] withTitle:@"提示" contentView: nil];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
        }else{
            
        }
    }];
}




#pragma 删除配件dialog
-(void)showDeletePeijianDialog:(PeijianModel* )model  indexPath:(NSIndexPath *)indexPath{
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:[NSString stringWithFormat:@"确定删除: %@",model.pjmc] withTitle:@"提示" contentView: nil];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            [self deletePeijianData:model indexPath:indexPath];
        }else{
            
        }
    }];
}

#pragma 修改项目
-(void)showUpdateDialog:(ProjectModel*)model indexPath:(NSIndexPath *)indexPath{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,270*PXSCALEH)];
    NSArray* titleArr = @[@"项目名称:",@"性质:",@"项目价格:",@"项目优惠:",@"保存新价格:"];
    NSString* pname =model.xlxm!=nil?model.xlxm:@"";
    NSString* wxgz = model.wxgz!=nil?model.wxgz:@"";
    NSString* xlf = model.xlf!=nil?model.xlf:@"";
    NSString* zk = model.zk!=nil?model.zk:@"";
    NSArray* valueArr = @[pname,wxgz,xlf,zk];
    for(int i=0;i<titleArr.count;i++){
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, i*40*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/3, 40*PXSCALEH) text:[titleArr objectAtIndex:i] size:14 align:@"center"];
        [contentView addSubview:titleLabel];
        
        if(i==titleArr.count-1){
            UIButton* checkBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*40*PXSCALEH+12*PXSCALEH*(i+1),  20*PXSCALEH, 20*PXSCALEH) imageName:@"right_now_no" title:@"" clickAction:@selector(btnSelect:)];
            [checkBtn setImage:[UIImage imageNamed:@"right_now"] forState:UIControlStateSelected];
            [checkBtn setImage:[UIImage imageNamed:@"right_now_no"] forState:UIControlStateNormal];
            checkBtn.tag = 510;
            [contentView addSubview:checkBtn];
        }else{
            UITextField* valueTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*40*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/3*2, 40*PXSCALEH) tag:200+i returnType:@""];
            valueTextField.text = [valueArr objectAtIndex:i];
            valueTextField.tag = 500+i;
            [contentView addSubview:valueTextField];
        }
        
        
    }
    
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"修改" contentView: contentView];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            
        }else{
            
        }
    }];
}

#pragma 修改配件

-(void)showUpdatePeijianDialog:(PeijianModel*)model indexPath:(NSIndexPath *)indexPath{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,270*PXSCALEH)];
    NSArray* titleArr = @[@"配件名称:",@"规格:",@"数量:",@"单价:",@"保存新价格:"];
    NSString* peijianname =model.pjmc!=nil?model.pjmc:@"";
    NSString* guige = model.pjbm!=nil?model.pjbm:@"";
    NSString* sl = model.sl!=nil?model.sl:@"";
    NSString* dj = model.ssj!=nil?model.ssj:@"";
    NSArray* valueArr = @[peijianname,guige,sl,dj];
    for(int i=0;i<titleArr.count;i++){
          UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, i*40*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/3, 40*PXSCALEH) text:[titleArr objectAtIndex:i] size:14 align:@"center"];
        [contentView addSubview:titleLabel];

        if(i==titleArr.count-1){
            UIButton* checkBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*40*PXSCALEH+12*PXSCALEH*(i+1),  20*PXSCALEH, 20*PXSCALEH) imageName:@"right_now_no" title:@"" clickAction:@selector(btnSelect:)];
            [checkBtn setImage:[UIImage imageNamed:@"right_now"] forState:UIControlStateSelected];
            [checkBtn setImage:[UIImage imageNamed:@"right_now_no"] forState:UIControlStateNormal];
            checkBtn.tag = 510;
            [contentView addSubview:checkBtn];
        }else{
            UITextField* valueTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*40*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/3*2, 40*PXSCALEH) tag:200+i returnType:@""];
            valueTextField.text = [valueArr objectAtIndex:i];
            valueTextField.tag = 500+i;
            [contentView addSubview:valueTextField];
        }
       
        
    }
    
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"修改配件" contentView: contentView];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            
        }else{
            
        }
    }];

}

#pragma btn点击
-(void)btnSelect:(UIButton*)btn{
    switch (btn.tag) {
        case 510:
            btn.selected = !btn.selected;
        default:
            break;
    }
}

#pragma 删除配件
-(void)deletePeijianData:(PeijianModel*)model indexPath:(NSIndexPath *)indexPath{
    __weak ProjectOrderViewController *safeSelf = self;
    self.progress = [ToolsObject showLoading:@"加载中" with:self];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = @"sjsoft_SQL";
    dict[@"function"] = @"sp_fun_delete_maintenance_project_detail";//车间管理
    dict[@"jsd_id"] = _jsd_id;// 传过来
    dict[@"xh"] = model.xh;// 传过来
    //api有问题
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        [safeSelf.progress hideAnimated:YES];
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            //删除成功
            [safeSelf.peijianArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            [safeSelf showErrorInfo:msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [safeSelf showErrorInfo:@"网络错误"];

    }];
}

#pragma 显示空白view
-(void)showErrorInfo:(NSString*)error{
    [self.progress hideAnimated:YES];

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


#pragma 底部bottomview

#pragma 增加临时项目
-(void)showAddTempProDialog{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,270*PXSCALEH)];
    NSArray* titleArr = @[@"项目名称",@"维修成本",@"项目价格",@"项目类别"];
    
    for(int i=0;i<titleArr.count;i++){
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, i*40*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/3, 40*PXSCALEH) text:[NSString stringWithFormat:@"%@:",[titleArr objectAtIndex:i]] size:14 align:@"center"];
        [contentView addSubview:titleLabel];
        
        if(i==titleArr.count-1){
        }else{
            UITextField* valueTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width, i*40*PXSCALEH+10*PXSCALEH*(i+1), (contentView.bounds.size.width-20*PXSCALE)/3*2, 40*PXSCALEH) tag:200+i returnType:@""];
            valueTextField.tag = 900+i;
            valueTextField.placeholder = [NSString stringWithFormat:@"请输入%@",[titleArr objectAtIndex:i]];
            [contentView addSubview:valueTextField];
        }
        
        
    }
    
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"修改配件" contentView: contentView];
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            
        }else{
            
        }
    }];
}

#pragma 配件选择
-(void)enterPeijianSelect{
    PeijianSelectViewController* vc = [[PeijianSelectViewController alloc] init];
    vc.jsd_id = _jsd_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 项目选择
-(void)enterProjectSelect{
    ProjectSelectViewController* vc = [[ProjectSelectViewController alloc] init];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 项目首页
-(void)enterProject{
    ProjectViewController* vc = [[ProjectViewController alloc] init];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 结算
-(void)enterProjectJiesuan{
    ProjectJiesuanViewController* vc = [[ProjectJiesuanViewController alloc] init];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma 派工
-(void)judgeToStatus{
    
    UIButton* paigongBtn = (UIButton*)[self.baseView viewWithTag:124];
    NSString* paigongStatus = paigongBtn.currentTitle;
    if([@"派工" isEqualToString:paigongStatus]){
        //调入派工
        ProjectPaigongViewController *vc  =[[ProjectPaigongViewController alloc] init];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([@"全部完工" isEqualToString:paigongStatus]){
        
    }else if([@"取消完工" isEqualToString:paigongStatus]){
        
    }
}
@end
