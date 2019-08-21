//
//  HttpRequestManager.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/11.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HttpRequestManager.h"

#define Timeout 10

@interface HttpRequestManager ()

/**
 系统时间差值
 */
@property (assign, nonatomic) long timestampAdjust;
@property (copy, nonatomic) dispatch_block_t block;
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end
@implementation HttpRequestManager


#pragma mark - Initial
static HttpRequestManager *_instance;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.timestampAdjust = LONG_MAX;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

        manager.requestSerializer.timeoutInterval = Timeout;//请求超时
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy; //缓存策略
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];//支持类型
        _instance.manager = manager;
    });
    return _instance;
}

+(void)post:(NSString*)Url  Parameters:(NSDictionary*)dict success:(httpSuccess)success failure:(httpFailure)failure{
    NSString   *urlStr = [NSString stringWithFormat:@"%@%@",DEFULTURL,Url];
    
    AFHTTPSessionManager *manager = [HttpRequestManager shareInstance].manager;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}

#pragma mark  ===  post请求
+(void)HttpPostCallBack:(NSString*)Url  Parameters:(NSDictionary*)dict success:(httpSuccess)success failure:(httpFailure)failure
{

    NSString   *urlStr = [NSString stringWithFormat:@"%@%@",DEFULTURL,Url];
    
    AFHTTPSessionManager *manager = [HttpRequestManager shareInstance].manager;

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:urlStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure (error);
//    }];
    NSURL *url = [NSURL URLWithString:urlStr];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30];
    //设置请求方式为POST
    request.HTTPMethod = @"POST";
    //设置请求内容格式
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    //
    request.HTTPBody = jsonData;

    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@",error);
            failure(error);
            return ;
        }
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        success(object);


    }] resume];
}

#pragma mark  ==== Get请求
+ (void)HttpGetCallBack:(NSString*)Url  Parameters:(NSDictionary*)dict success:(httpSuccess)success failure:(httpFailure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    manager.requestSerializer.timeoutInterval = 25;
    manager.responseSerializer = responseSerializer;
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"JSON/text",@"text/plain", nil];
    NSString   *urlStr = [NSString stringWithFormat:@"%@%@",DEFULTURL,Url];
    
    [manager GET:urlStr parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // NSLog(@"---->>%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        if (error) {
            //            [[JHAlertView alertView] jhShow:error];
        }
#endif
        failure(error);
    }];
}

@end
