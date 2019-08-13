//
//  UIControl+ActionBlock.h
//  UIViewDemo
//
//  Created by 熊彬 on 16/4/8.
//  Copyright © 2016年 龙晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControlActionBlock) (id sender);

@interface UIControl (ActionBlock)

- (void) handleControlEvent:(UIControlEvents)event withBlock:(ControlActionBlock)action;

@end
