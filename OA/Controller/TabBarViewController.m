//
//  TabBarViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationController.h"
#import "IndexViewController.h"
#import "PlanViewController.h"
#import "MailViewController.h"
#import "TelViewController.h"
#import "SignInViewController.h"
#import "LoginViewController.h"

@interface TabBarViewController ()<UINavigationControllerDelegate>

@property (nonatomic,copy) IndexViewController *indexVc;
@property (nonatomic,copy) PlanViewController *planVc;
@property (nonatomic,copy) MailViewController *mailVc;
@property (nonatomic,copy) TelViewController *telVc;
@property (nonatomic,copy) SignInViewController *signInVc;

@end

@implementation TabBarViewController

-(IndexViewController *)indexVc{
    if (!_indexVc) {
        _indexVc = [[IndexViewController alloc]init];
        _indexVc.title =@"首页";
    }
    return _indexVc;
}

-(PlanViewController *)planVc{
    if (!_planVc) {
        _planVc = [[PlanViewController alloc]init];
        _planVc.title = @"计划";
    }
    return _planVc;
}


-(MailViewController *)mailVc{
    if (!_mailVc) {
        _mailVc = [[MailViewController alloc]init];
        _mailVc.title = @"邮件";
    }
    return _mailVc;
}

-(TelViewController *)telVc{
    if (!_telVc) {
        _telVc = [[TelViewController alloc]init];
        _telVc.title=@"通讯录";
    }
    return _telVc;
}

-(SignInViewController *)signInVc{
    if (!_signInVc) {
        _signInVc = [[SignInViewController alloc]init];
        _signInVc.title = @"签到";
    }
    return _signInVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarAttribute];          //设置tabBar 的属性值
    [self setViewControllerTabBarItem]; //设置tabBar的item
    [self initNavigationBar];           //创建UINavigationController
    // Do any additional setup after loading the view.
}


#pragma mark - 构造方法 -
//创建UINavigationController
- (void)initNavigationBar
{
    NavigationController *indexPage     = [[NavigationController alloc]initWithRootViewController:self.indexVc];
    NavigationController *planPage = [[NavigationController alloc] initWithRootViewController:self.planVc];
    NavigationController *mailPage = [[NavigationController alloc] initWithRootViewController:self.mailVc];
    NavigationController *telPage = [[NavigationController alloc] initWithRootViewController:self.telVc];
    NavigationController *signinPage = [[NavigationController alloc]initWithRootViewController:self.signInVc];
    
    indexPage.delegate = self;
    planPage.delegate = self;
    mailPage.delegate = self;
    telPage.delegate = self;
    signinPage.delegate = self;
    
    self.viewControllers=@[indexPage,planPage,mailPage,telPage,signinPage];
}

//设置tabBar 的属性值
- (void)setTabBarAttribute
{
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setBarTintColor:mRGBToColor(0xf3f3f7)];//修改背景色
    [self.tabBar setOpaque:YES];
}





//设置tabBar的item
- (void)setViewControllerTabBarItem
{
    NSArray *viewControllers = @[self.indexVc,self.planVc,self.mailVc,self.telVc,self.signInVc];
    NSArray * titleArray    = @[@"首页",@"计划",@"邮件",@"通讯录",@"签到"];
    NSArray * imageArray    = @[@"ic_index_gray",@"ic_plan_gray",@"ic_mail_gray",@"ic_tel_gray",@"ic_signin_gray"];
    NSArray * selectedArray = @[@"ic_index_selected",@"ic_plan_selected",@"ic_mail_selected",@"ic_tel_selected",@"ic_signin_selected"];
    
    for (int i = 0; i < viewControllers.count; i++)
    {
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:[mImageByName(imageArray[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[mImageByName(selectedArray[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        //设置title字体属性
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: mRGBToColor(0x6d6d6d),NSForegroundColorAttributeName, [UIFont systemFontOfSize:10], NSFontAttributeName, nil] forState:UIControlStateNormal];//设置tabbar文字的颜色
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: mRGBToColor(0x007aff),NSForegroundColorAttributeName, [UIFont systemFontOfSize:10], NSFontAttributeName, nil] forState:UIControlStateSelected];//设置tabbar文字选中状态下的颜色
        
        //设置title的位置是左右偏移(horizontal) 还是上下偏移(vertical)
        [item setTitlePositionAdjustment:UIOffsetMake(0, -RELATIVE_WIDTH(3))];
        item.tag = 10000+i;
        //设置为view的item
        UIViewController * view = viewControllers[i];
        view.tabBarItem = item;
    }
}




#pragma mark - UINavigationControllerDelegate -
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray *viewControllers = [navigationController viewControllers];
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        UIViewController *controller = (UIViewController *)viewControllers[idx];
        if ([controller isKindOfClass:[LoginViewController class]])
        {
            [navigationController setNavigationBarHidden:YES animated:NO];
        }
        else
        {
            [navigationController setNavigationBarHidden:NO animated:NO];
        }
    }];
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
