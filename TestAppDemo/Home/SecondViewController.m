//
//  SecondViewController.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/25.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "SecondViewController.h"
typedef void (^asyncCallback)(NSString* errorMsg,id result);

@interface SecondViewController ()
@property (nonatomic,strong)MBProgressHUD *progress;
@property (nonatomic,strong)UIImageView *codeImageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"二维码" withleftImage:@"back" withleftAction:@selector(backBtnClick) withRightImage:@"" rightAction:nil withVC:self];
    _codeImageView = [PublicFunction getImageView:CGRectMake((MainS_Width-150)/2, (MainS_Height-100)/2, 150, 100) imageName:@"img_wg"];
    _codeImageView.hidden = YES;
    [self.view addSubview:_codeImageView];

    [self initData:^(NSString *errorMsg, id result) {
        if(![errorMsg isEqualToString:@""]){
            [ToolsObject show:errorMsg With: self];
        }else{
            NSString* ticket = [result objectForKey:@"ticket"];
            if(ticket!=nil){
                
            }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initData:(asyncCallback)callback{
    __weak SecondViewController* safeSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"db"] = [ToolsObject getDataSouceName];
    dict[@"function"] = @"sp_fun_get_fault_info";//车间管理
    
    
    self.progress = [ToolsObject showLoading:@"加载中" with:self];
    NSString* Id = _model.Appid;
    NSString* aSet = _model.AppSecret;
    NSString* usercode = [ToolsObject getCompCode];
    NSString* nonce = @"access_token";
    //getWxInfoFromServer
    NSString* url = [NSString stringWithFormat:@"http://wxgzh.whsjsoft.com/wx/api/push?id=%@&aSet=%@&nonce=%@",Id,aSet,nonce];
    
    [HttpRequestManager HttpGetCallBack:url Parameters:nil success:^(id  _Nonnull responseObject) {
        NSString* access_token = [responseObject objectForKey:@"access_token"];
        [safeSelf getTicket:callback token:access_token code:usercode];
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}

-(void)getTicket:(asyncCallback)callback token:(NSString*)access_token code:(NSString*)user_code{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"expire_seconds"] = [NSNumber numberWithInteger:4800];
    dict[@"action_name"] = @"QR_STR_SCENE";
    dict[@"action_info"] = @{@"scene":@{@"scene_str":user_code}};
    NSString* url = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=%@",access_token];
    [HttpRequestManager HttpPostCallBack:url Parameters:dict success:^(id  _Nonnull responseObject) {
        callback(@"",responseObject);
    } failure:^(NSError * _Nonnull error) {
        callback(@"网络错误",nil);
    }];
}


@end
