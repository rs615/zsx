//
//  SearchCarViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

/*
 搜索车辆
 */
#import "SearchCarViewController.h"
@interface SearchCarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)HNBankView *abankView;//缺省页

@end

@implementation SearchCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"搜索车辆" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , NavBarHeight , MainS_Width, MainS_Height-NavBarHeight)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCarCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier_SearchCarCell];
//    //self.tableView.contentInset=UIEdgeInsetsMake(0.0, 0, 0, 0);//tableview scrollview的contentview的顶点相对于scrollview的位置
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (NetworkIsStatusNotReachable) {     // 加载失败，网络原因
        NotNetworkTip;
        [self.view addSubview:self.abankView];
    }
    else{
        [self.view addSubview:self.tableView];
    }
    int count = [[DataBaseTool shareInstance] querySearchListNum];

    if(count==0){
        [self loadCarList:@"0"];
    }else{
        [self refreshData];
    }
}

//刷新数据
-(void)refreshData{
    self.dataSource = [[DataBaseTool shareInstance] querySearchCarListData:self.searchName];
    if(self.dataSource.count==0){
        [self.view addSubview:self.abankView];
    }
    [self.tableView reloadData];
    
}

//加载数据
-(void)loadCarList:(NSString*)previous_xh{
    __weak SearchCarViewController *safeSelf = self;
    
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
            [safeSelf refreshData];

        }
    } failure:^(NSError * _Nonnull error) {
        
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

#pragma mark - 属性
-(HNBankView *)abankView
{
    if(!_abankView){
        _abankView = [[HNBankView alloc]initWithBankViewFrame:CGRectMake(0, NavBarHeight, MainS_Width, MainS_Height-NavBarHeight) withImage:@"rijibenweikong" withMessgess:@"暂无数据"];
                [_abankView.agreenBut removeFromSuperview];
//        [_abankView.agreenBut addTarget:self action:@selector(loadCarList:) forControlEvents:UIControlEventTouchUpInside];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCarCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SearchCarCell];
    if (!cell) {
        cell = [[SearchCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_SearchCarCell];
    }
    
    cell.model = self.dataSource[indexPath.row];
    //    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130*PXSCALEH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarInfoModel* model = self.dataSource[indexPath.row];
    if(self.block){
        self.block(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}



@end
