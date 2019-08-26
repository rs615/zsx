//
//  HistoryDataList.m
//  TestAppDemo
//
//  Created by 涂程 on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HistoryDataListController.h"
#import "EBDropdownListView.h"
#import "OrderModel.h"
#import "BRPickerView.h"
#import "HistoryListCell.h"
#import "ManageModel.h"

@interface HistoryDataListController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allDataSource;
@property (nonatomic, strong) NSMutableArray *dropDownListArr;
@property (nonatomic, strong)EBDropdownListView *dropdownListView;//下拉列表
@property (nonatomic,strong)HNBankView *abankView;//缺省页
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSString *wxgz;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIDatePicker* datePicker;


@end

@implementation HistoryDataListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"历史记录" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"home_icon" rightAction:@selector(backHome) withVC:self];
    [self initView];
    [self initData];
}



-(void)initView {
    __weak HistoryDataListController *safeSelf = self;
    _dropdownListView = [[EBDropdownListView alloc] initWithFrame:CGRectMake(20, 10*PXSCALEH+NavBarHeight+8, 80, 30)];
    EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:@"-1" itemName:@"全部"];
    [self.dropDownListArr addObject:item];
    
    _dropdownListView.layer.cornerRadius = 6;
    _dropdownListView.layer.borderWidth = 1;
    _dropdownListView.layer.masksToBounds = YES;
    [_dropdownListView setViewBorder:0.5 borderColor:SetColor(@"#F1A2B4", 1) cornerRadius:2];
    [_dropdownListView setDataSource:self.dropDownListArr];
    [_dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        safeSelf.wxgz = dropdownListView.selectedItem.itemName;
        [safeSelf queryLocalData];
    }];
    [self.view addSubview:_dropdownListView];
    
    
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString* startDateStr = [NSString stringWithFormat:@"%@01",[dateStr substringToIndex:dateStr.length-2]];
    _startDateLabel = [PublicFunction getlabel:CGRectMake(_dropdownListView.frame.origin.x+_dropdownListView.frame.size.width+5, 10*PXSCALEH+NavBarHeight, (MainS_Width-160*PXSCALE)/2, 40*PXSCALEH) text:@"2017-01-01" fontSize:15 color:SetColor(@"#111111", 1.0) align:@"center"];
    _startDateLabel.backgroundColor = SetColor(@"#E6E4E7", 1);
    _startDateLabel.tag = 1000;
    _endDateLabel = [PublicFunction getlabel:CGRectMake(MainS_Width-70*PXSCALEH-_startDateLabel.bounds.size.width+5, _startDateLabel.frame.origin.y, (MainS_Width-160*PXSCALE)/2, 40*PXSCALEH) text:dateStr fontSize:15 color:SetColor(@"#111111", 1.0) align:@"center"];
    _endDateLabel.backgroundColor = SetColor(@"#E6E4E7", 1);
    _endDateLabel.tag = 1001;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    _startDateLabel.userInteractionEnabled = YES;
    [_startDateLabel addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    _endDateLabel.userInteractionEnabled = YES;
    [_endDateLabel addGestureRecognizer:tap2];
    UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(_startDateLabel.frame.origin.x+_startDateLabel.bounds.size.width-10, _startDateLabel.frame.origin.y, 20*PXSCALE, 40*PXSCALEH) text:@"至" fontSize:navTitleFont color:SetColor(@"#111111", 1.0) align:@"center"];
    titleLabel.backgroundColor = SetColor(@"#FFFFFF", 1);
    [self.view addSubview:_endDateLabel];
    [self.view addSubview:_startDateLabel];
    [self.view addSubview:titleLabel];
    
    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
        UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
        imageView2.frame = CGRectMake(MainS_Width-20-50, _startDateLabel.frame.origin.y,40, 40);
        imageView2.layer.cornerRadius = 6;
        imageView2.layer.masksToBounds = YES;
        //添加搜索事件
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
        imageView2.userInteractionEnabled = YES;
        [imageView2 addGestureRecognizer:tap0];
        //自适应图片宽高比例
        //    imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView2];
    
    
    
    
    
    
//
//    UIImage* image2 = [UIImage imageNamed:@"red_white_search"];
//    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
//    imageView2.frame = CGRectMake(MainS_Width-20-50, _endDateLabel.frame.origin.y+_endDateLabel.frame.size.height+10, 50, 30);
//    imageView2.layer.cornerRadius = 6;
//    imageView2.layer.masksToBounds = YES;
//    //添加搜索事件
//    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
//    imageView2.userInteractionEnabled = YES;
//    [imageView2 addGestureRecognizer:tap0];
//    //自适应图片宽高比例
//    //    imageView2.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imageView2];
//
//    //添加搜索框
//    UITextField * textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(_dropdownListView.frame.origin.x+_dropdownListView.frame.size.width+10, _endDateLabel.frame.origin.y+_endDateLabel.frame.size.height+10,imageView2.frame.origin.x-20-100, 30)];
//    textFieldSearch.placeholder = @" 输入";
//    textFieldSearch.layer.borderWidth = 1;
//    textFieldSearch.layer.masksToBounds = YES;
//    textFieldSearch.layer.cornerRadius = 6;
//    [textFieldSearch addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
//
//    textFieldSearch.tag = 1100;
//    textFieldSearch.layer.borderColor = SetColor(@"#F1A2B4", 1).CGColor;
//    [self.view addSubview:textFieldSearch];
    
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, _dropdownListView.frame.origin.y+_dropdownListView.bounds.size.height+10*PXSCALEH , MainS_Width, 40*PXSCALEH)];
//    UILabel* gdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
//    UILabel* enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
//    UILabel* cpLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5*2,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
//    UILabel* wxgzLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5*3,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
//    UILabel* moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainS_Width/5*4,5*PXSCALEH, MainS_Width/5, 40*PXSCALEH)];
//    gdhLabel.textAlignment = NSTextAlignmentCenter;
//    enterDateLabel.textAlignment = NSTextAlignmentCenter;
//    cpLabel.textAlignment = NSTextAlignmentCenter;
//    wxgzLabel.textAlignment = NSTextAlignmentCenter;
//    moneyLabel.textAlignment = NSTextAlignmentCenter;
//    gdhLabel.text = @"工单号";
//    enterDateLabel.text = @"进厂日期";
//    cpLabel.text = @"车牌";
//    wxgzLabel.text = @"工种";
//    moneyLabel.text = @"金额";
//    [view addSubview:gdhLabel];
//    [view addSubview:enterDateLabel];
//    [view addSubview:cpLabel];
//    [view addSubview:wxgzLabel];
//    [view addSubview:moneyLabel];
//    [self.view addSubview:view];
    
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , _dropdownListView.frame.origin.y+_dropdownListView.bounds.size.height+10*PXSCALEH  , MainS_Width, MainS_Height-(_dropdownListView.frame.origin.y+_dropdownListView.bounds.size.height+10+50*PXSCALEH))];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCarCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier_SearchCarCell];
    //    //self.tableView.contentInset=UIEdgeInsetsMake(0.0, 0, 0, 0);//tableview scrollview的contentview的顶点相对于scrollview的位置
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        
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
        [safeSelf.view addSubview:self.tableView];
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryListCell* cell = [HistoryListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*PXSCALEH*2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    return view;
//}

#pragma 查询本地数据
-(void)queryLocalData{
    NSMutableArray* tmpArr = [NSMutableArray array];
    for(ManageModel* model in self.allDataSource){
        BOOL isSave = false;
        
        if([_content isEqualToString:@""]){
            if([_wxgz isEqualToString:@"全部"]||([model.wxgz rangeOfString:_wxgz options:NSCaseInsensitiveSearch].length>0&&model.wxgz!=NULL)){
                isSave = YES;
            }
        }else{
            if([_wxgz isEqualToString:@"全部"]){
                if([model.cp rangeOfString:_content options:NSCaseInsensitiveSearch].length>0&&model.cp!=NULL){
                    isSave = YES;
                }
            }else{
                if([model.cp rangeOfString:_content options:NSCaseInsensitiveSearch].length>0&&model.cp!=NULL&&[model.wxgz rangeOfString:_wxgz options:NSCaseInsensitiveSearch].length>0&&model.wxgz!=NULL){
                    isSave = YES;
                    
                }
            }
        }
        if(isSave){
            [tmpArr addObject:model];
        }
    }
    self.dataSource = tmpArr;
    [self updateView];
}
-(void)updateView{
    if (self.dataSource.count>0)
    {
        [self.abankView removeFromSuperview];
    }
    else{
        [self.view addSubview:self.abankView];
    }
    [self.tableView reloadData];
}

-(void)initData{
    _wxgz = @"全部";
    _content = @"";
    _arr = [[NSArray alloc]initWithObjects:@"待领工",@"修理中",@"待质检",@"已完工", nil];
    //此处这样获取工种肯定有问题 不能直接从数据库拿。可能没有数据
    //获取工种
    NSMutableArray* wxgzArr = [[DataBaseTool shareInstance] queryWxgzList:@""];
    for (int i=0; i<wxgzArr.count; i++) {
        EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:[NSString stringWithFormat:@"%d",i] itemName:wxgzArr[i]];
        [self.dropDownListArr addObject:item];
    }
    [_dropdownListView setDataSource:self.dropDownListArr];
}


/**
 dataMap.put("db", sp.getString(Constance.Data_Source_name));
 dataMap.put("function", "sp_fun_down_repair_history");
 dataMap.put("customer_id", sp.getString(Constance.CUSTOMER_ID));
 dataMap.put("dates", startDateStr);
 dataMap.put("datee", endDateStr);
 
 
 */

#pragma 加载数据
-(void)loadData{
    __weak HistoryDataListController *safeSelf = self;
     NSMutableArray* tmpArr = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_repair_history";//车间管理
    dict[@"customer_id"] =  _model.customer_id;;
    dict[@"dates"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDateLabel.text];
    dict[@"datee"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDateLabel.text];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        [safeSelf.tableView.mj_header endRefreshing];
         NSMutableArray *dataArr = [NSMutableArray array];
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSArray *items = [responseObject objectForKey:@"data"];
           
            for (NSDictionary *dic in items) {
                ManageModel *model = [ManageModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }
            
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            [safeSelf showErrorInfo:msg];
        }
        
        safeSelf.allDataSource = dataArr;
        safeSelf.dataSource = dataArr;
        [safeSelf updateView];
        
    } failure:^(NSError * _Nonnull error) {
        [self showErrorInfo:@"网络错误"];
    }];
}




//#pragma mark - 属性
//
//- (UIDatePicker *)datePicker {
//    if (!_datePicker) {
//        _datePicker = [[UIDatePicker alloc]init];
//        _datePicker.frame = CGRectMake(0, MAXHEIGHT, MAXWIDTH, 50*3*PXSCALEH);
//        _datePicker.backgroundColor = [UIColor whiteColor];
//        _datePicker.datePickerMode = UIDatePickerModeDate;
//        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//        //        _datePicker.maximumDate = [NSDate date];
//        //        if (_minDate)
//        //        {
//        //            _datePicker.minimumDate = _minDate;
//        //        }
//
//    }
//    return _datePicker;
//}

//#pragma mark------弹出日期选择器
//- (void) showDatePicker {
//
//    if (self.datePicker.frame.origin.y<MainS_Height)
//    {
//        return;
//    }
//    if (!self.datePicker.superview)
//    {
//        [self.view addSubview:self.datePicker];
//    }
//
//    [UIView animateWithDuration:0.25 animations:^{
//        self.datePicker.frame  =CGRectMake(0, MAXHEIGHT-60*3*PXSCALEH, MAXWIDTH, 60*3*PXSCALEH);
//    }];
//}

#pragma mark - 搜索
-(void)searchContent:(UITapGestureRecognizer *)tap{
    UITextField* textField = [self.view viewWithTag:1100];
    _content = textField.text;
    [self loadData];
}

-(void)selectDate:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    __weak HistoryDataListController *safeSelf = self;
    
    if(tag==1000){
        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:BRDatePickerModeYMD defaultSelValue:_startDateLabel.text minDate:nil maxDate:[ToolsObject stringToDate:_endDateLabel.text] isAutoSelect:NO themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            safeSelf.startDateLabel.text = selectValue;
            //[safeSelf queryLocalData];
        }];
        
    }else if(tag==1001){
        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:BRDatePickerModeYMD defaultSelValue:_endDateLabel.text minDate:[ToolsObject stringToDate:_startDateLabel.text] maxDate:nil isAutoSelect:NO themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            safeSelf.endDateLabel.text = selectValue;
            //[safeSelf queryLocalData];
        }];
    }
    
    
}

#pragma 显示空白view
-(void)showErrorInfo:(NSString*)error{
    self.abankView.titleLabel.text = error;
    [self.view addSubview:self.abankView];
}

#pragma mark -监听输入值变化
-(void)changedTextField:(id)textField
{
    _content = ((UITextField*)textField).text;
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
- (NSMutableArray *)allDataSource
{
    if (!_allDataSource) {
        _allDataSource = [NSMutableArray array];
    }
    return _allDataSource;
}

#pragma mark - Getters
- (NSMutableArray *)dropDownListArr
{
    if (!_dropDownListArr) {
        _dropDownListArr = [NSMutableArray array];
    }
    return _dropDownListArr;
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
