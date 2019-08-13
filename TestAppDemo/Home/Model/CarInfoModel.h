//
//  CarInfoModel.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/12.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarInfoModel : NSObject

@property (nonatomic , assign) int  ID;
@property (nonatomic , copy) NSString* cjhm;
@property (nonatomic , copy) NSString* custom5;
@property (nonatomic , copy) NSString* customer_id;
@property (nonatomic , copy) NSString* cx;
@property (nonatomic , copy) NSString* cz;
@property (nonatomic , copy) NSString* fdjhm;
@property (nonatomic , copy) NSString* linkman;
@property (nonatomic , copy) NSString* mc;
@property (nonatomic , copy) NSString* mobile;
@property (nonatomic , copy) NSString* ns_date;
@property (nonatomic , copy) NSString* openid;
@property (nonatomic , copy) NSString* phone;
@property (nonatomic , copy) NSString* vipnumber;
@property (nonatomic , copy) NSString* gzms;//故障描述
@property (nonatomic , copy) NSString* gls;//公里数
@property (nonatomic , copy) NSString* memo;//备注
@property (nonatomic , copy) NSString* keys_no;//钥匙编号
@property (nonatomic , copy) NSString* jsd_id;//结算单编号

@end

NS_ASSUME_NONNULL_END
