//
//  ToolsObject.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ToolsObject.h"
@implementation ToolsObject



// 验证电话号码
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,171,182,183,184,187,188,147,178
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */    //^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$
    NSString * MOBILE = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(171)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */   //^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$
    NSString * CM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */  //  ^1((33|53|8[09])[0-9]|349)\\d{7}$
    NSString * CT = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -- 不带图片的提示框
+(void)show:(NSString *)title
       With:(UIViewController *)controller
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.labelFont = Font(14);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0f];
    
}
//加载框

+(MBProgressHUD *)showLoading:(NSString *)title with:(UIViewController *)contoller{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:contoller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = title;
    hud.labelFont = Font(14);
    hud.labelColor =SetColor(@"#111111", 1.0);
    hud.removeFromSuperViewOnHide = YES;
    //    [hud hide:YES afterDelay:1.0f];
    return hud;
}

@end
