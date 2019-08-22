//
//  PeijianSelectActivity.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/17.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "PeijianSelectViewController.h"
#import "PartsCell.h"
#import "SelfPartsCell.h"
#import "TempPartsCell.h"
#import "SelfPartsModel.h"
#import "TempPartsModel.h"
#import "ProjectOrderViewController.h"
@interface PeijianSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView* kcPeiJianView;
@property (nonatomic, strong) UIView* tmpPeiJianView;
@property (nonatomic, strong) UIView* zdPeiJianView;
@property (nonatomic, strong) UISegmentedControl* segment;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic,strong)HNBankView *abankView;//缺省页
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selfPeijianArray;
@property (nonatomic, strong) NSMutableArray *tempPeijianArray;
@property (nonatomic, strong) NSMutableArray *kcPeijianArray;
@property(nonatomic,strong)NSMutableArray * tempIndexPathArray;//存indexPath

@property (nonatomic,strong)UIView *searchView;//缺省页
@property (nonatomic,assign)int postNum;//缺省页
@property (nonatomic,assign)int successNum;//缺省页
@property (nonatomic,strong)MBProgressHUD *progress;

@property (nonatomic,strong)NSString *queryStr;//缺省页

@end

@implementation PeijianSelectViewController



-(void) viewDidLoad
{
    [self initView];
    [self initData];
}

#pragma --------------------view

-(void)initView{
    [self setNavTitle:@"配件" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    [self initSegment];
    [self initContentView];
    [self initBottomView];
}

#pragma _segment
-(void)initSegment{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"库存配件",@"临时配件",@"自带配件", nil];
    _segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    _segment.frame = CGRectMake(10*PXSCALE, NavBarHeight, MainS_Width-20*PXSCALE, 40*PXSCALEH);
    _segment.backgroundColor = [UIColor grayColor];
    _segment.layer.masksToBounds = NO;               //    默认为no，不设置则下面一句无效
    _segment.layer.cornerRadius = 0;               //    设置圆角大小，同UIView
    _segment.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    //_segment.frame = CGRectMake(0, 0.15029*CFG, 0.2716*CFW, 0.0814*CFG); // 0.3642*CFW
    _segment.selectedSegmentIndex = 0;
    [_segment setTintColor:hotPinkColor];
    _segment.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    //    未选中的颜色
    [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    //当选中不同的_segment时,会触发不同的点击事件
    [_segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    //添加到主视图
    [self.view addSubview:_segment];

}

#pragma contentview
-(void)initContentView{
    self.kcPeiJianView = [[UIView alloc] initWithFrame:CGRectMake(0, _segment.frame.origin.y+_segment.bounds.size.height, MainS_Width, MainS_Height-40*PXSCALEH-NavBarHeight)];
    self.tmpPeiJianView = [[UIView alloc] initWithFrame:CGRectMake(0, _segment.frame.origin.y+_segment.bounds.size.height, MainS_Width, MainS_Height-40*PXSCALEH-NavBarHeight)];
    self.zdPeiJianView = [[UIView alloc] initWithFrame:CGRectMake(0, _segment.frame.origin.y+_segment.bounds.size.height, MainS_Width, MainS_Height-40*PXSCALEH-NavBarHeight)];
    [self.view addSubview:_kcPeiJianView];
    [self.view addSubview:_tmpPeiJianView];
    [self.view addSubview:_zdPeiJianView];
    _tmpPeiJianView.hidden = YES;
    _zdPeiJianView.hidden = YES;
    //加入搜索
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*PXSCALEH, MainS_Width, 40*PXSCALEH)];
     UITextField *peijianTextField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(60*PXSCALE, 0, MainS_Width-160*PXSCALE, 30*PXSCALEH) tag:800 returnType:@""];
    peijianTextField.tag = 1000;
    peijianTextField.placeholder = @"输入配件名";
    [peijianTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

    UIImageView* imgView = [PublicFunction getImageView:CGRectMake(peijianTextField.frame.origin.x+peijianTextField.bounds.size.width+10*PXSCALE, 0, 30, 30) imageName:@"red_white_search"];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap0];
    [_searchView addSubview:imgView];
    [_searchView addSubview:peijianTextField];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , _segment.frame.origin.y+_segment.bounds.size.height+10*PXSCALE , MainS_Width, MainS_Height-40*PXSCALEH-60*PXSCALEH-NavBarHeight-10*PXSCALEH)];
    self.tableView.tableHeaderView = _searchView;
//    self.tableView.backgroundColor = lightPinkColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor whiteColor];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    if (NetworkIsStatusNotReachable) {     // 加载失败，网络原因
//        NotNetworkTip;
//        [self.kcPeiJianView addSubview:self.abankView];
//    }
//    else{
//        [self.kcPeiJianView addSubview:self.tableView];
//    }
    SelfPartsModel* selfPartsModel = [[SelfPartsModel alloc] init];
    [self.selfPeijianArray addObject:selfPartsModel];
    [self.view addSubview:self.tableView];

    TempPartsModel* tempPartsModel = [[TempPartsModel alloc] init];
    [self.tempPeijianArray addObject:tempPartsModel];

}


#pragma 底部
-(void)initBottomView{
    UIView* kcPeijianBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.kcPeiJianView.bounds.size.height-60*PXSCALEH, MainS_Width, 60*PXSCALEH)];
//    kcPeijianBottomView.backgroundColor = [UIColor blueColor];
    CGFloat btnWidth = (kcPeijianBottomView.bounds.size.width-40*PXSCALE)/3;
    CGFloat btnHeight = 40*PXSCALEH;
    NSArray* kcPeijianMenArr = @[@"确定"];
    for(int i=0;i<kcPeijianMenArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(MainS_Width/2-btnWidth/2, 10*PXSCALEH, btnWidth, btnHeight) imageName:@"" title:[kcPeijianMenArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 120+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [kcPeijianBottomView addSubview:btn];
    }
    [self.kcPeiJianView addSubview:kcPeijianBottomView];
    UIView* tmpPeijianBottomView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/2-(2*btnWidth+10*PXSCALE)/2, self.kcPeiJianView.bounds.size.height-60*PXSCALEH, 2*btnWidth+10*PXSCALE, 60*PXSCALEH)];
    UIView* zidaiPeijianBottomView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/2-(2*btnWidth+10*PXSCALE)/2, self.kcPeiJianView.bounds.size.height-60*PXSCALEH, 2*btnWidth+10*PXSCALE, 60*PXSCALEH)];

    NSArray* peijianMenuArr = @[@"新增配件",@"确定"];
    for(int i=0;i<peijianMenuArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE),10*PXSCALEH, btnWidth, btnHeight) imageName:@"" title:[peijianMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 110+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpPeijianBottomView addSubview:btn];
    }
    NSArray* zidaiPeijianMenuArr = @[@"新增配件",@"确定"];

    for(int i=0;i<zidaiPeijianMenuArr.count;i++){
        UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE),10*PXSCALEH, btnWidth, btnHeight) imageName:@"" title:[peijianMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
        btn.backgroundColor = lightGreenColor;
        btn.tag = 130+i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zidaiPeijianBottomView addSubview:btn];
    }
    
    
    [self.tmpPeiJianView addSubview:tmpPeijianBottomView];
    [self.zdPeiJianView addSubview:zidaiPeijianBottomView];

}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(id)textField
{
    _queryStr = ((UITextField*)textField).text;
}


#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!self.kcPeiJianView.hidden){
        PartsCell* cell = [PartsCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else if(!self.tmpPeiJianView.hidden){
        TempPartsCell* cell = [TempPartsCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else {
        SelfPartsCell* cell = [SelfPartsCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10*PXSCALEH;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor redColor];
//    return headerView;
//}

//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleInsert;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    TempPartsModel* model = [[TempPartsModel alloc] init];
//    [self.dataSource insertObject:model atIndex:indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.kcPeiJianView.hidden){
       
        return 110*PXSCALEH;
    }else if(!self.tmpPeiJianView.hidden){
        return 180*PXSCALEH;
    }else {
        return 100*PXSCALE;
    }
    return 110*PXSCALEH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!self.kcPeiJianView.hidden){
        PartsCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.checkBtn.selected = !cell.checkBtn.selected;
    }
}


#pragma 搜索内容
-(void)searchContent:(UITapGestureRecognizer *)tap{
    UITextField* textField = [self.view viewWithTag:1000];
    self.kcPeijianArray = [[DataBaseTool shareInstance] queryPartsListData:textField.text];
    self.dataSource = self.kcPeijianArray;
    [self.tableView reloadData];
}


#pragma _segment选择
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.kcPeiJianView.hidden = NO;
            self.tmpPeiJianView.hidden = YES;
            self.zdPeiJianView.hidden = YES;
            self.dataSource = self.kcPeijianArray;
//            if([_searchView superview]){
//
//            }
            _searchView.hidden = NO;
            _searchView.frame = CGRectMake(0, 10*PXSCALEH, MainS_Width, 40*PXSCALEH);

//            [self.tableView addSubview:_searchView];
            break;
        case 1:
            self.kcPeiJianView.hidden = YES;
            self.tmpPeiJianView.hidden = NO;
            self.zdPeiJianView.hidden = YES;
            self.dataSource = self.tempPeijianArray;
//            [_searchView removeFromSuperview];
            _searchView.hidden = YES;

            _searchView.frame = CGRectMake(0, 10*PXSCALEH, MainS_Width, 0);
            break;
        case 2:
            self.kcPeiJianView.hidden = YES;
            self.tmpPeiJianView.hidden = YES;
            self.zdPeiJianView.hidden = NO;
            self.dataSource = self.selfPeijianArray;
//            [_searchView removeFromSuperview];
            _searchView.frame = CGRectMake(0, 10*PXSCALEH, MainS_Width, 0);
            _searchView.hidden = YES;
            break;
        default:
            NSLog(@"3");
            break;
    }
    [self.tableView reloadData];
}

#pragma btn
-(void)selectItemBtnClick:(UIButton*)btn{
   
    switch (btn.tag) {
        case 120:
        case 111://确定
        case 131:
            [self makeSureData];
            break;
        case 110://新增配件
            [self insertTempPartCell];
            break;
        
            break;
        case 130:
            [self insertSelfPartCell];
            break;
        default:
            break;
    }
}

#pragma 确定数据
-(void)makeSureData{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    NSMutableArray* array = [NSMutableArray array];

    for(int row=0;row<rows;row++){
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        //获取cell
        if(!self.kcPeiJianView.hidden){
            PartsCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
            PartsModel* model = cell.model;
            if(cell.checkBtn.selected){
                [array addObject:model];
            }
        }else if(!self.tmpPeiJianView.hidden){
            TempPartsCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
            TempPartsModel* model = cell.model;
            if(model.name!=nil&&model.jinjia!=nil&&model.xiaojia!=nil&&model.shuliang!=nil){
                PartsModel* partsModel = [[PartsModel alloc] init];
                partsModel.pjmc = model.name;
                partsModel.xsj = model.xiaojia;
                partsModel.pjjj = model.jinjia;
                partsModel.sl = model.shuliang;
                [array addObject:partsModel];
            }
        }else if(!self.zdPeiJianView.hidden){
            SelfPartsCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
            SelfPartsModel* model = cell.model;
            if(model.name!=nil&&model.shuliang!=nil){
                PartsModel* partsModel = [[PartsModel alloc] init];
                partsModel.pjmc = model.name;
                partsModel.sl = model.shuliang;
                [array addObject:partsModel];
            }
        }
    }
    
    if(!self.kcPeiJianView.hidden){
        [self submitPartsData:array];
    }else{
        [self submitTempPartsData:array];
    }
//    NSLog(@"%@",array);

}

#pragma 提交数据
-(void)submitPartsData:(NSMutableArray*)array{
    self.postNum = 0;
    self.successNum = 0;
    self.progress = [ToolsObject showLoading:@"正在提交中" with:self];
    __weak PeijianSelectViewController *safeSelf = self;
    self.errorMsg = @"";
    for(int i=0;i<array.count;i++){
        PartsModel* model = [array objectAtIndex:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"db"] = [ToolsObject getDataSouceName];
        dict[@"function"] = @"sp_fun_upload_parts_project_detail";//车间管理
        dict[@"pjbm"] = model.pjbm;
        dict[@"pjmc"] = model.pjmc;
        dict[@"ck"] = model.ck;
        dict[@"cd"] = model.cd;
        dict[@"cx"] = model.cx;
        dict[@"dw"] = model.dw;
        dict[@"property"] = @"维修";
        dict[@"zt"] = @"";
        dict[@"ssj"] = model.xsj;
        dict[@"cb"] = model.pjjj;
        dict[@"sl"] = model.sl;
        dict[@"xh"] = @"0";
        dict[@"operater_code"] = @"superuser";
        dict[@"comp_code"] = @"A";
        dict[@"jsd_id"] = _jsd_id;// 传过来
        [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
            safeSelf.postNum++;
            if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
                safeSelf.successNum++;
            }else{
                NSString* msg = [responseObject objectForKey:@"msg"];
                self.errorMsg = msg;
            }
            if(safeSelf.successNum==array.count){
                NSLog(@"提交成功");
                [safeSelf.progress hideAnimated:YES];
                [ToolsObject show:@"提交成功" With:safeSelf];
//                [safeSelf.navigationController popViewControllerAnimated:YES];
                UIViewController *ctl = safeSelf.navigationController.viewControllers[safeSelf.navigationController.viewControllers.count - 2];
                if ([ctl isKindOfClass:[ProjectOrderViewController class]]) {
                    ProjectOrderViewController * ctl2 = (ProjectOrderViewController*)ctl;
                    ctl2.isNeedRefresh = YES;
                    [safeSelf.navigationController popToViewController:ctl2 animated:YES];
                }else{
                    [safeSelf backBtnClick];
                }
            }else if(safeSelf.postNum==array.count){
                [ToolsObject show:[NSString stringWithFormat:@"提交成功%d个,失败%lu个",safeSelf.successNum,(array.count-safeSelf.successNum)] With:safeSelf];
            }
        } failure:^(NSError * _Nonnull error) {
            safeSelf.postNum++;
            safeSelf.errorMsg = @"网络错误";
            if(safeSelf.postNum==array.count){
                [ToolsObject show:[NSString stringWithFormat:@"提交成功%d个,失败%lu个",safeSelf.successNum,(array.count-safeSelf.successNum)] With:safeSelf];
            }
            
        }];
    }
   
}

#pragma 提交临时part
-(void)submitTempPartsData:(NSMutableArray*)array{
    self.postNum = 0;
    self.successNum = 0;
    self.progress = [ToolsObject showLoading:@"正在提交中" with:self];
    __weak PeijianSelectViewController *safeSelf = self;
    self.errorMsg = @"";

    for(int i=0;i<array.count;i++){
        PartsModel* model = [array objectAtIndex:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"db"] = [ToolsObject getDataSouceName];
        dict[@"function"] = @"sp_fun_upload_parts_project_detail";//车间管理
        dict[@"pjbm"] = model.pjbm;
        dict[@"pjmc"] = model.pjmc;
        dict[@"ck"] = model.ck;
        dict[@"cd"] = model.cd;
        dict[@"cx"] = model.cx;
        dict[@"dw"] = model.dw;
        dict[@"property"] = @"维修";
        dict[@"zt"] = @"急件销售";
        dict[@"ssj"] = model.xsj;
        dict[@"cb"] = model.pjjj;
        dict[@"sl"] = model.sl;
        dict[@"xh"] = @"0";
        dict[@"operater_code"] = @"superuser";
        dict[@"comp_code"] = @"A";
        dict[@"jsd_id"] = _jsd_id;// 传过来
        [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
            
            if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
//                NSMutableArray *items = [responseObject objectForKey:@"data"];
                safeSelf.successNum++;
               
            }else{
                NSString* msg = [responseObject objectForKey:@"msg"];
                safeSelf.errorMsg = msg;
            }
            if(safeSelf.successNum==array.count){
                NSLog(@"提交成功");
                [safeSelf.progress hideAnimated:YES];
                [ToolsObject show:@"提交成功" With:safeSelf];
//                [safeSelf.navigationController popViewControllerAnimated:YES];
                UIViewController *ctl = safeSelf.navigationController.viewControllers[safeSelf.navigationController.viewControllers.count - 2];

                if ([ctl isKindOfClass:[ProjectOrderViewController class]]) {
                    ProjectOrderViewController * ctl2 = (ProjectOrderViewController*)ctl;
                    ctl2.isNeedRefresh = YES;
                    [safeSelf.navigationController popToViewController:ctl2 animated:YES];
                }else{
                    [safeSelf backBtnClick];
                }
            }else if(safeSelf.postNum==array.count){
                [ToolsObject show:[NSString stringWithFormat:@"提交成功%d个,失败%lu个",safeSelf.successNum,(array.count-safeSelf.successNum)] With:safeSelf];
            }
        } failure:^(NSError * _Nonnull error) {
            safeSelf.postNum++;
            safeSelf.errorMsg = @"网络错误";
            if(safeSelf.postNum==array.count){
                [ToolsObject show:[NSString stringWithFormat:@"提交成功%d个,失败%lu个",safeSelf.successNum,(array.count-safeSelf.successNum)] With:safeSelf];
            }

        }];
    }
    
}


#pragma 插入cell
-(void)insertTempPartCell{
    TempPartsModel* model = [[TempPartsModel alloc] init];
    [self.dataSource insertObject:model atIndex:self.dataSource.count-1];

    [self.tableView beginUpdates];
    NSArray *tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:_dataSource.count -1 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:tempIndexPathArr withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma 自带配件
-(void)insertSelfPartCell{
    SelfPartsModel* model = [[SelfPartsModel alloc] init];
    [self.dataSource insertObject:model atIndex:self.dataSource.count-1];
    [self.tableView beginUpdates];
    NSArray *tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:_dataSource.count -1 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:tempIndexPathArr withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
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



#pragma --------------------end



#pragma --------------------data

-(void)initData{
    self.kcPeijianArray = [[DataBaseTool shareInstance] queryPartsListData:@""];
    self.dataSource = self.kcPeijianArray;
    [self.tableView reloadData];
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
- (NSMutableArray *)kcPeijianArray
{
    if (!_kcPeijianArray) {
        _kcPeijianArray = [NSMutableArray array];
    }
    return _kcPeijianArray;
}


#pragma mark - Getters
- (NSMutableArray *)tempPeijianArray
{
    if (!_tempPeijianArray) {
        _tempPeijianArray = [NSMutableArray array];
    }
    return _tempPeijianArray;
}

#pragma mark - Getters
- (NSMutableArray *)selfPeijianArray
{
    if (!_selfPeijianArray) {
        _selfPeijianArray = [NSMutableArray array];
    }
    return _selfPeijianArray;
}

#pragma mark - Getters
- (NSMutableArray *)tempIndexPathArray
{
    if (!_tempIndexPathArray) {
        _tempIndexPathArray = [NSMutableArray array];
    }
    return _tempIndexPathArray;
}


#pragma 获取配件数据 这里有问题 没有数据会崩溃
-(void)getPeijianDataList{
    
}

#pragma --------------------data
@end
