//
//  DataBaseTool.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/12.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "DataBaseTool.h"
@implementation DataBaseTool


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"my_database.db"];
        //        NSLog(@"%@", dbPath);
        NSLog(@"%@",dbPath);
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        _db = [FMDatabase databaseWithPath:dbPath];//创建数据库
#ifdef DEBUG // 调试状态
        _db.logsErrors = YES;//错误信息自动打印
#else // 发布状态
        _db.logsErrors = NO;//错误信息自动打印关闭
#endif
        //使用数据库之前打开数据库
        if ([_db open]) {
            NSLog(@"open database successed");
        }
        
        NSString* sql = @"create table car_info(id integer primary key autoincrement, cjhm varchar, custom5 varchar,customer_id varchar,cx varchar,cz varchar,fdjhm varchar,linkman varchar,mc varchar,mobile varchar,ns_date varchar,openid varchar,phone varchar,gzms varchar,gls varchar,memo varchar,keys_no varchar,vipnumber varchar)";
        if (![_db executeUpdate:sql]) {
            NSLog(@"car_info创建失败");
        }
        NSString* sqlRepair = @"create table repair_info(id integer primary key autoincrement, xlz varchar, xlg varchar)";
        if (![_db executeUpdate:sqlRepair]) {
            NSLog(@"repair_info创建失败");
        }
        NSString* sqlFirstIcon = @"create table first_icon(id integer primary key autoincrement, imageurl varchar, wxgz varchar)";
        if (![_db executeUpdate:sqlFirstIcon]) {
            NSLog(@"first_icon创建失败");
        }
        NSString* sqlSeconndIcon = @"create table second_icon(id integer primary key autoincrement, cx varchar, is_quick_project varchar,lb varchar,mc varchar,pgzgs varchar,pycode varchar,spj varchar,tybz varchar,wxgz varchar,xlf varchar)";
        if (![_db executeUpdate:sqlSeconndIcon]) {
            NSLog(@"second_icon创建失败");
        }
        NSString* sqlPartsInfo = @"create table parts_info(id integer primary key autoincrement, pjbm varchar, pjmc varchar,ck varchar,cd varchar,cx varchar,dw varchar,cangwei varchar,bz varchar,type varchar,kcl varchar,xsj varchar,pjjj varchar)";
        if (![_db executeUpdate:sqlPartsInfo]) {
            NSLog(@"parts_info创建失败");
        }
        NSString* sqlManagerInfo = @"create table manager_info(id integer primary key autoincrement, assign varchar, cjhm varchar,jsd_id varchar,cp varchar,cx varchar,jc_date varchar,states varchar,wxgz varchar,xlg varchar,jcr varchar,ywg_date varchar)";
        if (![_db executeUpdate:sqlManagerInfo]) {
            NSLog(@"manager_info创建失败");
        }
    }
    return self;
}

+(instancetype)shareInstance
{
    static DataBaseTool *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [DataBaseTool new];
    });
    return _sharedManager;
}

//插入carInfo
-(void)insertCarInfo:(CarInfoModel*)item{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            BOOL res = [_db executeUpdate:@"INSERT INTO car_info(cjhm, custom5,customer_id,cx,cz,fdjhm,linkman,mc,mobile,ns_date,openid,phone,gzms,gls,memo,keys_no,vipnumber) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",item.cjhm,item.custom5,item.customer_id,item.cx,item.cz,item.fdjhm,item.linkman,item.mc,item.mobile,item.ns_date,item.openid,item.phone,item.gzms,item.gls,item.memo,item.keys_no,item.vipnumber];
            if (!res) {
                NSLog(@"录入失败");
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}

//更新carInfo
-(void)updateCarInfo:(CarInfoModel*)item{
    if ([_db open]) {
        [_db beginTransaction];
        NSString* sql = [NSString stringWithFormat:@"update car_info set cjhm='%@',custom5='%@',customer_id='%@',cx='%@',cz='%@',fdjhm='%@',linkman='%@',mobile='%@',ns_date='%@',openid='%@',phone='%@',gzms='%@',gls='%@',memo='%@',keys_no='%@',vipnumber='%@' where mc = '%@'",item.cjhm,item.custom5,item.customer_id,item.cx,item.cz,item.fdjhm,item.linkman,item.mobile,item.ns_date,item.openid,item.phone,item.gzms,item.gls,item.memo,item.keys_no,item.vipnumber,item.mc];
        BOOL isRollBack = NO;
        @try {
//            BOOL res = [_db executeUpdate:@"update car_info set cjnm='%@',custom5='%@',customer_id='%@',cx='%@',cz='%@',fdjhm='%@',linkman='%@',mobile='%@',ns_date='%@',openid='%@',phone='%@',gzms='%@',gls='%@',memo='%@',keys_no='%@',vipnumber='%@' where mc = '%@'",item.cjhm,item.custom5,item.customer_id,item.cx,item.cz,item.fdjhm,item.linkman,item.mobile,item.ns_date,item.openid,item.phone,item.gzms,item.gls,item.memo,item.keys_no,item.vipnumber,item.mc];//修改失败
            BOOL res = [_db executeUpdate:sql];
            if (!res) {
                NSLog(@"更新失败");
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}

-(void)insertCarListData:(NSArray *)array{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
//            if(refresh){
//                NSString* sql = [NSString stringWithFormat:@"delete from car_info"];
//                [_db executeUpdate:sql];
//            }
            for(int i=0;i<array.count;i++){
                CarInfoModel* item = (CarInfoModel*)[array objectAtIndex:i];
                BOOL res = [_db executeUpdate:@"INSERT INTO car_info(cjhm, custom5,customer_id,cx,cz,fdjhm,linkman,mc,mobile,ns_date,openid,phone,gzms,gls,memo,keys_no,vipnumber) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",item.cjhm,item.custom5,item.customer_id,item.cx,item.cz,item.fdjhm,item.linkman,item.mc,item.mobile,item.ns_date,item.openid,item.phone,item.gzms,item.gls,item.memo,item.keys_no,item.vipnumber];
                if (!res) {
                    NSLog(@"录入失败");
                }
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
    
}

//搜索汽车列表
-(NSMutableArray *)querySearchCarListData:(NSString*)param{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString* sql = @"select * from car_info";
    
    if(![param isEqualToString:@""]&&param!=NULL){
        //模糊查询需要转义
        sql = [NSString stringWithFormat:@"select * from car_info where mc like '%%%@%%' or mobile like '%%%@%%' or vipnumber like '%%%@%%'",param,param,param];
    }
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            CarInfoModel* bean = [[CarInfoModel alloc] init];
            bean.ID = [cursor intForColumn:@"id"];
            bean.cjhm = [cursor stringForColumn:@"cjhm"];
            bean.custom5 = [cursor stringForColumn:@"custom5"];
            bean.customer_id = [cursor stringForColumn:@"customer_id"];
            bean.cx = [cursor stringForColumn:@"cx"];
            bean.cz = [cursor stringForColumn:@"cz"];
            bean.fdjhm = [cursor stringForColumn:@"fdjhm"];
            bean.linkman = [cursor stringForColumn:@"linkman"];
            bean.mc = [cursor stringForColumn:@"mc"];
            bean.mobile = [cursor stringForColumn:@"mobile"];
            bean.ns_date = [cursor stringForColumn:@"ns_date"];
            bean.openid = [cursor stringForColumn:@"openid"];
            bean.phone = [cursor stringForColumn:@"phone"];
            bean.vipnumber = [cursor stringForColumn:@"vipnumber"];
            bean.gzms = [cursor stringForColumn:@"gzms"];
            bean.gls = [cursor stringForColumn:@"gls"];
            bean.memo = [cursor stringForColumn:@"memo"];
            bean.keys_no = [cursor stringForColumn:@"keys_no"];
            [array addObject:bean];
        }
    }
    [_db close];
    
    return array;
}

-(int)querySearchListNum{
    int count = 0;
    if ([_db open]) {
        FMResultSet *result = [_db executeQuery:@"select count(*) from car_info"];
        if([result next]){
            count = [result intForColumnIndex:0];
        }
    }
    [_db close];
    return count;
}

/*
 islike  模糊查询
 */
-(NSMutableArray*)queryCarListData:(NSString*)param isLike:(BOOL) like{
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql = @"select * from car_info";
    if(![param isEqualToString:@""]&&param!=NULL){
        //模糊查询需要转义
        sql = [NSString stringWithFormat:@"select * from car_info where mc like '%%%@%%' limit 50 offset 0",param];
    }
    if(!like){
        sql = [NSString stringWithFormat:@"select * from car_info where mc ='%@' limit 50 offset 0",param];
    }
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            CarInfoModel* bean = [[CarInfoModel alloc] init];
            bean.ID = [cursor intForColumn:@"id"];
            bean.cjhm = [cursor stringForColumn:@"cjhm"];
            bean.custom5 = [cursor stringForColumn:@"custom5"];
            bean.customer_id = [cursor stringForColumn:@"customer_id"];
            bean.cx = [cursor stringForColumn:@"cx"];
            bean.cz = [cursor stringForColumn:@"cz"];
            bean.fdjhm = [cursor stringForColumn:@"fdjhm"];
            bean.linkman = [cursor stringForColumn:@"linkman"];
            bean.mc = [cursor stringForColumn:@"mc"];
            bean.mobile = [cursor stringForColumn:@"mobile"];
            bean.ns_date = [cursor stringForColumn:@"ns_date"];
            bean.openid = [cursor stringForColumn:@"openid"];
            bean.phone = [cursor stringForColumn:@"phone"];
            bean.vipnumber = [cursor stringForColumn:@"vipnumber"];
            bean.gzms = [cursor stringForColumn:@"gzms"];
            bean.gls = [cursor stringForColumn:@"gls"];
            bean.memo = [cursor stringForColumn:@"memo"];
            bean.keys_no = [cursor stringForColumn:@"keys_no"];
            [array addObject:bean];
        }
    }
    [_db close];
    return array;
}

#pragma 查询维修工种
-(NSMutableArray*)queryWxgzList:(NSString*)states{
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql = @"select distinct wxgz from manager_info where 1=1";
    if(![states isEqualToString:@""]){
        sql = [NSString stringWithFormat:@"%@ and states = '%@'",sql,states];
    }
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            NSString* wxgz = [cursor stringForColumn:@"wxgz"];
            if(wxgz!=nil&&![wxgz isEqualToString:@""]){
                [array addObject:wxgz];

            }
        }
    }
    [_db close];

    return array;

}

-(NSMutableArray*)queryManagerList:(NSString*)cp wxgz:(NSString*)wxgz assgin:(NSString*)assgin orderStr:(NSString*)orderStr states:(NSString*)states{
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql = @"select * from manager_info where 1=1";
    if(![assgin isEqualToString:@""]&&assgin!=NULL){
        sql = [NSString stringWithFormat:@"%@ and (assign like '%%%@%%' or xlg like '%%%@%%')",sql,assgin,assgin];
    }
    if(![wxgz isEqualToString:@"全部"]&&![wxgz isEqualToString:@""]&&wxgz!=NULL){
        sql = [NSString stringWithFormat:@"%@ and wxgz like '%%%@%%'",sql,wxgz];
    }
    
    if(![cp isEqualToString:@""]&&cp!=NULL){
        sql = [NSString stringWithFormat:@"%@ and cp like '%%%@%%'",sql,cp];
    }
    
    if(![states isEqualToString:@""]&&states!=NULL){
        sql = [NSString stringWithFormat:@"%@ and states = '%@'",sql,states];
    }
    
    if(![orderStr isEqualToString:@""]&&orderStr!=NULL){
        sql = [NSString stringWithFormat:@"%@ order by %@",sql,orderStr];
    }
    
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            ManageInfoModel* bean = [[ManageInfoModel alloc] init];
            bean.assign = [cursor stringForColumn:@"assign"];
            bean.cjhm = [cursor stringForColumn:@"cjhm"];
            bean.cp = [cursor stringForColumn:@"cp"];
            bean.cx = [cursor stringForColumn:@"cx"];
            bean.jc_date = [cursor stringForColumn:@"jc_date"];
            bean.jsd_id = [cursor stringForColumn:@"jsd_id"];
            bean.states = [cursor stringForColumn:@"states"];
            bean.wxgz = [cursor stringForColumn:@"wxgz"];
            bean.xlg = [cursor stringForColumn:@"xlg"];
            bean.ywg_date = [cursor stringForColumn:@"ywg_date"];
            bean.jcr = [cursor stringForColumn:@"jcr"];
            [array addObject:bean];
        }
    }
    [_db close];

    return array;

    
}


#pragma 插入管理信息

-(void)insertManagerListData:(NSArray *)array states:(NSString*)states{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            //删除当前状态的本地数据
            NSString* sql = [NSString stringWithFormat:@"delete from manager_info where states = '%@'",states];
            [_db executeUpdate:sql];
            for(int i=0;i<array.count;i++){
                ManageInfoModel* item = (ManageInfoModel*)[array objectAtIndex:i];
                BOOL res = [_db executeUpdate:@"INSERT INTO manager_info(assign,cjhm,cp,cx,jc_date,jsd_id,states,wxgz,xlg,ywg_date,jcr) VALUES (?,?,?,?,?,?,?,?,?,?,?)",item.assign,item.cjhm,item.cp,item.cx,item.jc_date,item.jsd_id,item.states,item.wxgz,item.xlg,item.ywg_date,item.jcr];
                if (!res) {
                    NSLog(@"录入失败");
                }
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}

#pragma 插入一级页面数据列表
-(void)insertFirstIconListData:(NSArray *)array{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            //删除当前状态的本地数据
            NSString* sql = [NSString stringWithFormat:@"delete from first_icon"];
            [_db executeUpdate:sql];
            for(int i=0;i<array.count;i++){
                FirstIconInfoModel* item = (FirstIconInfoModel*)[array objectAtIndex:i];
                sql = [NSString stringWithFormat:@"INSERT INTO first_icon(imageurl,wxgz) VALUES ('%@','%@')",item.imageurl,item.wxgz];
                BOOL res = [_db executeUpdate:sql];
                if (!res) {
                    NSLog(@"录入失败");
                }
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}

#pragma 插入一级页面数据列表
-(void)insertSecondIconListData:(NSArray *)array{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            //删除当前状态的本地数据
            NSString* sql = [NSString stringWithFormat:@"delete from second_icon"];
            [_db executeUpdate:sql];
            for(int i=0;i<array.count;i++){
                SecondIconInfoModel* item = (SecondIconInfoModel*)[array objectAtIndex:i];
                sql = [NSString stringWithFormat:@"INSERT INTO second_icon(cx,wxgz,is_quick_project,mc,pgzgs,pycode,spj,tybz,xlf,lb) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.cx,item.wxgz,item.is_quick_project,item.mc,item.pgzgs,item.pycode,item.spj,item.tybz,item.xlf,item.lb];
                BOOL res = [_db executeUpdate:sql];
                if (!res) {
                    NSLog(@"录入失败");
                }
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}

#pragma 获取一级页面图标
-(NSMutableArray*)queryFirstIconListData{
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql = @"select * from first_icon where 1=1";
    
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            FirstIconInfoModel* bean = [[FirstIconInfoModel alloc] init];
            bean.ID = [cursor intForColumn:@"id"];
            bean.imageurl = [cursor stringForColumn:@"imageurl"];
            bean.wxgz = [cursor stringForColumn:@"wxgz"];
            [array addObject:bean];
        }
    }
    [_db close];
    return array;
}

#pragma 获取二级页面图标
-(NSMutableArray*)querySecondIconListData:(NSString* )wxgz{
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql = @"select * from second_icon where 1=1";
    if(![wxgz isEqualToString:@""]){
        sql = [NSString stringWithFormat:@"%@ and wxgz = '%@'",sql,wxgz];
    }
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            SecondIconInfoModel* bean = [[SecondIconInfoModel alloc] init];
            bean.ID = [cursor intForColumn:@"id"];
            bean.cx = [cursor stringForColumn:@"cx"];
            bean.is_quick_project = [cursor stringForColumn:@"is_quick_project"];
            bean.mc = [cursor stringForColumn:@"mc"];
            bean.pgzgs = [cursor stringForColumn:@"pgzgs"];
            bean.pycode = [cursor stringForColumn:@"pycode"];
            bean.spj = [cursor stringForColumn:@"spj"];
            bean.tybz = [cursor stringForColumn:@"tybz"];
            bean.wxgz = [cursor stringForColumn:@"wxgz"];
            bean.xlf = [cursor stringForColumn:@"xlf"];
            [array addObject:bean];
        }
    }
    [_db close];
    return array;
}



#pragma 插入修理数据
-(void)insertRepairListData:(NSArray *)array{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            //删除当前状态的本地数据
            NSString* sql = [NSString stringWithFormat:@"delete from repair_info"];
            [_db executeUpdate:sql];
            for(int i=0;i<array.count;i++){
                RepairInfoModel* item = (RepairInfoModel*)[array objectAtIndex:i];
                BOOL res = [_db executeUpdate:@"INSERT INTO repair_info(xlg,xlz) VALUES (?,?)",item.xlg,item.xlz];
                if (!res) {
                    NSLog(@"录入失败");
                }
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}

#pragma 插入配件数据
-(void)insertPartsListData:(NSArray *)array{
    if ([_db open]) {
        [_db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            //删除当前状态的本地数据
            NSString* sql = [NSString stringWithFormat:@"delete from parts_info"];
            [_db executeUpdate:sql];
            for(int i=0;i<array.count;i++){
                PartsModel* item = (PartsModel*)[array objectAtIndex:i];
                BOOL res = [_db executeUpdate:@"INSERT INTO parts_info(pjbm,pjmc,ck,cd,cx,dw,cangwei,bz,type,kcl,xsj,pjjj) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",item.pjbm,item.pjmc,item.ck,item.cd,item.cx,item.dw,item.cangwei,item.bz,item.type,item.kcl,item.xsj,item.pjjj];
                if (!res) {
                    NSLog(@"录入失败");
                }
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        } @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    }
    [_db close];
}


#pragma 查询配件列表
-(NSMutableArray*)queryPartsListData:(NSString*)pjmc{
    NSMutableArray *array = [NSMutableArray array];
    NSString* sql = @"select * from parts_info where 1=1";
    
    if(![pjmc isEqualToString:@""]&&pjmc!=NULL){
        sql = [NSString stringWithFormat:@"%@ and pjmc like '%%%@%%'",sql,pjmc];
    }
    
    if ([_db open]) {
        FMResultSet *cursor = [_db executeQuery:sql];
        while([cursor next]){
            PartsModel* bean = [[PartsModel alloc] init];
            bean.pjbm = [cursor stringForColumn:@"pjbm"];
            bean.pjmc = [cursor stringForColumn:@"pjmc"];
            bean.ck = [cursor stringForColumn:@"ck"];
            bean.cd = [cursor stringForColumn:@"cd"];
            bean.cx = [cursor stringForColumn:@"cx"];
            bean.dw = [cursor stringForColumn:@"dw"];
            bean.cangwei = [cursor stringForColumn:@"cangwei"];
            bean.bz = [cursor stringForColumn:@"bz"];
            bean.type = [cursor stringForColumn:@"type"];
            bean.kcl = [cursor stringForColumn:@"kcl"];
            bean.xsj = [cursor stringForColumn:@"xsj"];
            bean.pjjj = [cursor stringForColumn:@"pjjj"];
            [array addObject:bean];
        }
    }
    [_db close];
    return array;
}
@end
