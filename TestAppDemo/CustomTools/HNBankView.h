//
//  HNBankView.h
//  PrettyGirlShow
//
//  Created by HN on 2016/11/4.
//  Copyright © 2016年 Red-bird-OfTMZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNBankView : UIView

-(id)initWithBankViewFrame:(CGRect)frame withImage:(NSString *)imageName withMessgess:(NSString *)msg;

@property (nonatomic,strong)UIButton  *agreenBut;

@property (nonatomic,copy) void (^agreenButBack)();

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIImageView *picImageView;
@end
