//
//  AppDelegate.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "NavigationController.h"
#import "LoginModel.h"
#import "LoginNet.h"
#import "LoginViewController.h"


@interface AppDelegate ()<UITabBarControllerDelegate,BMKGeneralDelegate>

@property (nonatomic,strong) TabBarViewController *tabBarController;


//@property (nonatomic,strong) AccountManager *account;

@property (nonatomic,strong) LoginViewController *loginViewController;
@end

@implementation AppDelegate{
    BMKMapManager* _mapManager;

}


//-(AccountManager *)account{
//    if (!_account) {
//        _account = [AccountManager sharedManager];
//    }
//    return _account;
//}

#pragma mark - init 初始化方法 -
- (TabBarViewController*)tabBarController
{
    if (!_tabBarController) {
        _tabBarController = [[TabBarViewController alloc] init];
        _tabBarController.delegate = self;
    }
    return _tabBarController;
}

- (LoginViewController *)loginViewController{
    if (!_loginViewController) {
        _loginViewController = [[LoginViewController alloc]init];
    }
    return _loginViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduCode  generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图启动失败");
    }else{
        NSLog(@"百度地图启动成功");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"loginUser.archiver"];
    LoginModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (model) {
        [AccountManager sharedManager].uid = model.uid;
        [AccountManager sharedManager].userName = model.name;
        [AccountManager sharedManager].headImage = [[NSString stringWithFormat:@"http://www.jssuxin.net:90%@",model.imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.window.rootViewController = self.tabBarController;
    }else{
        self.window.rootViewController = self.loginViewController;
    }
    // Override point for customization after application launch.
    
    
    //IQKeyboardManager
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
    return YES;
}




/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }

}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
