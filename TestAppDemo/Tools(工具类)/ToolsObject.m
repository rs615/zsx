//
//  ToolsObject.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/13.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ToolsObject.h"
#import "ZXBHeader.h"
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

//字符串转日期
+(NSDate *)stringToDate:(NSString *)dateStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:dateStr];
    return inputDate;
}

//设置border
+(void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

#pragma mark  保存uid到本地
+ (void)saveDataSouceName:(NSString *)dataSourceName
{
    [[NSUserDefaults standardUserDefaults] setObject:dataSourceName forKey:DATA_SOURCE_NAME];
}


+ (NSString *)getDataSouceName
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:DATA_SOURCE_NAME];
}

+ (void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USERNAME];
}

+ (NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:USERNAME];
}

+ (NSString *)getPasword
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
}


+ (void)savePassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:PASSWORD];
}

+ (NSString *)getFactoryName
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:FACTORYNAME];
}


+ (void)saveFactoryName:(NSString *)factory
{
    [[NSUserDefaults standardUserDefaults] setObject:factory forKey:FACTORYNAME];
}

+ (NSString *)getCompCode
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:COMP_CODE];
}


+ (void)saveCompCode:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:COMP_CODE];
}


+ (NSString *)getChineseName
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:CHINESE_NAME];
}


+ (void)saveChineseName:(NSString *)chineseName
{
    [[NSUserDefaults standardUserDefaults] setObject:chineseName forKey:CHINESE_NAME];
}


+ (BOOL)isHasLogin
{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:HASLOGIN] boolValue];
}


+ (void)saveHaseLogin:(BOOL)hasLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:hasLogin] forKey:HASLOGIN];
}

//获取字符串大小
+(CGRect)getStringFrame:(NSString *)str withFont:(NSInteger)fontSize withMaxSize:(CGSize)size{
    
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font(fontSize)} context:nil];
    return rect;
}
@end
