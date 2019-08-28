//
//  ProjectSelectViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectSelectViewController.h"
#import "ProjectOrderViewController.h"

@interface ProjectSelectViewController()

@property (nonatomic,strong)NSString *queryStr;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,strong)HnTextField *searchTextField;
@property (nonatomic,weak)UIView *topView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *firstIconGridView;
@property (nonatomic,strong)UIView *secondIconGridView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *firstIconArray;
@property (nonatomic,strong)NSMutableArray *secondIconArray;
@property (nonatomic,strong)SecondIconInfoModel *selectModel;

@end

typedef void (^asyncCallback)(NSString* errorMsg,id result);


@implementation ProjectSelectViewController



-(void) viewDidLoad
{
    [self initView];
    [self initData];
}

#pragma --------------------view

-(void)initView{
    [self setNavTitle:@"项目选择" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"home_icon" rightAction:@selector(backHome) withVC:self];
    [self initTopView];
    [self initContentView];
    [self initBottomView];
}

-(void)initTopView{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, MainS_Width, 40*PXSCALEH)];
    view.backgroundColor = SetColor(@"#A58BBA", 1);
    UIImageView* headImgView = [PublicFunction getImageView:CGRectMake(MainS_Width/4-20*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_person"];
    UILabel* personLabel = [PublicFunction getlabel:CGRectMake(headImgView.frame.origin.x+headImgView.bounds.size.width+5*PXSCALE, 0, MainS_Width/4, 40*PXSCALE) text:_model.cz size:14 align:@"left"];
    [personLabel setTextColor:[UIColor whiteColor]];
    personLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:headImgView];
    [view addSubview:personLabel];
    UIImageView* carImgView = [PublicFunction getImageView:CGRectMake(MainS_Width/2+MainS_Width/4-30*PXSCALE, 10*PXSCALEH, 20*PXSCALE, 20*PXSCALE) imageName:@"car_yellow"];
    UILabel* carLabel = [PublicFunction getlabel:CGRectMake(carImgView.frame.origin.x+carImgView.bounds.size.width+5*PXSCALE, 0, MainS_Width/4, 40*PXSCALE) text:_model.mc size:14 align:@"left"];
    [carLabel setTextColor:[UIColor whiteColor]];
    carLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:carLabel];
    [view addSubview:carImgView];
    self.topView = view;
    [self.view addSubview:view];
    
}


-(void)initContentView{
    //segment
    //添加到主视图
    UISegmentedControl* segment = [self createSegment];
    [self.view addSubview:segment];
//
    //搜索
    _searchTextField = [[HnTextField alloc] initWithFrame:CGRectMake(10*PXSCALE, segment.frame.origin.y+segment.frame.size.height+10*PXSCALEH, MainS_Width-10*PXSCALE-50*PXSCALE, 40*PXSCALEH)];
    [_searchTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchTextField];

    UIImageView* imgView = [PublicFunction getImageView:CGRectMake(_searchTextField.frame.origin.x+_searchTextField.bounds.size.width+10*PXSCALE, _searchTextField.frame.origin.y+10*PXSCALEH, 30, 30) imageName:@"red_white_search"];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchContent:)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap0];
    [self.view addSubview:imgView];
    
    //网格
    _firstIconGridView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchTextField.frame.origin.y+_searchTextField.bounds.size.height+10*PXSCALEH, MainS_Width, 180*PXSCALE)];
    _firstIconGridView.backgroundColor = lightGrayColor;
    [self.view addSubview:_firstIconGridView];
    _secondIconGridView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchTextField.frame.origin.y+_searchTextField.bounds.size.height+10*PXSCALEH, MainS_Width, 180*PXSCALE)];
    _secondIconGridView.backgroundColor = lightGrayColor;
    _secondIconGridView.hidden = YES;
    [self.view addSubview:_secondIconGridView];

}

-(void)initBottomView{
    CGFloat btnWidth = (MainS_Width-50*PXSCALEH-40*PXSCALE)/3;
    CGFloat btnHeight = 40*PXSCALEH;
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(MainS_Width/2-(3*btnWidth+20*PXSCALE)/2, MainS_Height-100*PXSCALEH, 3*btnWidth+10*PXSCALE, 100*PXSCALEH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    NSArray* paigongMenuArr = @[@"返回至接车",@"car_food",@"确认至工单"];
    for(int i=0;i<paigongMenuArr.count;i++){
        if(i!=1){
            UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*(btnWidth+10*PXSCALE),(100*PXSCALEH-btnHeight)/2, btnWidth, btnHeight) imageName:@"" title:[paigongMenuArr objectAtIndex:i] clickAction:@selector(selectItemBtnClick:)];
            btn.backgroundColor = lightGreenColor;
            btn.tag = 110+i;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView addSubview:btn];
        }else{
            UIImageView* carImageView = [PublicFunction getImageView:CGRectMake(i%3*(btnWidth+10*PXSCALE),(100*PXSCALEH-btnWidth)/2, btnWidth, btnWidth) imageName:[paigongMenuArr objectAtIndex:i]];
            [bottomView addSubview:carImageView];
        }
    
    }
    [self.view addSubview:bottomView];
}

#pragma btn
-(void)itemClick:(UIButton*)btn{
    //进入二级
//    btn.currentTitle
    NSInteger index = btn.tag-100;
    FirstIconInfoModel* model = [self.firstIconArray objectAtIndex:index];
    NSLog(@"selected:%@",model.wxgz);
    NSMutableArray* array = [[DataBaseTool shareInstance] querySecondIconListData:model.wxgz];
    self.secondIconArray = array;
    //遍历移除
//    [self.secondIconGridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for(UIView *topView in [self.secondIconGridView subviews])
//    {
//        if ([topView isKindOfClass:[UIView class]]) {
//            [topView removeFromSuperview];
//        }
//    }
    UIView* topView = [self.secondIconGridView viewWithTag:999];
    if(topView!=nil){
        [topView removeFromSuperview];
    }
    UIView* secondView = [self createSecondIconGridView:array];
    self.secondIconGridView.frame = self.firstIconGridView.frame;
    [self.secondIconGridView addSubview:secondView];
    self.firstIconGridView.hidden = YES;
    self.secondIconGridView.hidden = NO;
}

#pragma btn
-(void)secondItemClick:(UIButton*)btn{
    NSInteger index = btn.tag-200;
    for(UIView* btnView in btn.superview.subviews){
        if ([btnView isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)btnView;
            btn.backgroundColor = [UIColor clearColor];
        }
    }
    if(index==0){
        self.firstIconGridView.hidden = NO;
        self.secondIconGridView.hidden = YES;
        _selectModel = nil;
    }else{
        [btn setBackgroundColor:SetColor(@"#cccccc", 1)];
        SecondIconInfoModel* model = [self.secondIconArray objectAtIndex:index];
        NSLog(@"selected:%@",model.mc);
        _selectModel = model;
    }
   
}

-(void)selectItemBtnClick:(UIButton*)btn{
    
    switch (btn.tag) {
        case 110:
            break;
        case 112://确认工单
            [self upLoadServer];
            break;
        default:
            break;
    }
}



#pragma _segment选择
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            break;
        case 1:
        
            break;
        case 2:
        
            break;
        default:
            NSLog(@"3");
            break;
    }
}

#pragma segment
-(UISegmentedControl *)createSegment{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"快捷业务",@"常规项目",@"保养套餐", nil];
    UISegmentedControl* segment = [[UISegmentedControl alloc]initWithItems:arr];
    //设置frame
    segment.frame = CGRectMake(20*PXSCALE, NavBarHeight+40*PXSCALEH+10*PXSCALEH, MainS_Width-40*PXSCALE, 40*PXSCALEH);
    segment.backgroundColor = [UIColor grayColor];
    segment.layer.masksToBounds = NO;               //    默认为no，不设置则下面一句无效
    segment.layer.cornerRadius = 0;               //    设置圆角大小，同UIView
    segment.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    //segment.frame = CGRectMake(0, 0.15029*CFG, 0.2716*CFW, 0.0814*CFG); // 0.3642*CFW
    segment.selectedSegmentIndex = 0;
    [segment setTintColor:hotPinkColor];
    segment.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    //    未选中的颜色
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    //当选中不同的segment时,会触发不同的点击事件
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    return segment;
}


#pragma 创建一级页面
-(UIView *)createFirstIconGridView:(NSMutableArray*)array{
    CGFloat btn_width = (MainS_Width-40*PXSCALE)/3.0;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20*PXSCALE, 0, MainS_Width-40*PXSCALE, btn_width*3)];
    for(int i=0;i<array.count;i++){
        FirstIconInfoModel* model = [array objectAtIndex:i];
        UIButton *btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*btn_width, i/3*btn_width-15*PXSCALEH, btn_width, btn_width) TitleImageName:@"fold_img" title:nil tag:i+100 clickAction:@selector(itemClick:)];
        [bgView addSubview:btn];
        
        UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(i%3*btn_width, i/3*btn_width-15*PXSCALEH, btn_width, 30) text:model.wxgz fontSize:12 color:SetColor(@"#333333", 1) align:@"center"];
        titleLabel.center = CGPointMake(btn.center.x, btn.center.y+btn_width/2.0-10);
        [bgView addSubview:titleLabel];

    }
    return bgView;
    
}

-(UIView *)createSecondIconGridView:(NSMutableArray*)array{
    [array insertObject:@"返回" atIndex:0];
    CGFloat btn_width = (MainS_Width-40*PXSCALE)/3.0;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20*PXSCALE, 0, MainS_Width-40*PXSCALE, btn_width*3)];
    bgView.tag = 999;
    
    for(int i=0;i<array.count;i++){
        SecondIconInfoModel* model = [array objectAtIndex:i];
       
        if(i==0){
            UIButton *btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*btn_width, i/3*btn_width, btn_width, btn_width) TitleImageName:@"fold_back_img" title:nil tag:i+200 clickAction:@selector(secondItemClick:)];
            
            [bgView addSubview:btn];
            
            UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(i%3*btn_width, i/3*btn_width-15*PXSCALEH, btn_width, 30) text:@"返回" fontSize:12 color:SetColor(@"#333333", 1) align:@"center"];
            titleLabel.center = CGPointMake(btn.center.x, btn.center.y+btn_width/2.0-10);
            [bgView addSubview:titleLabel];

        }else{
            UIButton *btn = [PublicFunction getButtonInControl:self frame:CGRectMake(i%3*btn_width, i/3*btn_width, btn_width, btn_width) TitleImageName:@"file_img" title:nil tag:i+200 clickAction:@selector(secondItemClick:)];
            [bgView addSubview:btn];
            UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(i%3*btn_width, i/3*btn_width-15*PXSCALEH, btn_width, 30) text:model.mc fontSize:12 color:SetColor(@"#333333", 1) align:@"center"];
            titleLabel.center = CGPointMake(btn.center.x, btn.center.y+btn_width/2.0-10);
            [bgView addSubview:titleLabel];
        }
        
    }
    return bgView;
    
}




#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(id)textField
{
    _queryStr = ((UITextField*)textField).text;
}

#pragma --------------------end view


#pragma --------------------data

-(void)initData{
    __weak ProjectSelectViewController* safeSelf = self;
    
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    self.errorMsg = @"";
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getFirstIconList:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.firstIconArray = result;
        }
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_enter(group);
    
    [self getSecondIconData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
        }
        //这里不能直接赋值 二级根据一级菜单来
        dispatch_group_leave(group);
    }];
    
    
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [safeSelf.progress hideAnimated:YES];
        if(![safeSelf.errorMsg isEqualToString:@""]){
            [ToolsObject show:safeSelf.errorMsg With:safeSelf];
        }else{
            
        }
        if(safeSelf.firstIconArray.count>0){
            UIView* firstIconView = [safeSelf createFirstIconGridView:safeSelf.firstIconArray];
            [safeSelf.firstIconGridView addSubview:firstIconView];
            safeSelf.firstIconGridView.frame = CGRectMake(safeSelf.firstIconGridView.frame.origin.x, safeSelf.firstIconGridView.frame.origin.y, MainS_Width, firstIconView.bounds.size.height);
        }
      
    });

}



-(void)getSecondIconData:(asyncCallback)callback{
    NSMutableArray* array = [[DataBaseTool shareInstance] querySecondIconListData:@""];
    if(array.count!=0){
        callback(@"",array);
    }else{
        [self getSecondIconList:callback previous_xh:@"0"];
    }
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

#pragma 获取二级图标
-(void)getSecondIconList:(asyncCallback)callback previous_xh:(NSString*)previous_xh{
    __weak ProjectSelectViewController* safeSelf = self;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_maintenance_project";//车间管理
    dict[@"previous_xh"] = previous_xh;
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [SecondIconInfoModel mj_objectArrayWithKeyValuesArray:items] ;//获取第一个
            [[DataBaseTool shareInstance] insertSecondIconListData:array];
            //继续调用
            NSString* tmpPrevious_xh = [responseObject objectForKey:@"Previous_xh"];
            if(![tmpPrevious_xh isEqualToString:@"end"]){
                [safeSelf getSecondIconList:callback previous_xh:tmpPrevious_xh];
            }else{
                callback(@"",nil);
            }
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 确认工单
-(void)confirmGd:(asyncCallback)callback{
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"jsd_id"] = _model.jsd_id;

    dict[@"function"] = @"sp_fun_upload_maintenance_project_detail";//车间管理
    dict[@"xlxm"] = _selectModel.mc;
    dict[@"xlf"] = _selectModel.xlf;
    dict[@"zk"] = @"0.00";
    dict[@"wxgz"] = _selectModel.wxgz;
    dict[@"pgzje"] = _selectModel.spj;
    dict[@"pgzgs"] = _selectModel.pgzgs;
    dict[@"xh"] = @"0";

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

#pragma 搜索内容
-(void)searchContent:(UITapGestureRecognizer *)tap{
    UITextField* textField = [self.view viewWithTag:1000];
}

#pragma mark - Getters
- (NSMutableArray *)firstIconArray
{
    if (!_firstIconArray) {
        _firstIconArray = [NSMutableArray array];
    }
    return _firstIconArray;
}

#pragma mark - Getters
- (NSMutableArray *)secondIconArray
{
    if (!_secondIconArray) {
        _secondIconArray = [NSMutableArray array];
    }
    return _secondIconArray;
}

-(void)upLoadServer{
    if(_selectModel==nil){
        [ToolsObject show:@"您还未选择项目" With:self];
        return;
    }
    __weak ProjectSelectViewController* safeSelf = self;

    [self confirmGd:^(NSString *errorMsg, id result) {
        if([errorMsg isEqualToString:@""]){
//            UIViewController *ctl = safeSelf.navigationController.viewControllers[safeSelf.navigationController.viewControllers.count - 2];
//            if ([ctl isKindOfClass:[ProjectOrderViewController class]]) {
//                ProjectOrderViewController * ctl2 = (ProjectOrderViewController*)ctl;
//                ctl2.isNeedRefresh = YES;
//                [safeSelf.navigationController popToViewController:ctl2 animated:YES];
//            }else{
//                [safeSelf backBtnClick];
//            }
            [self enterWorkOrder:_model];
        }else{
            [ToolsObject show:errorMsg With:safeSelf];
        }
    }];
}
#pragma --------------------end data

@end
