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

NS_ASSUME_NONNULL_BEGIN

@interface DataBaseTool : NSObject

@property (nonatomic, strong) FMDatabase *db;
@property(nonatomic,strong)FMDatabaseQueue *queue;

+(instancetype )shareInstance;

- (void)insertCarListData:(NSArray *)array;

-(NSMutableArray *)querySearchCarListData:(NSString*)param;

-(int)querySearchListNum;


-(NSMutableArray*)queryCarListData:(NSString*)param isLike:(BOOL) like;

-(void)insertCarInfo:(CarInfoModel*)item;

-(void)updateCarInfo:(CarInfoModel*)item;
@end

NS_ASSUME_NONNULL_END
