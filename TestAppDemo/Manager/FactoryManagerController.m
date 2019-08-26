//
//  FactoryManagerController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/5.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "FactoryManagerController.h"
#import "EBDropdownListView.h"
#import "ManageInfoModel.h"
#import "FactoryManagerCell.h"
@interface FactoryManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dropDownListArr;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic,strong)HNBankView *abankView;//缺省页
@property (nonatomic, strong)NSString* wxgz;
@property (nonatomic, strong)NSString* cp;
@property (nonatomic, strong)NSString* assign;
@property (nonatomic, strong)NSString* orderByEnterFactory;
@property (nonatomic, strong)NSString* orderByJiaoChe;
@property (nonatomic, strong)NSString* orderStr;
@property (nonatomic, assign) NSInteger  curSelectIndex;
@property (nonatomic, strong)EBDropdownListView *dropdownListView;//下拉列表
@end

typedef void (^asyncCallback)(NSString* errorMsg,id result);

@implementation FactoryManagerController


-(void) viewWillAppear:(BOOL)animated
{
  self.navigationItem.title = @"车间管理";
}

-(void) initView
{
    __weak FactoryManagerController *safeSelf = self;

    //先创建一个数组用于设置标题
    _arr = [[NSArray alloc]initWithObjects:@"待领工",@"修理中",@"待质检",@"已完工", nil];
    //初始化UISegmentedControl
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:_arr];
    //设置frame
    segment.frame = CGRectMake(0, 65, self.view.frame.size.width, 40);
    segment.backgroundColor = [UIColor grayColor];
    //去掉中间的分割线
   
 
//    [segment setDividerImage:_dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
    segment.backgroundColor = [UIColor grayColor];
    segment.layer.masksToBounds = NO;               //    默认为no，不设置则下面一句无效
    segment.layer.cornerRadius = 0;               //    设置圆角大小，同UIView
    segment.layer.borderWidth = 0;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    segment.layer.borderColor = [UIColor clearColor].CGColor;
    //segment.frame = CGRectMake(0, 0.15029*CFG, 0.2716*CFW, 0.0814*CFG); // 0.3642*CFW
    segment.selectedSegmentIndex = 0;
    //    segment.tintColor = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    //    选中的颜色
    
    [segment setTintColor:hotPinkColor];
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    //    未选中的颜色
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //添加到主视图
    //当选中不同的segment时,会触发不同的点击事件
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];

    
    //添加到主视图
    [self.view addSubview:segment];
    

    //下拉列表
    [self resetDropDownList];
    _dropdownListView = [[EBDropdownListView alloc] initWithFrame:CGRectMake(20, segment.frame.origin.y+segment.frame.size.height+10, 80, 30)];
    _dropdownListView.layer.cornerRadius = 6;
    _dropdownListView.layer.borderWidth = 1;
    _dropdownListView.layer.masksToBounds = YES;
    [_dropdownListView setViewBorder:0.5 borderColor:SetColor(@"#F1A2B4", 1) cornerRadius:2];
    [_dropdownListView setDataSource:self.dropDownListArr];
    [_dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        safeSelf.wxgz = dropdownListView.selectedItem.itemName;
        //排序
        [safeSelf getData];
    }];
    [self.view addSubview:_dropdownListView];
   

    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(MainS_Width-20-50, segment.frame.origin.y+segment.frame.size.height+10, 30, 30);
    imageView2.layer.cornerRadius = 6;
    imageView2.layer.masksToBounds = YES;
    //添加搜索事件
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchByCp:)];
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:tap0];
    //自适应图片宽高比例
//    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];
    
    //添加搜索框
    UITextField * textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(_dropdownListView.frame.origin.x+_dropdownListView.frame.size.width+10, segment.frame.origin.y+segment.frame.size.height+10,imageView2.frame.origin.x-20-100, 30)];
    textFieldSearch.placeholder = @" 输入";
    textFieldSearch.layer.borderWidth = 1;
    textFieldSearch.layer.masksToBounds = YES;
    textFieldSearch.layer.cornerRadius = 6;
    [textFieldSearch addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

    textFieldSearch.tag = 1100;
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
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , myTaskView.frame.origin.y+myTaskView.bounds.size.height+10 , MainS_Width, MainS_Height-(myTaskView.frame.origin.y+myTaskView.bounds.size.height+10+NavBarHeight))];
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
-(void) viewDidLoad
{
    [self initView];
    _curSelectIndex = 0;
    _wxgz = @"";
    _assign = @"";
    _cp = @"";
    _orderByJiaoChe = @"ywg_date desc";
    _orderByEnterFactory = @"jc_date asc";
    _orderStr = [NSString stringWithFormat:@"%@,%@",_orderByJiaoChe,_orderByEnterFactory];

}

#pragma 选择ga排序
-(void)selectOrder:(NSInteger)tag{
    if(tag==100||tag==1000){
        //进厂
        UIButton* btn = [self.view viewWithTag:1000];
        btn.selected = !btn.selected;
        _orderByEnterFactory = btn.selected?@"jc_date asc":@"jc_date desc";
    }else if(tag==101||tag==1001){
        //交车
        UIButton* btn = [self.view viewWithTag:1001];
        btn.selected = !btn.selected;
        _orderByJiaoChe = btn.selected?@"ywg_date asc":@"ywg_date desc";
    }else if(tag==102||tag==1002){
        //交车
        UIButton* btn = [self.view viewWithTag:1002];
        btn.selected = !btn.selected;
        _assign = btn.selected?@"管理员":@"";//操作编码
    }
    _orderStr = [NSString stringWithFormat:@"%@,%@",_orderByEnterFactory,_orderByJiaoChe];
    
    [self queryLocalData];
}

#pragma mark -排序
-(void)orderBy:(UITapGestureRecognizer *)tap{
    NSInteger tag =  tap.view.tag;
    [self selectOrder:tag];
  
}

-(void)resetDropDownList{
    [self.dropDownListArr removeAllObjects];
    EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:@"-1" itemName:@"全部"];
    [self.dropDownListArr addObject:item];
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


-(void)sendAction:(UIButton *)sender{
    [self selectOrder:sender.tag];
}



#pragma 初始化数据
-(void)getData{
    //查找本地数据
    NSMutableArray* array =[[DataBaseTool shareInstance] queryManagerList:@"" wxgz:@"" assgin:@"" orderStr:_orderStr states:[_arr objectAtIndex:self.curSelectIndex]];
    [self resetDropDownList];//重置下拉列表
    if(array.count!=0){
        //有值
        self.dataSource = array;
        [self showView];
    }else{
        [self.dataSource removeAllObjects];
        [self refreshManagerList];
    }
}

#pragma mark -监听输入值变化
-(void)changedTextField:(id)textField
{
    _cp = ((UITextField*)textField).text;
}

#pragma //查询本地数据
-(void)queryLocalData{
    NSMutableArray* array =[[DataBaseTool shareInstance] queryManagerList:_cp wxgz:_wxgz assgin:_assign orderStr:_orderStr states:[_arr objectAtIndex:self.curSelectIndex]];
    self.dataSource = array;
    if(self.dataSource.count==0){
        [self showErrorInfo:@"暂无数据"];
    }else{
        [self showView];
    }
}

#pragma 刷新列表数据
-(void)refreshManagerList{
     _progress = [ToolsObject showLoading:@"加载中" with:self];
    //重置
    //清空数据
    [self.dataSource removeAllObjects];//清空数据不会刷新 没有reload
    [_dropdownListView setSelectedIndex:0];
    [self resetDropDownList];
    [self getListData:self.curSelectIndex preRowNumber:@"0"];
}

#pragma mark -segment选择

-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    //查找本地数据
    self.curSelectIndex = control.selectedSegmentIndex;
    [self getData];

}



#pragma mark -获取对应选择索引的数据
-(void)getListData:(NSInteger)index preRowNumber:(NSString*)pre_row_number{
    __weak FactoryManagerController *safeSelf = self;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repair_project_state";//车间管理
    dict[@"company_code"] = @"A";
    dict[@"pre_row_number"] = pre_row_number;
    dict[@"states"] = [_arr objectAtIndex:index];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
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
                [[DataBaseTool shareInstance] insertManagerListData:safeSelf.dataSource states:[safeSelf.arr objectAtIndex:index]];//只有最后一次把所有数据添加到里面
                
                //移除空白view
                [safeSelf showView];
            }else{
                //继续
                [safeSelf getListData:index preRowNumber:tmpRowNumber];
            }
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            [self showErrorInfo:msg];
        }
    } failure:^(NSError * _Nonnull error) {
        [self showErrorInfo:@"网络错误"];
    }];
}

#pragma 获取第一页的数据
-(void)getFirstIconList:(asyncCallback)callback{
    NSMutableArray* array = [[DataBaseTool shareInstance] queryFirstIconListData];
    if(array.count!=0){
        callback(@"",array);
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"db"] = [ToolsObject getDataSouceName];
        dict[@"function"] = @"sp_fun_down_maintenance_category";//车间管理
        [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
            
            if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
                NSMutableArray *items = [responseObject objectForKey:@"data"];
                NSMutableArray* array = [FirstIconInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
                [[DataBaseTool shareInstance] insertFirstIconListData:array];
                callback(@"",array);
                
            }else{
                NSString* msg = [responseObject objectForKey:@"msg"];
                callback(msg,nil);
            }
        } failure:^(NSError * _Nonnull error) {
            callback(@"网络错误",nil);
        }];
    }
    
}

#pragma 显示空白view
-(void)showErrorInfo:(NSString*)error{
    [self.progress hideAnimated:YES];
//    [ToolsObject show:error With:self];
//    [self.tableView removeFromSuperview];
    self.abankView.titleLabel.text = error;
    [self.tableView.mj_header endRefreshing];
    [_dropdownListView setDataSource:self.dropDownListArr];

    [self.view addSubview:self.abankView];
}

#pragma 显示view
-(void)showView{

    if (self.abankView.superview) {
        [self.abankView removeFromSuperview];
    }
    [self.progress hideAnimated:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    //刷新下拉
    NSMutableArray* wxgzArr = [[DataBaseTool shareInstance] queryWxgzList:[_arr objectAtIndex:self.curSelectIndex]];
    
    if(wxgzArr.count==0){
        [self getFirstIconList:^(NSString *errorMsg, id result) {
            if(![errorMsg isEqualToString:@""]){
                [ToolsObject show:errorMsg With:self];
            }
        }];
    }
    for (int i=0; i<wxgzArr.count; i++) {
        EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:[NSString stringWithFormat:@"%d",i] itemName:wxgzArr[i]];
        [self.dropDownListArr addObject:item];
    }
    [_dropdownListView setDataSource:self.dropDownListArr];
  
}





#pragma mark - Getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Getters
- (NSMutableArray *)dropDownListArr
{
    if (!_dropDownListArr) {
        _dropDownListArr = [NSMutableArray array];
    }
    return _dropDownListArr;
}


#pragma mark - 搜索车辆
-(void)searchByCp:(UITapGestureRecognizer *)tap{
    UITextField* textField = [self.view viewWithTag:1100];
    if([textField.text isEqualToString:@""]){
       [ToolsObject show:@"请输入车牌号" With:self];
    }else{
        _cp = textField.text;
        [self queryLocalData];
    }
}

#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FactoryManagerCell* cell = [FactoryManagerCell cellWithTableView:tableView];
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
    
}


@end

