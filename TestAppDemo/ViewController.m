//
//  ViewController.m
//  TestAppDemo
//
//  Created by 黎鹏 on 2019/6/3.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "ViewController.h"
#import "LoginController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void) createUI
{

    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(150, 100, 200, 100);
    label.text = @"掌上修";
     UIFont *font = [UIFont systemFontOfSize:40];
    label.font = font;
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    [self performSelector:@selector(toNextPage) withObject:nil afterDelay:3.0];
    
    
    
}
-(void) toNextPage{
    LoginController* loginPage = [[LoginController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginPage];
    loginPage.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#F0F0F0"];
    
    [self presentViewController:navController animated:YES completion:nil];

    
    [self.navigationController pushViewController:loginPage animated:YES];//从当前界面到nextVC这个界面
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
