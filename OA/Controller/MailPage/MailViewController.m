//
//  MailViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MailViewController.h"
#import "NavTabBarController.h"
#import "MailListViewController.h"
#import "MailDetailViewController.h"


@interface MailViewController ()<NavTabBarControllerDelegate,MailListDelegate>{
    BOOL _inBoxSelected;
    BOOL _outBoxSelected;
    BOOL _draftBoxSelected;
    BOOL _dustinBoxSelected;

}

@property (nonatomic,strong)NSNotification *notification;

@property (nonatomic,strong)NSNotification *deleteNotification;


@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,assign) BOOL isSelected;

@end

@implementation MailViewController
{
    NavTabBarController *tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isSelected = NO;
    self.notification =[NSNotification notificationWithName:@"mailNotification" object:nil userInfo:nil];
    self.deleteNotification = [NSNotification notificationWithName:@"maildeleteNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle:) name:@"changeTitleNotification" object:nil];
    [self changeBarItem];

    tab=[[NavTabBarController alloc]init];
    tab.delegate = self;
    
    MailListViewController *INBOXVC=[[MailListViewController alloc]init];
    INBOXVC.title=@"收件箱";
    INBOXVC.BoxType = Inbox;
    
    MailListViewController *OUTBOXVC=[[MailListViewController alloc]init];
    OUTBOXVC.title=@"发件箱";
    OUTBOXVC.BoxType = Outbox;

    MailListViewController *DRAFTVC=[[MailListViewController alloc]init];
    DRAFTVC.title=@"草稿箱";
    DRAFTVC.BoxType = Draftbox;
    
    MailListViewController *DUSTINTVC=[[MailListViewController alloc]init];
    DUSTINTVC.title=@"垃圾箱";
    DUSTINTVC.delegate= self;
    DUSTINTVC.BoxType = Dusbinbox;
    
    tab.subViewControllers=@[INBOXVC,OUTBOXVC,DRAFTVC,DUSTINTVC];
    tab.showArrowButton=false;
    tab.navItemSelectColor = redBack;
    tab.navTabBarLineColor = redBack;
    tab.navTabBarColor = [UIColor whiteColor];
    tab.navItemDefaultColor = [UIColor blackColor];
    tab.isHaveNAVIGATION_BAR = YES;
    tab.NavgationBottomBarHeight=44;
    tab.BarMargin=0;
    [tab addParentController:self];
    
    tab.CurrentPageIndex=0;
}

- (void)edit{
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%zd",tab.currentIndex] forKey:@"dd"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mailNotification" object:nil userInfo:dic];
    switch (tab.currentIndex) {
        case 0:
            _inBoxSelected = !_inBoxSelected;
            NSLog(@"收件箱状态%d",_inBoxSelected);
            [self changeBarItem];
            break;
        case 1:
            _outBoxSelected = !_outBoxSelected;
            NSLog(@"发件箱箱状态%d",_outBoxSelected);

            [self changeBarItem];
            break;
        case 2:
            _draftBoxSelected = !_draftBoxSelected;
            NSLog(@"草稿箱状态%d",_draftBoxSelected);

            [self changeBarItem];
            break;
        case 3:
            _dustinBoxSelected = !_dustinBoxSelected;
            NSLog(@"垃圾箱状态%d",_dustinBoxSelected);

            [self changeBarItem];
            break;
        default:
            break;
    }
    
}
- (void)changeBarItem{
    switch (tab.currentIndex) {
        case 0:{
            if (!_inBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        case 1:{
            if (!_outBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        case 2:{
            if (!_draftBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        case 3:{
            if (!_dustinBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        default:
            break;
    }
}

- (void)changeTitle:(NSNotification *)dic{
    switch ([dic.userInfo[@"type"] intValue]) {
        case 0:
            if ([dic.userInfo[@"count"] integerValue] >0) {
                [tab SetNavTitleWithIndex:0 Title:[NSString stringWithFormat:@"收件箱(%d)",[dic.userInfo[@"count"] intValue]]];
                tab.CurrentPageIndex=0;
            }else{
                [tab SetNavTitleWithIndex:0 Title:@"收件箱"];
                tab.CurrentPageIndex=0;
            }
            
            break;
        case 1:
        case 2:
        case 3:
        default:
            break;
    }
//    tab SetNavTitleWithIndex:[dic.userInfo[@"type"] intValue] Title:[NSString stringWithFormat:@""]
    
}

- (void)editBar{
   UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    [leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftItem,negativeSpacer, nil];

    UIBarButtonItem *negative = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negative.width = -5;
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:mImageByName(@"ic_mailwrite") style:UIBarButtonItemStylePlain target:self action:@selector(writeMail)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negative, rightBtn,nil];
    }


- (void)deleteBar{
    UIBarButtonItem *leftItem= [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    [leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = 0;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightButton, nil];

}

- (void)delete{
    NSString *box= @"";
    switch (tab.currentIndex) {
        case 0:
            box = @"确认删除收件箱？";
            break;
        case 1:
            box = @"确认删除发件箱？";
            break;
        case 2:
            box = @"确认删除草稿箱？";
            break;
        case 3:
            box = @"确认删除垃圾箱？";
            break;
        default:
            break;
    }
    self.alertController = [UIAlertController alertControllerWithTitle:nil message:box preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%zd",tab.currentIndex] forKey:@"dd"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"maildeleteNotification" object:nil userInfo:dic];
        switch (tab.currentIndex) {
            case 0:
                _inBoxSelected = NO;
                break;
            case 1:
                _outBoxSelected = NO;
                break;
            case 2:
                _draftBoxSelected = NO;
                break;
            case 3:
                _dustinBoxSelected = NO;
                break;
            default:
                break;
        }
        [self changeBarItem];
    }];
    UIAlertAction *ceancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.alertController  dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.alertController  addAction:ceancle];
    [self.alertController  addAction:sure];
    
    [self presentViewController:self.alertController  animated:YES completion:nil];
}

- (void)writeMail{
    MailDetailViewController *newMail = [[MailDetailViewController alloc]init];
    newMail.hidesBottomBarWhenPushed = YES;
    newMail.mailType = WriteMail;
    [self.navigationController pushViewController:newMail animated:YES];
}


-(void)clickRecovery{
    _dustinBoxSelected = NO;
    [self changeBarItem];
}

- (void)NavTabBarControllerOnScorll:(NSInteger)pageindex{
    NSLog(@"滑动");
    switch (pageindex) {
        case 0:{
            if (!_inBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        case 1:{
            if (!_outBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        case 2:{
            if (!_draftBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        case 3:{
            if (!_dustinBoxSelected) {
                [self editBar];
            }else{
                [self deleteBar];
            }
        }
            break;
        default:
        break;
    }

}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
