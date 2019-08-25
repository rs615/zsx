//
//  HNAlertView.h
//  TestAppDemo
//
//  Created by rs l on 2019/8/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^alertBlock)(NSInteger index);

@interface HNAlertView : UIView

@property (strong, nonatomic) UIView *contentView;

-(id)initWithCancleTitle:(NSString *)cancel withSurceBtnTitle:(NSString *)sureTitle WithMsg:(NSString *)msg withTitle:(NSString *)title contentView:(UIView*)content;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,copy)alertBlock myBlock;
//@property (nonatomic,assign)BOOL isAutoClose;
//-(void)showHNAlertView:(alertBlock)myblock isAudoClose:(BOOL)close;

-(void)showHNAlertView:(alertBlock)myblock;
@end
