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
#import "EBDropdownListView.h"
#import "ManageInfoModel.h"
#import "FactoryListCell.h"
#import "ProjectOrderViewController.h"
#import "CarInfoModel.h"
@interface FarctoryListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)EBDropdownListView *dropdownListView;//下拉列表
@property (nonatomic,strong)NSArray *contentArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)HNBankView *abankView;//缺省页
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,strong)NSString *cp;
@property (nonatomic,strong)NSString *orderStr;

@end

@implementation FarctoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"在厂车辆" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    _contentArr = @[@"估价中",@"待派工",@"待领工",@"修理中",@"待质检",@"待结算",@"待出厂" ];

    [self initView];
    [self initData];
}

-(void)initView{
    
    UIView* searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(0, 80, GZDeviceWidth, 40);
    UITextField * textFieldCpSearch = [[UITextField alloc]initWithFrame:CGRectMake(GZDeviceWidth*0.1, 0, GZDeviceWidth*0.7, 40)];
    textFieldCpSearch.borderStyle = UITextBorderStyleNone;
    // 设置提示文字
    textFieldCpSearch.placeholder = @"车牌";
    textFieldCpSearch.tag = 1000;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,39, GZDeviceWidth*0.7, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [textFieldCpSearch addSubview:lineView];
    
    [searchView addSubview:textFieldCpSearch];
    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(GZDeviceWidth*0.8, 0, GZDeviceWidth*0.1, 40);
    imageView2.layer.cornerRadius = 8;
    imageView2.layer.masksToBounds = YES;
    imageView2.tag = 1001;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:tap0];

    //自适应图片宽高比例
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [searchView addSubview:imageView2];
    
    
    [self.view addSubview:searchView];
    
    UIView* redView = [[UIView alloc] init];
    redView.frame = CGRectMake(0,130, GZDeviceWidth, 50);
    redView.backgroundColor = lightPinkColor;
    
    _dropdownListView = [[EBDropdownListView alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    NSMutableArray* array = [NSMutableArray array];
    for(int i=0;i<_contentArr.count;i++){
        EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:[NSString stringWithFormat:@"%d",i] itemName:[_contentArr objectAtIndex:i]];
        [array addObject:item];
    }
    _dropdownListView.layer.cornerRadius = 6;
    _dropdownListView.layer.borderWidth = 1;
    [_dropdownListView setBackgroundColor:[UIColor whiteColor]];
    [_dropdownListView setDataSource:array];
    NSInteger index = [_contentArr indexOfObject:_type];
    [_dropdownListView setSelectedIndex:index];
    _dropdownListView.layer.masksToBounds = YES;
    [_dropdownListView setViewBorder:1 borderColor:[UIColor whiteColor] cornerRadius:2];
    [_dropdownListView setTextColor:[UIColor blackColor]];
    __weak FarctoryListController *safeSelf = self;

    [_dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        safeSelf.type = dropdownListView.selectedItem.itemName;
        [safeSelf getData];
    }];
    
    [redView addSubview:_dropdownListView];
    
    UILabel* timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(GZDeviceWidth*0.6, 10, GZDeviceWidth*0.3, 30);
    timeLabel.text = @"按时间降序排列";
    timeLabel.textColor = [UIColor blueColor];
    timeLabel.tag = 1002;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
    timeLabel.userInteractionEnabled = YES;
    [timeLabel addGestureRecognizer:tap1];
    
    [redView addSubview:timeLabel];
    [self.view addSubview:redView];
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , redView.frame.origin.y+redView.bounds.size.height+10 , MainS_Width, MainS_Height-(redView.frame.origin.y+redView.bounds.size.height+10))];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCarCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier_SearchCarCell];
    //    //self.tableView.contentInset=UIEdgeInsetsMake(0.0, 0, 0, 0);//tableview scrollview的contentview的顶点相对于scrollview的位置
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [safeSelf refreshManagerList];
    }] ;
    //第一次进来可以刷新
    [self.tableView.mj_header beginRefreshing];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (NetworkIsStatusNotReachable) {     // 加载失败，网络原因
        NotNetworkTip;
        [self.view addSubview:self.abankView];
    }
    else{
        [self.view addSubview:self.tableView];
    }

    
    
}

#pragma 初始化数据
-(void)initData{
    
    
}

#pragma 初始化数据
-(void)getData{
    //查找本地数据
    NSMutableArray* array =[[DataBaseTool shareInstance] queryManagerList:@"" wxgz:@"" assgin:@"" orderStr:@"" states:_type];
    if(array.count!=0){
        //有值
        self.dataSource = array;
        [self showView];
    }else{
        [self.dataSource removeAllObjects];
        [self refreshManagerList];
    }
}

-(void)getCarList:(NSString*)pre_row_number chooseName:(NSString*)states{
    __weak FarctoryListController *safeSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repair_state";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"pre_row_number"] = pre_row_number;
    dict[@"states"] = states;

    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        [safeSelf.tableView.mj_header endRefreshing];
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSArray *items = [responseObject objectForKey:@"data"];
            //            NSMutableArray *tmpArray = [NSMutableArray array];
            
            for (NSDictionary *dic in items) {
                ManageInfoModel *model = [ManageInfoModel mj_objectWithKeyValues:dic];
                //                [tmpArray addObject:model];
                [safeSelf.dataSource addObject:model];
            }
            NSString* tmpRowNumber = [responseObject objectForKey:@"pre_row_number"];
            if([tmpRowNumber isEqualToString:@"end"]){
                //刷新数据
                //添加本地数据
                [[DataBaseTool shareInstance] insertManagerListData:safeSelf.dataSource states:states];//只有最后一次把所有数据添加到里面
                
                //移除空白view
                [safeSelf showView];
            }else{
                //继续
                [safeSelf getCarList:pre_row_number chooseName:states];
            }
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            [safeSelf showErrorInfo:msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [self showErrorInfo:@"网络错误"];
    }];
}

#pragma 刷新列表数据
-(void)refreshManagerList{
    _progress = [ToolsObject showLoading:@"加载中" with:self];
    //重置
    //清空数据
    [self.dataSource removeAllObjects];//清空数据不会刷新 没有reload
    [self getCarList:@"0" chooseName:_type];
}

#pragma 显示view
-(void)showView{
    
    if (self.abankView.superview) {
        [self.abankView removeFromSuperview];
    }
    [self.progress hideAnimated:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    
}

#pragma 显示空白view
-(void)showErrorInfo:(NSString*)error{
    self.abankView.titleLabel.text = error;
    [self.progress hideAnimated:YES];

    [self.view addSubview:self.abankView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 搜索车辆
-(void)searchByCp:(UITapGestureRecognizer *)tap{
    UITextField* textField = [self.view viewWithTag:1100];
    if([textField.text isEqualToString:@""]){
        [ToolsObject show:@"请输入车牌号" With:self];
    }else{
      
    }
}

#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FactoryListCell* cell = [FactoryListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190*PXSCALEH;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    CarInfoModel* model = self.dataSource[indexPath.row];
    //    if(self.block){
    //        self.block(model);
    //        [self.navigationController popViewControllerAnimated:YES];
    
    //    }
    ManageInfoModel* model = self.dataSource[indexPath.row];
//    ManageInfo info = mInfoList.get(i);
//    sp.putString(Constance.JSD_ID,info.getJsd_id());
//    sp.putString(Constance.CHEJIAHAO,info.getCjhm());
//    sp.putString(Constance.CURRENTCP,info.getCp());
//    sp.putString(Constance.CHEXING,info.getCx());
//    sp.putString(Constance.JIECHEDATE,info.getJc_date());
//    sp.putString(Constance.YUWANGONG,info.getYwg_date());
    NSMutableArray* items =  [[DataBaseTool shareInstance] queryCarListData:model.cp isLike:NO];
    CarInfoModel* item = [items objectAtIndex:0];
    if(item==nil){
        item = [[CarInfoModel alloc] init];
        item.cjhm = model.cjhm;
        item.mc = model.cp;
        item.cx  = model.cx;
    }
    item.jsd_id = model.jsd_id;

    [self enterWorkOrder:item];
    
}

-(void)enterWorkOrder:(CarInfoModel*)model{
    
    BOOL isHave = NO;
    for(UIViewController*temp in self.navigationController.viewControllers) {
        if([temp isKindOfClass:[ProjectOrderViewController class]]){
            isHave = YES;
            ProjectOrderViewController* vc  = (ProjectOrderViewController*)temp;
            vc.model = model;
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    if(!isHave){
        ProjectOrderViewController* vc = [[ProjectOrderViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - Getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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

#pragma mark - 搜索
-(void)searchContent:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag) {
        case 1001:
            _cp = ((UILabel*)[self.view viewWithTag:1000]).text;
            break;
        case 1002:
            ((UILabel*)[self.view viewWithTag:1002]).text = [((UILabel*)[self.view viewWithTag:1002]).text isEqualToString:@"按时间降序排序"]?@"按时间升序排序":@"按时间降序排序";
            _orderStr = _orderStr==nil||[_orderStr isEqualToString:@"jc_date desc"] ? @"jc_date asc" :@"jc_date desc";
            
            break;
        default:
            break;
    }
    [self queryLocalData];
}

#pragma //查询本地数据
-(void)queryLocalData{
    NSMutableArray* array =[[DataBaseTool shareInstance] queryManagerList:_cp wxgz:@"" assgin:@"" orderStr:_orderStr states:_type];
    self.dataSource = array;
    if(self.dataSource.count==0){
        [self showErrorInfo:@"暂无数据"];
    }else{
        [self showView];
    }
}

@end
