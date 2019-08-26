//
//  HNAlertView.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HNAlertView.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"
@implementation HNAlertView


#pragma mark -创建白色的背景视图
-(void)createBgView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,MainS_Width-40*PXSCALEH, 200*PXSCALEH)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.center = [[UIApplication sharedApplication].delegate window].center;
    [self addSubview:_bgView];
}

-(id)initWithCancleTitle:(NSString *)cancel withSurceBtnTitle:(NSString *)sureTitle WithMsg:(NSString *)msg withTitle:(NSString *)title contentView:(UIView*)content{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    [self createBgView];
    CGFloat titleHeight = 50;
    UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(0, 0, _bgView.bounds.size.width, titleHeight) text:title fontSize:15*PXSCALE color:[UIColor whiteColor] align:@"center"];
    titleLabel.backgroundColor = [UIColor blackColor];
    [_bgView addSubview:titleLabel];
    if(content==nil){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, _bgView.bounds.size.width,(200-50-80)*PXSCALEH)];//此高度为动态定义
    }else{
        _contentView = content;
    }
    if(![msg isEqualToString:@""]){
        UILabel *msgLabel = [PublicFunction getlabel:CGRectMake(10, 10, _bgView.bounds.size.width-20,(200-50-80-20)*PXSCALEH) text:msg BGColor:nil textColor:[UIColor grayColor] size:15*PXSCALE];
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:msgLabel];
    }
    [_bgView addSubview:_contentView];
    
    _bgView.frame = CGRectMake(0, 0,_bgView.bounds.size.width, 80*PXSCALEH+50+_contentView.bounds.size.height);
    _bgView.center = [[UIApplication sharedApplication].delegate window].center;
    //98C89A
    UIView* bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0,50+_contentView.bounds.size.height, _bgView.bounds.size.width, 80*PXSCALEH)];
    bottomView.backgroundColor = SetColor(@"#E6E4E7", 1);
    //添加button
    UIButton*  leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(25*PXSCALE, 15*PXSCALEH, (_bgView.bounds.size.width-25*4)/2*PXSCALEH, (80-15*2)*PXSCALEH)];
    leftBtn.backgroundColor = SetColor(@"#98C89A", 1);
    [leftBtn setTitle:cancel forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 0;
    [bottomView addSubview:leftBtn];
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.bounds.size.width-25*PXSCALE-leftBtn.bounds.size.width, 15*PXSCALEH, leftBtn.bounds.size.width, leftBtn.bounds.size.height)];
    rightBtn.backgroundColor = SetColor(@"#98C89A", 1);
    [rightBtn setTitle:sureTitle forState:UIControlStateNormal];
    rightBtn.tag = 1;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightBtn];
    
    [_bgView addSubview:bottomView];
    return self;
}


#pragma Mark--- 省份初始化
-(id)initProviceChooseView:(NSArray *)titlesArray{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        [self creatProviceTitle:titlesArray ];
    }
    return self;
    
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    [self dismissView];
}

#pragma mark ---- 电台选择相册图片的接口
-(void)creatProviceTitle:(NSArray *)array{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    CGFloat btnWidth = (MainS_Width-40*PXSCALE)/7-5*PXSCALEH;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];

    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainS_Height-(5*btnWidth+4*5*PXSCALEH+20*PXSCALEH) ,MainS_Width,5*btnWidth+4*5*PXSCALEH+20*PXSCALEH)];

    self.bgView.backgroundColor = SetColor(@"#d9d9d9", 1.0);
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];
    //添加按钮
    NSArray* proArr = @[@"闽",@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",
                        @"沪",@"苏",@"浙",@"皖",@"赣",@"鲁",@"豫",@"鄂",
                        @"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"渝",@"藏",
                        @"陕",@"甘",@"青",@"宁",@"新",@"港",@"澳",@"台"];
    for (int i=0; i<proArr.count; i++) {
        UIButton* itemBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(i%7*(btnWidth+5*PXSCALEH)+20*PXSCALE, (i/7*(btnWidth+5*PXSCALEH)+10*PXSCALEH), btnWidth, btnWidth) title:proArr[i] align:@"center" color:[UIColor whiteColor] fontsize:14 tag:i clickAction:@selector(btnClick:)];
        itemBtn.backgroundColor = lightGreenColor;
        [_bgView addSubview:itemBtn];
    }
}




-(void)showHNAlertView:(alertBlock)myblock{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    for (UIView *vi in window.subviews)
    {
        if([vi isKindOfClass:[HNAlertView class]]){
            
            [vi removeFromSuperview];
        }
    }
    
    [window addSubview:self];
    self.myBlock = myblock;
}


//-(void)showHNAlertView:(alertBlock)myblock isAudoClose:(BOOL)close{
//
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//
//    for (UIView *vi in window.subviews)
//    {
//        if([vi isKindOfClass:[HNAlertView class]]){
//
//            [vi removeFromSuperview];
//        }
//    }
//
//    [window addSubview:self];
//    self.myBlock = myblock;
//    self.isAutoClose = close;
//}


#pragma mark -取消和确认按钮触发方法
-(void)btnClick:(UIButton *)btn{
    if (self.myBlock)
    {
        self.myBlock(btn.tag);
    }
    [self dismissView];

}

#pragma mark -消失
-(void)dismissView{
//    [HNAlertView exChangeOut:self.bgView dur:1];
    [self removeFromSuperview];
}
#pragma mark -动画
+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}

@end

