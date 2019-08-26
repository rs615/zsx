//
//  DataBaseTool.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/12.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CarInfoModel.h"
#import "ManageInfoModel.h"
#import "FirstIconInfoModel.h"
#import "SecondIconInfoModel.h"
#import "RepairInfoModel.h"
#import "PartsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataBaseTool : NSObject

@property (nonatomic, strong) FMDatabase *db;
@property(nonatomic,strong)FMDatabaseQueue *queue;

+(instancetype )shareInstance;

#pragma carInfo
-(void)insertCarListData:(NSArray *)array;

-(NSMutableArray *)querySearchCarListData:(NSString*)param;

-(int)querySearchListNum;


-(NSMutableArray*)queryCarListData:(NSString*)param isLike:(BOOL) like;

-(void)insertCarInfo:(CarInfoModel*)item;

-(void)updateCarInfo:(CarInfoModel*)item;

#pragma managerInfo

-(NSMutableArray*)queryWxgzList:(NSString*)states;
-(void)insertManagerListData:(NSArray *)array states:(NSString*)states;
-(NSMutableArray*)queryManagerList:(NSString*)cp wxgz:(NSString*)wxgz assgin:(NSString*)assgin orderStr:(NSString*)orderStr states:(NSString*)states;
-(void)insertFirstIconListData:(NSArray *)array;
-(void)insertRepairListData:(NSArray *)array;
-(void)insertPartsListData:(NSArray *)array;
-(NSMutableArray*)queryPartsListData:(NSString*)pjmc;

-(NSMutableArray*)querySecondIconListData:(NSString* )wxgz;
-(NSMutableArray*)queryFirstIconListData;
-(void)insertSecondIconListData:(NSArray *)array;

-(NSMutableArray*)queryRepairListStringData;

#pragma 查询修理组
-(NSMutableArray*)queryRepairZuListData;

-(NSMutableArray*)queryRepairPersonListData:(NSString*)xlzStr;

-(void)updateSecondIconData:(SecondIconInfoModel*)item;
-(NSMutableArray*)queryWxgzList;
#pragma 更新配件数据
-(void)updatePartsInfo:(PartsModel*)item;

@end

NS_ASSUME_NONNULL_END
