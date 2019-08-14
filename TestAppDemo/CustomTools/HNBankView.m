//
//  HNBankView.m
//  PrettyGirlShow
//
//  Created by HN on 2016/11/4.
//  Copyright © 2016年 Red-bird-OfTMZ. All rights reserved.
//

#import "HNBankView.h"
#import "ZXBHeader.h"
@implementation HNBankView

-(id)initWithBankViewFrame:(CGRect)frame withImage:(NSString *)imageName withMessgess:(NSString *)msg{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = radioBGColorf5;
        [self createViewImage:imageName withMessgess:msg];
    }
    return self;
}
-(void)createViewImage:(NSString *)imageName withMessgess:(NSString *)msg{
    
     _picImageView= [[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-130*PXSCALE)/2.0, 150*PXSCALEH, 160*PXSCALE, 125*PXSCALE)];
    _picImageView.image = [UIImage imageNamed:imageName];
    [self addSubview:_picImageView];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _picImageView.frame.origin.y+_picImageView.bounds.size.height+15*PXSCALEH, kScreenWidth, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColorHexFromRGB(0x999999);
    _titleLabel.font = Font(15);
    _titleLabel.text = msg;
    
    [self addSubview:_titleLabel];
    self.agreenBut =[UIButton buttonWithType:UIButtonTypeCustom];
    self.agreenBut.frame = CGRectMake((kScreenWidth - 100*PXSCALE)/2, CGRectGetMaxY(_titleLabel.frame)+10, 100*PXSCALE,35);
    [self.agreenBut setTitle:@"点击刷新" forState:UIControlStateNormal];
    self.agreenBut.titleLabel.font = Font(15);
    [self.agreenBut setTitleColor:UIColorHexFromRGB(0x999999) forState:UIControlStateNormal];
    self.agreenBut.layer.masksToBounds = YES;
    self.agreenBut.layer.cornerRadius = 5;
    self.agreenBut.layer.borderWidth = 1;
    self.agreenBut.layer.borderColor =UIColorHexFromRGB(0x999999).CGColor;
    [self.agreenBut addTarget:self action:@selector(agreenButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.agreenBut];
  
}

- (void)agreenButClick:(UIButton*)sender
{
    if (self.agreenButBack) {
        
        self.agreenButBack();
    }
}


@end
