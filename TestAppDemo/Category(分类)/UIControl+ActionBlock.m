//
//  UIControl+ActionBlock.m
//  PrettyGirlShow
//
//  Created by 熊彬 on 16/4/8.
//  Copyright © 2016年 龙晓东. All rights reserved.
//

#import "UIControl+ActionBlock.h"
#import <objc/runtime.h>

@implementation UIControl (ActionBlock)

static const char Associatedkey;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ControlActionBlock)block {
    
    objc_setAssociatedObject(self, &Associatedkey, block, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ControlActionBlock block = objc_getAssociatedObject(self, &Associatedkey);
    if (block) {
        block(sender);
    }
}


@end
