//
//  HNLinkageView.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^resultBlock)(NSMutableArray* dataArray);

@interface HNLinkageView : UIView
@property (nonatomic,copy)resultBlock myBlock;
@property (nonatomic, strong) NSMutableArray *rightDataArray;

-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray*)data block:(resultBlock)block;
@end

NS_ASSUME_NONNULL_END
