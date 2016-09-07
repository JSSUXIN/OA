//
//  LoginViewController.m
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "LoginViewController.h"
#import "ElonHTTPSession.h"
#import "LoginModel.h"
#import "LoginNet.h"
#import "TabBarViewController.h"
#import "DowmLoadAddressBook.h"



@interface LoginViewController ()
@property(nonatomic,strong)AccountManager *account;


@end


#define view_X RELATIVE_WIDTH(80)
#define view_H RELATIVE_WIDTH(90)

@implementation LoginViewController{
    UITextField *_userName;
    UITextField *_passField;
}


-(AccountManager *)account
{
    if(!_account)
    {
        _account=[AccountManager sharedManager];
    }
    return _account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backview = [[UIImageView alloc]initWithFrame:self.view.frame];
    [backview setImage:mImageByName(@"ic_login_background")];
    [self.view addSubview:backview];

    UIImageView *loginView = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(200), RELATIVE_WIDTH(300), RELATIVE_WIDTH(200), RELATIVE_WIDTH(200))];
    loginView.center = CGPointMake(mScreenWidth/2, loginView.center.y);
    [loginView setImage:mImageByName(@"ic_logo")];
    [self.view addSubview:loginView];
    
    
    UIView *nameBack = [[UIView alloc]initWithFrame:CGRectMake(view_X, mScreenHeight*0.6, mScreenWidth - 2*view_X, view_H)];
    nameBack.layer.cornerRadius = RELATIVE_WIDTH(5);
    nameBack.layer.borderWidth = 0.5;
    nameBack.layer.borderColor = blueBackGround.CGColor;
    [self.view addSubview:nameBack];
    
    UIView *passwordBack = [[UIView alloc]initWithFrame:CGRectMake(view_X, GG_BOTTOM_Y(nameBack) +RELATIVE_WIDTH(30), mScreenWidth - 2*view_X, view_H)];
    passwordBack.layer.cornerRadius = RELATIVE_WIDTH(5);
    passwordBack.layer.borderWidth = 0.5;
    passwordBack.layer.borderColor = blueBackGround.CGColor;
    [self.view addSubview:passwordBack];

    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(20), RELATIVE_WIDTH(60), RELATIVE_WIDTH(60))];
    userImage.image = mImageByName(@"ic_loginuser");
    userImage.center = CGPointMake(userImage.center.x, RELATIVE_WIDTH(45));
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(GG_RIGHT_X(userImage) +RELATIVE_WIDTH(30), RELATIVE_WIDTH(20), RELATIVE_WIDTH(300), RELATIVE_WIDTH(60))];
    _userName.placeholder = @"请输入用户名";
    [nameBack addSubview:_userName];
    [nameBack addSubview:userImage];
    
    
    UIImageView *passwordImage = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(20), RELATIVE_WIDTH(60), RELATIVE_WIDTH(60))];
    passwordImage.image = mImageByName(@"ic_password");
    passwordImage.center = CGPointMake(passwordImage.center.x, RELATIVE_WIDTH(45));

    _passField = [[UITextField alloc]initWithFrame:CGRectMake(GG_RIGHT_X(passwordImage)+RELATIVE_WIDTH(30), RELATIVE_WIDTH(20), RELATIVE_WIDTH(300), RELATIVE_WIDTH(60))];
    _passField.placeholder = @"请输入密码";
    _passField.secureTextEntry = YES;
    
   
    [passwordBack addSubview:passwordImage];
    [passwordBack addSubview:_passField];

    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(view_X,GG_BOTTOM_Y(passwordBack)+RELATIVE_WIDTH(60), mScreenWidth - 2*view_X, view_H)];
    loginButton.layer.cornerRadius = RELATIVE_WIDTH(5);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = blueBackGround;
    [self.view addSubview:loginButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)login{
    if ([_userName.text isEqualToString:@""] ||[_passField.text isEqualToString:@""]) {
        [MBProgressHUD showText_b:@"用户名或密码为空"];
    }else{
        [LoginNet excuteLoginWithUserName:_userName.text password:_passField.text success:^(id obj) {
            NSLog(@"登录成功");
            LoginModel *model = obj;
//            NSMutableArray *mul = [NSMutableArray arrayWithObject:model];
            NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"loginUser.archiver"];
            
            BOOL success = [NSKeyedArchiver archiveRootObject:model toFile:filePath];
            if (success) {
                NSLog(@"用户登录保存成功");
            }
            
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setObject:mul forKey:@"userInfo"];
//            [user synchronize];
            
            self.account.uid = model.uid;
            self.account.userName = model.name;
            self.account.headImage = [[NSString stringWithFormat:@"http://www.jssuxin.net:90%@",model.imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            DowmLoadAddressBook *downAddress = [[DowmLoadAddressBook alloc]init];
            [downAddress downLoadAddressBook];

            TabBarViewController *rootView = [[TabBarViewController alloc]init];
            self.view.window.rootViewController = rootView;
//            [self.navigationController pushViewController:rootView animated:YES];
            
           
        } failed:^(id obj) {
            [MBProgressHUD showText_b:@"登录失败"];
        }];
    }
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
