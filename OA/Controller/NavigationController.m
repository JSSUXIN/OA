//
//  NavigationController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()
@property (nonatomic,strong)UIImageView *navigationImageView;

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationBar setBarTintColor:blueBackGround];//设置navBar背景图片
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:NO]; //关闭导航栏半透明效果
    //分割线隐藏
//    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
