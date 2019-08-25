//
//  ProjectJiesuanViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/21.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ProjectJiesuanViewController.h"

@interface ProjectJiesuanViewController ()
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *progress;

@end

@implementation ProjectJiesuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"结算" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
       
        return cell;
        
    }else if(indexPath.section==1){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       
        return cell;
    }
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 290*PXSCALEH;
        
    }else{
        return 270*PXSCALEH;
        
    }
}


-(void)initData{
    
}

@end
