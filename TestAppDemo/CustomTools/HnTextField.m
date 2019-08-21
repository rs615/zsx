//
//  HnTextField.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HnTextField.h"
#import "ZXBHeader.h"
@implementation HnTextField

- (void)drawRect:(CGRect)rect{
        // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,hotPinkColor.CGColor );
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1));
}
@end
