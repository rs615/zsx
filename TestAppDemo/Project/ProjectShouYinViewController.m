//
//  ProjectShouYinViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/23.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectShouYinViewController.h"
#import "RateModel.h"
#import "EBDropdownListView.h"
#import "MoneyModel.h"
#import "ShouyinModel.h"
#import "ProjectOrderViewController.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface ProjectShouYinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic, strong) NSMutableArray *ratesData;
@property (nonatomic,strong)ShouyinModel *shouyinModel;
@property (nonatomic,strong)NSString *bankRate;
@property (nonatomic,strong)NSString *zfbRate;
@property (nonatomic,strong)NSString *wxRate;
@property (nonatomic,strong)NSString *yhkRate;

@property (nonatomic,assign)double xinjinNum;
@property (nonatomic,assign)double shuakaNum;
@property (nonatomic,assign)double zhuanzhangNum;
@property (nonatomic,assign)double guazhangNum;
@property (nonatomic,assign)double wxNum;
@property (nonatomic,assign)double zfbNum;
@property (nonatomic,assign)double ycbNum;
@property (nonatomic,assign)double yskNum;
@property (nonatomic,assign)double vipNum;
@property (nonatomic,copy)NSString* vipCard;


@property (nonatomic,copy)NSString* shuaKa;

@end

@implementation ProjectShouYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"收银" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
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
    [self initContentView];
}


-(void)initContentView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,NavBarHeight , MainS_Width, MainS_Height-NavBarHeight)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self createTopView];
    self.tableView.tableFooterView = [self createBottomView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(UIButton*)createBottomView{
    UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(0, 0, MainS_Width, 40*PXSCALEH) imageName:nil title:@"收银" clickAction:@selector(btnSelected:)];
    btn.tag = 400;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = lightGreenColor;
    return btn;
}

-(UIView*)createTopView{
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
    return view;
}

#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 70*PXSCALEH;
    }
    return 360*PXSCALEH;
}

-(UITableViewCell *)createFirstCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
    cell.selectedBackgroundView = [[UIView alloc] init];
    //就这两句代码
    cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    NSArray* titleArr = @[@"预收款余额: ",@"未分配: ",@"应收总计: ",@"优惠: "];
    NSArray* valueArr;
    if(self.shouyinModel==nil){
        valueArr = @[@"",@"",@"",@"0"];
    }else{
        valueArr = @[self.shouyinModel.Pre_payment,self.shouyinModel.Pre_payment,self.shouyinModel.zje,@"0"];
    }
    UILabel* yskLable = [PublicFunction getlabel:CGRectMake(30*PXSCALE, 0, (MainS_Width-60*PXSCALE)/2, 30*PXSCALEH) text:[NSString stringWithFormat:@"预收款余额: %@",valueArr[0]] align:@"left"];
    UILabel* wfpLable = [PublicFunction getlabel:CGRectMake(MainS_Width/2+20*PXSCALE, 0, (MainS_Width-60*PXSCALE)/2, 30*PXSCALEH) text:[NSString stringWithFormat:@"未分配: %@",valueArr[1]] align:@"left"];
    wfpLable.tag = 300;
    [cell.contentView addSubview:yskLable];
    [cell.contentView addSubview:wfpLable];

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 30*PXSCALEH, MainS_Width, 40*PXSCALEH)];
    view.backgroundColor = lightBlueColor;
    UILabel* yszjLable = [PublicFunction getlabel:CGRectMake(30*PXSCALE, 0, (MainS_Width-60*PXSCALE)/2, 40*PXSCALEH) text:[NSString stringWithFormat:@"应收总计: %@",valueArr[2]] align:@"left"];
    UILabel* yhLable = [PublicFunction getlabel:CGRectMake(MainS_Width/2+20*PXSCALE, 0, (MainS_Width-60*PXSCALE)/2, 40*PXSCALEH) text:[NSString stringWithFormat:@"优惠: %@",valueArr[3]] align:@"left"];
    [view addSubview:yszjLable];
    [view addSubview:yhLable];
    [cell.contentView addSubview:view];


    return cell;
}

-(UITableViewCell *)createSecondCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
    cell.selectedBackgroundView = [[UIView alloc] init];
    //就这两句代码
    cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = lightGrayColor;
  
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    NSArray* titleArr = @[@"现金:¥",@"刷卡",@"银行账户:",@"费率:",@"银行转账:¥",@"会员卡号:",@"扣取余额¥:",];
    for (int i=0; i<titleArr.count; i++) {
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, i*50*PXSCALEH+10, MainS_Width/4, 30*PXSCALEH) text:titleArr[i] align:@"right"];
       
        UITextField* textField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(MainS_Width/4+5*PXSCALE, i*50*PXSCALEH+10, MainS_Width/4*2-5*PXSCALE, 30*PXSCALEH) tag:100+i returnType:@"next"];
        textField.layer.borderWidth = 0;
        textField.backgroundColor = [UIColor whiteColor];
//        textField.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
//        textField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        if(i==2){
            
            EBDropdownListView* dropdownListView = [[EBDropdownListView alloc] initWithFrame:textField.frame];
            dropdownListView.layer.cornerRadius = 6;
            dropdownListView.layer.borderWidth = 1;
            dropdownListView.layer.masksToBounds = YES;
            [dropdownListView setSelectedIndex:0];
            [dropdownListView setViewBorder:1 borderColor:[UIColor whiteColor] cornerRadius:2];
            [dropdownListView setDataSource:self.dataSource];
            [dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
                UITextField* flTextField = [cell.contentView viewWithTag:103];
                flTextField.text = ((RateModel*)self.ratesData[dropdownListView.selectedIndex]).setup2;
                self.yhkRate = flTextField.text;
                self.shuaKa = dropdownListView.selectedItem.itemName;
            }];
            [cell.contentView addSubview:dropdownListView];
        }else{
            if(i==3){
                if(self.ratesData.count>0){
                     textField.text = ((RateModel*)self.ratesData[0]).setup2;
                }
                [textField setEnabled:NO];
            }else{
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            [cell.contentView addSubview:textField];
        }
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

        if(i==0||i==1||i==4||i==5){
            NSString* btnTitle = @"全额支付";
            UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(MainS_Width/4*3+5*PXSCALE, i*50*PXSCALEH+10, MainS_Width/4-15*PXSCALE, 30*PXSCALE) imageName:nil title:btnTitle clickAction:@selector(btnSelected:)];
            btn.tag = 110+i;
            if(i==5){
                btnTitle =@"查余额";
                btn.frame = CGRectMake(MainS_Width/4*3+5*PXSCALE, i*50*PXSCALEH+10, MainS_Width/4-20*PXSCALE, 30*PXSCALE);
            }
            [btn setTitle:btnTitle forState:UIControlStateNormal];
//            CGRect btnRect = [ToolsObject getStringFrame:btnTitle withFont:12 withMaxSize:CGSizeMake(MainS_Width/4-10*PXSCALE, 30*PXSCALEH)];
            btn.backgroundColor = lightGreenColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
        }
        
        [cell.contentView addSubview:titleLabel];
    }
    return cell;
}

-(UITableViewCell *)createThird:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = lightGrayColor;

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainS_Width, 10*PXSCALEH)];
    view.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:view];
  
    NSArray* titleArr = @[@"挂账金额:¥",@"微信:¥",@"费率:",@"支付宝:¥",@"费率:",@"预收款抵扣:¥",@"养车币"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel* titleLabel = [PublicFunction getlabel:CGRectMake(0, i*50*PXSCALEH+20*PXSCALEH, MainS_Width/4, 30*PXSCALEH) text:titleArr[i] align:@"right"];
        
        UITextField* textField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(MainS_Width/4+5*PXSCALE, i*50*PXSCALEH+20*PXSCALEH, MainS_Width/4*2-5*PXSCALE, 30*PXSCALEH) tag:200+i returnType:@""];
        textField.layer.borderWidth = 0;
        textField.backgroundColor = [UIColor whiteColor];
        //        textField.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
        //        textField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

        if(i==0||i==1||i==3){
           
            NSString* btnTitle = @"全额支付";
            UIButton* btn = [PublicFunction getButtonInControl:self frame:CGRectMake(MainS_Width/4*3+5*PXSCALE, i*50*PXSCALEH+20*PXSCALEH, MainS_Width/4-15*PXSCALE, 30*PXSCALE) imageName:nil title:btnTitle clickAction:@selector(btnSelected:)];
            btn.tag = 210+i;
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            btn.backgroundColor = lightGreenColor;
            textField.keyboardType = UIKeyboardTypeNumberPad;

            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
        }else{
            if(i==2){
                textField.text = _wxRate;
                [textField setEnabled:NO];
            }else if(i==4){
                textField.text = _zfbRate;
                [textField setEnabled:NO];
            }else  if(i==titleArr.count-1){
                UILabel* valueLabel = [PublicFunction getlabel:CGRectMake(MainS_Width/4*3+5*PXSCALE, i*50*PXSCALEH+20*PXSCALEH, MainS_Width/4-15*PXSCALE, 30*PXSCALE) text:@"余额: 0" align:@"left"];
                valueLabel.tag = 220;
                valueLabel.hidden = YES;
                [cell.contentView addSubview:valueLabel];
                textField.placeholder = @"扣除养车币";
            }
        }
        if(i==5){
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
       
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:textField];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return [self createFirstCell:tableView withIndexPath:indexPath];
    }else if(indexPath.section==1){
        
        return [self createSecondCell:tableView withIndexPath:indexPath];

    }else{
        
        return [self createThird:tableView withIndexPath:indexPath];
        
    }
}


-(void)btnSelected:(UIButton*)btn{
    __weak ProjectShouYinViewController* safeSelf = self;
    if(btn.tag==110||btn.tag==111||btn.tag==114||btn.tag==210||btn.tag==211||btn.tag==213){
        //现金支付
        double other = _xinjinNum+_shuakaNum+_zhuanzhangNum+_guazhangNum+_wxNum+_zfbNum;
        double ysje = [_shouyinModel.zje doubleValue];
        double shengYuTotal = ysje - other >0? (ysje - other):0;
        UITextField* textField = [[[btn superview] superview] viewWithTag:btn.tag-10];
        textField.text = [NSString stringWithFormat:@"%.2f",shengYuTotal];
        //未分配
        UILabel* wfpLabel = [self.tableView viewWithTag:300];
        wfpLabel.text = [NSString stringWithFormat:@"未分配:%d",0];
        
    }
    if(btn.tag==115){
        UITextField* vipTextField = [[[btn superview] superview] viewWithTag:105];
        if(![vipTextField.text isEqualToString:@""]){
            self.progress = [ToolsObject showLoading:@"加载中" with:self];
            [self showAllMoney:^(NSString *errorMsg, id result) {
                [safeSelf.progress hideAnimated:YES];
                if(![errorMsg isEqualToString:@""]){
                    [ToolsObject show:errorMsg With:safeSelf];
                }else{
                    //显示余额
                    UILabel* yeLabel = [self.tableView viewWithTag:220];
                    yeLabel.hidden = NO;
                    yeLabel.text = [NSString stringWithFormat:@"余额: %@",result];
                }
            } vipCard:vipTextField.text];
        }else{
            [ToolsObject show:@"您还没有输入卡号" With:self];
        }
    }
    
    if(btn.tag==400){
        NSArray* moneyDescArr= @[@"消费卡",@"现金",@"刷卡",@"转账",@"挂账",@"微信",@"支付宝",@"预收款",@"养车币"];
        NSMutableArray* moneyArr = [NSMutableArray array];
        [moneyArr addObject:[NSNumber numberWithDouble:_vipNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_xinjinNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_shuakaNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_zhuanzhangNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_guazhangNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_wxNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_zfbNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_yskNum]];
        [moneyArr addObject:[NSNumber numberWithDouble:_ycbNum]];
        
        NSMutableArray* moneySxfArr = [NSMutableArray array];
        [moneySxfArr addObject:[NSNumber numberWithDouble:0]];
        [moneySxfArr addObject:[NSNumber numberWithDouble:0]];
        [moneySxfArr addObject:[NSNumber numberWithDouble:_shuakaNum*[_yhkRate doubleValue]]];
        [moneySxfArr addObject:[NSNumber numberWithDouble:0]];
        [moneySxfArr addObject:[NSNumber numberWithDouble:0]];
        [moneySxfArr addObject:[NSNumber numberWithDouble:_wxNum*[_wxRate doubleValue]]];
        [moneySxfArr addObject:[NSNumber numberWithDouble:_wxNum*[_zfbRate doubleValue]]];

        NSMutableArray* newMoneyArr = [NSMutableArray array];
        double moneyTotal = 0;
        double sxfTotal = 0;
        for (int i=0; i<moneyArr.count; i++) {
            double moneyNum = [moneyArr[i] doubleValue];
            if(moneyNum>0){
                MoneyModel* model = [[MoneyModel alloc] init];
                model.money = moneyNum;
                model.sxf = [moneySxfArr[i] doubleValue];
                model.moneyDesc = moneyDescArr[i];
                if([model.moneyDesc rangeOfString:@"刷卡"].location!=NSNotFound){
                    model.moneyDesc = self.shuaKa;
                }
                moneyTotal+=model.sxf;//计算各项付款方式金额的总和
                sxfTotal+= [moneySxfArr[i] doubleValue];//计算各项手续费总和
                [newMoneyArr addObject:model];//将对象push到结算数组中
            }
        }
        if(newMoneyArr.count>3){
            [ToolsObject show:@"结算方式超过3种，请重新选择" With:self];
            return;
        }
        if(newMoneyArr.count==0){
            [ToolsObject show:@"您还未填写付款金额" With:self];
            return;
        }
        //        if(moneyTotal<(ysje-yhje)){//如果金额不正确，提示重新选择

        double yhje = 0;

        if(moneyTotal<([_shouyinModel.zje doubleValue])){
            [ToolsObject show:@"您填写的金额不正确" With:self];
            return;
        }
        double ysje = [_shouyinModel.zje doubleValue];
        NSString* skfs=@"";
        double ssje=0;
        double sxf=0;
        NSString* skfs1 = @"";
        double skje1 = 0;
        double sxf1 = 0;
        NSString* skfs2 = @"";
        double skje2 = 0;
        double sxf2 = 0;
        if( newMoneyArr.count>0){
            //如果是三种付款方式，则按先后顺序赋值
            if(newMoneyArr.count>2){
                MoneyModel* firstModel = ((MoneyModel*)newMoneyArr[0]);
                skfs = firstModel.moneyDesc;
                ysje = firstModel.money;
                ssje = firstModel.money - yhje - firstModel.sxf;
                sxf = firstModel.sxf;
                
                MoneyModel* secondModel = ((MoneyModel*)newMoneyArr[1]);

                skfs1= secondModel.moneyDesc;
                skje1 =  secondModel.money;
                sxf1= secondModel.sxf;
                
                
                MoneyModel* thirdModel = ((MoneyModel*)newMoneyArr[1]);

                skfs2= thirdModel.moneyDesc;
                skje2 = thirdModel.money;
                sxf2= thirdModel.sxf;
                
            }else if(newMoneyArr.count==2){ //如果是两种付款方式，则按先后顺序赋值，第三个赋值为0
                MoneyModel* firstModel = ((MoneyModel*)newMoneyArr[0]);

                skfs = firstModel.moneyDesc;
                ysje = firstModel.money;
                ssje = firstModel.money - yhje - firstModel.sxf;
                sxf = firstModel.sxf;
                
                MoneyModel* secondModel = ((MoneyModel*)newMoneyArr[1]);

                skfs1= secondModel.moneyDesc;
                skje1 =  secondModel.money;
                sxf1= secondModel.sxf;
                
                skfs2= @"";
                skje2 =  0;
                sxf2=0;
            }else if(newMoneyArr.count==1){ //如果是两种付款方式，则按先后顺序赋值，第三个赋值为0
                MoneyModel* firstModel = ((MoneyModel*)newMoneyArr[0]);

                skfs =  firstModel.moneyDesc;
                ysje =  firstModel.money;
                ssje =  firstModel.money - yhje -  firstModel.sxf;
                sxf =  firstModel.sxf;
                skfs1= @"";
                skje1 =  0;
                sxf1=0;
                skfs2=@"";
                skje2 =  0;
                sxf2=0;
            }else if(newMoneyArr.count==0){
                [ToolsObject show:@"您填写付款方式或付款金额" With:self];
                return;
            }
        }
        
        double totalZk = 0;//这里有问题
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"db"] = [ToolsObject getDataSouceName];
        dict[@"function"] = @"sp_fun_upload_receivables_data";//车间管理
        dict[@"company_code"] = [ToolsObject getCompCode];
        dict[@"customer_id"] = _model.customer_id;
        dict[@"jsd_id"] = _model.jsd_id;
        dict[@"czy"] =[ToolsObject getUserName];
        dict[@"ysje"] = _shouyinModel.zje;
        dict[@"yhje"] = [NSString stringWithFormat:@"%.2f",totalZk ];
        dict[@"sxf"] = [NSString stringWithFormat:@"%.2f",sxf ];
        dict[@"ssje"] = [NSString stringWithFormat:@"%.2f",ssje ];
        dict[@"skfs"] = skfs;
        dict[@"bit_compute"]=_shouyinModel.bit_compute;
        dict[@"bit_use"] =_shouyinModel.bit_amount;
        dict[@"skfs1"] = skfs1;
        dict[@"skje1"] = [NSString stringWithFormat:@"%.2f",skje1 ];
        dict[@"sxf1"]= [NSString stringWithFormat:@"%.2f",sxf1 ];
        dict[@"skfs2"] = skfs2;
        dict[@"skje2"] = [NSString stringWithFormat:@"%.2f",skje2 ];
        dict[@"sxf2"] =  [NSString stringWithFormat:@"%.2f",sxf2 ];
        dict[@"pre_payment"] =  _shouyinModel.Pre_payment;
        dict[@"vipcard_no"] = _vipCard;
        self.progress = [ToolsObject showLoading:@"加载中" with:self];
        [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
            [self.progress hideAnimated:YES];

            if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
                [ToolsObject show:@"提交成功" With:self];
                [self enterWorkOrder];
            }else{
                NSString* msg = [responseObject objectForKey:@"msg"];
                [ToolsObject show:msg With:self];

            }
        } failure:^(NSError * _Nonnull error) {
            [self.progress hideAnimated:YES];
            [ToolsObject show:@"网络错误" With:self];
        }];
        
    }
}
-(void)enterWorkOrder{
    
    BOOL isHave = NO;
    for(UIViewController*temp in self.navigationController.viewControllers) {
        if([temp isKindOfClass:[ProjectOrderViewController class]]){
            isHave = YES;
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    if(!isHave){
        ProjectOrderViewController* vc = [[ProjectOrderViewController alloc] init];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)textFieldValueChanged:(UITextField *)textField{
    if(textField.tag==100||textField.tag==101||textField.tag==104||textField.tag==200||textField.tag==201||textField.tag==203){
        if(textField.tag==100){
            _xinjinNum = [textField.text doubleValue];
        }else if(textField.tag==101){
            _shuakaNum = [textField.text doubleValue];
        }else if(textField.tag==104){
            _zhuanzhangNum = [textField.text doubleValue];
        }else if(textField.tag ==200){
            _guazhangNum = [textField.text doubleValue];
        }else if(textField.tag==201){
            _wxNum = [textField.text doubleValue];
            
        }else if(textField.tag==203){
            _zfbNum = [textField.text doubleValue];
        }
        double other = _xinjinNum+_shuakaNum+_zhuanzhangNum+_guazhangNum+_wxNum+_zfbNum;
        double ysje = [_shouyinModel.zje doubleValue];
        double shengYuTotal = ysje - other >0? (ysje - other):0;
        //未分配
        UILabel* wfpLabel = [self.tableView viewWithTag:300];
        wfpLabel.text = [NSString stringWithFormat:@"未分配:%.2f",shengYuTotal];
    }else {
        if(textField.tag==205){
            _yskNum = [textField.text doubleValue];
        }else if(textField.tag==206){
            _ycbNum = [textField.text doubleValue];
        }else if(textField.tag==106){
            _vipNum = [textField.text doubleValue];
        }else if(textField.tag == 105){
            _vipCard = textField.text;
        }
    }
   
    
}

-(void)initData{
    __weak ProjectShouYinViewController* safeSelf = self;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getRateInfo:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.ratesData = result;
        }
        for (int i=0; i<self.ratesData.count; i++) {
            RateModel* model = [self.ratesData objectAtIndex:i];
            if([model.name rangeOfString:@"支付宝"].location!=NSNotFound){
                safeSelf.zfbRate = model.setup2;
            }else if([model.name rangeOfString:@"微信"].location!=NSNotFound){
                safeSelf.wxRate = model.setup2;
            }else{
                EBDropdownListItem* item = [[EBDropdownListItem alloc] initWithItem:[NSString stringWithFormat:@"%d",i] itemName:model.setup1];
                [safeSelf.dataSource addObject:item];
            }
           
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getRealShouyinData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            safeSelf.errorMsg = errorMsg;
        }else{
            safeSelf.shouyinModel = result;
        }
        dispatch_group_leave(group);
     

    }];
    
    //通知更新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [safeSelf.progress hideAnimated:YES];
       
        [safeSelf.tableView reloadData];
    });
}



-(void)getRateInfo:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_down_poundage";//车间管理
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [RateModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",array);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取收银数据
-(void)showAllMoney:(asyncCallback)callback vipCard:(NSString*)vipcard_no{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_get_vipcard_money";//车间管理
    dict[@"vipcard_no"] = vipcard_no;

    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSString* vipMoney = [responseObject objectForKey:@"vipcard_money"];
            callback(@"",vipMoney);

        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma 获取收银数据
-(void)getRealShouyinData:(asyncCallback)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_get_settle_accounts_info";//车间管理
    dict[@"jsd_id"] = _model.jsd_id;
    
    [HttpRequestManager HttpPostCallBack:@"/restful/pro" Parameters:dict success:^(id  _Nonnull responseObject) {
        
        if([[responseObject objectForKey:@"state"] isEqualToString:@"ok"]){
            NSMutableArray *items = [responseObject objectForKey:@"data"];
            NSMutableArray* array = [ShouyinModel mj_objectArrayWithKeyValuesArray:items] ;
            callback(@"",[array objectAtIndex:0]);
            
        }else{
            NSString* msg = [responseObject objectForKey:@"msg"];
            callback(msg,nil);
        }
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

#pragma mark - Getters
- (NSMutableArray *)ratesData
{
    if (!_ratesData) {
        _ratesData = [NSMutableArray array];
    }
    return _ratesData;
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
