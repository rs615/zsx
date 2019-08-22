//
//  GuzhangListViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "GuzhangListViewController.h"
#import "GuzhangInfoModel.h"
#import "HNAlertView.h"

typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface GuzhangListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) GuzhangInfoModel * tempGuzhang;

@end

@implementation GuzhangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"故障记录" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,NavBarHeight , MainS_Width, MainS_Height-NavBarHeight)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 90*PXSCALEH)];
    UIButton* addBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(footView.bounds.size.width/2-40/2, (90*PXSCALEH-40)/2, 40, 40) imageName:@"add_gz" title:nil clickAction:@selector(add:)];
    [footView addSubview:addBtn];
    self.tableView.tableFooterView = footView;
    
}

-(void)add:(UIButton*)btn{
    _tempGuzhang = [[GuzhangInfoModel alloc] init];
    __weak GuzhangListViewController* safeSelf = self;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,50,MainS_Width-40*PXSCALE,240*PXSCALEH)];
    NSDate* curDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:curDate];
    _tempGuzhang.days = dateStr;
    UILabel* enterDateLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, 20*PXSCALEH, contentView.bounds.size.width-20*PXSCALE, 30*PXSCALEH) text:dateStr size:14 align:@"left"];
    UILabel* gzmsLabel = [PublicFunction getlabel:CGRectMake(10*PXSCALE, enterDateLabel.frame.origin.y+enterDateLabel.bounds.size.height+10*PXSCALEH, contentView.bounds.size.width-20*PXSCALE, 30*PXSCALEH) text:@"故障描述:" size:14 align:@"left"];
    UITextView* gzmsTextView = [PublicFunction getTextView:CGRectMake(10*PXSCALE, gzmsLabel.frame.origin.y+gzmsLabel.bounds.size.height, contentView.bounds.size.width-20*PXSCALE, 90*PXSCALEH) text:@"" size:14];
    gzmsTextView.editable = YES;
    gzmsTextView.delegate = self;
    gzmsTextView.backgroundColor = lightGrayColor;
    [contentView addSubview:enterDateLabel];
    [contentView addSubview:gzmsLabel];
    [contentView addSubview:gzmsTextView];
    HNAlertView *alertView =  [[HNAlertView alloc] initWithCancleTitle:@"取消" withSurceBtnTitle:@"确定" WithMsg:nil withTitle:@"新增故障" contentView: contentView];
    UIButton* button = [alertView viewWithTag:1];
    button.userInteractionEnabled = NO;
    button.alpha = 0.4;
    [alertView showHNAlertView:^(NSInteger index) {
        if(index == 1){
            safeSelf.progress = [ToolsObject showLoading:@"加载中" with:self];

            [safeSelf insertGuzhangData:^(NSString *errorMsg, id result) {
                [safeSelf.progress hideAnimated:YES];
                if(![errorMsg isEqualToString:@""]){
                    [ToolsObject show:errorMsg With:safeSelf];
                }else{
                    if(safeSelf.dataSource.count>0){
                        GuzhangInfoModel* lastObj = [safeSelf.dataSource lastObject];
                        if(![lastObj.days isEqualToString:@""]&&lastObj.days.length>10){
                            lastObj.days = [lastObj.days substringToIndex:10];
                        }
                        if([lastObj.days isEqualToString:safeSelf.tempGuzhang.days]){
                            [safeSelf.dataSource replaceObjectAtIndex:safeSelf.dataSource.count-1 withObject:safeSelf.tempGuzhang];
                            [safeSelf.tableView reloadData];
                            return;
                        }
                    }
                    [safeSelf.dataSource addObject:safeSelf.tempGuzhang];
                    [safeSelf.tableView reloadData];
                }
            }];
        }else{
        }
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    _tempGuzhang.fault_info = textView.text;
    HNAlertView* alertView = (HNAlertView*)[[textView superview] superview];
    UIButton* btn = [alertView viewWithTag:1];
    if([_tempGuzhang.fault_info isEqualToString:@""]){
        btn.userInteractionEnabled = NO;
        btn.alpha = 0.4;
    }else{
        btn.userInteractionEnabled = YES;
        btn.alpha = 1;
    }

}



#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = lightGrayColor;
    UILabel* enterDateLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, 10*PXSCALE, MainS_Width-40*PXSCALE, 30*PXSCALEH) text:@"" size:14 align:@"left"];
    enterDateLabel.backgroundColor = [UIColor clearColor];
    UILabel* gzmsLabel = [PublicFunction getlabel:CGRectMake(20*PXSCALE, enterDateLabel.frame.origin.y+enterDateLabel.bounds.size.height+10*PXSCALEH, MainS_Width-40*PXSCALE, 30*PXSCALEH) text:@"" size:14 align:@"left"];
    gzmsLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:enterDateLabel];
    [cell.contentView addSubview:gzmsLabel];
    GuzhangInfoModel* model = self.dataSource[indexPath.row];
    if(model!=nil){
        if(model.days!=nil&&![model.days isEqualToString:@""]){
            if(model.days.length>10){
                model.days = [model.days substringToIndex:10];
            }
        }
        enterDateLabel.text = [NSString stringWithFormat:@"进厂时间: %@",model.days];
        gzmsLabel.text = [NSString stringWithFormat:@"故障描述: %@",model.fault_info];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90*PXSCALEH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}



-(void)initData{
    __weak GuzhangListViewController* safeSelf = self;
    [self getCuzhangList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With:safeSelf];
        }else{
            safeSelf.dataSource = result;
            [safeSelf.tableView reloadData];
        }
    }];
}

#pragma 获取故障列表
-(void)getCuzhangList:(asyncCallback)callback{
    __weak GuzhangListViewController* safeSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_get_fault_info";//车间管理
    dict[@"customer_id"] = _model.customer_id;// 传过来
    dict[@"days"] = @"1901-01-01 0:00:00";
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        [safeSelf.progress hideAnimated:YES];
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [GuzhangInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            callback(@"",array);
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 新增故障
-(void)insertGuzhangData:(asyncCallback)callback{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_update_fault_info";//车间管理
    dict[@"customer_id"] = _model.customer_id;// 传过来
    NSString* days = _tempGuzhang.days;
    if(_tempGuzhang.days.length<=10){
        days = [NSString stringWithFormat:@"%@ 00:00:00",_tempGuzhang.days];
    }
    dict[@"days"] = days;
    dict[@"car_fault"] = _tempGuzhang.fault_info;
    
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



@end
