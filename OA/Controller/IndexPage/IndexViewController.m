//
//  IndexViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexNet.h"
#import "IndexPictureModel.h"
#import "ImageTableViewCell.h"
#import "NoImageTableViewCell.h"
#import "NoticeNewsModel.h"
#import "ImagePlayerView.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "LoginNet.h"
#import "LoginModel.h"
#import "DowmLoadAddressBook.h"


#define heightOfImageScroll  RELATIVE_WIDTH(400)
#define heightOfButton RELATIVE_WIDTH(120)

@interface IndexViewController ()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate>{
    UIImageView *_headImageview;
    UILabel *_nameLabel;
}


@property (nonatomic,strong) AccountManager *account;
@property (nonatomic,copy) NSArray *pictureArray;
@property (nonatomic,strong)  ImagePlayerView* picView;

@property (nonatomic,strong)  UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *newsData;

@property (nonatomic,strong) NSMutableArray *noticeData;


@property (nonatomic,assign) BOOL isFirstTableView;

@property (nonatomic,assign) NSInteger pageCount;//每页显示的数量

@property (nonatomic,assign) NSInteger newsPage;//新闻页数

@property (nonatomic,assign) NSInteger noticePage;//通知页数

@property (nonatomic,strong) NSArray *ImageUrls;


@end

@implementation IndexViewController


-(NSMutableArray *)newsData{
    if (!_newsData) {
        _newsData = [[NSMutableArray alloc]init];
    }
    return _newsData;
}

-(AccountManager *)account{
    if (!_account) {
        _account = [AccountManager sharedManager];
    }
    return _account;
}


- (NSMutableArray *)noticeData{
    if (!_noticeData) {
        _noticeData = [[NSMutableArray alloc]init];
    }
    return _noticeData;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight - mTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
        
        UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];//左滑
        swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
        [_tableView addGestureRecognizer:swipeL];
        
        UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];//右滑
        swipeR.direction = UISwipeGestureRecognizerDirectionRight;
        [_tableView addGestureRecognizer:swipeR];
    }
    return _tableView;
}

-(NSArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [NSArray array];
    }
    return _pictureArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageCount = 5;
    
    self.isFirstTableView = YES;
    
    [self feachPictureData];
    
    [self refreshNews];
    
    [self refreshNotice];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self.view addSubview:self.tableView];

}


- (void)setNavigationBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    _headImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 30, 30)];
    _headImageview.layer.cornerRadius = 15;
    _headImageview.layer.masksToBounds = YES;
    
    [_headImageview sd_setImageWithURL:mUrlWithString([AccountManager sharedManager].headImage) placeholderImage:mImageByName(@"ic_head_default")];
    [view addSubview:_headImageview];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_headImageview)+RELATIVE_WIDTH(10), 2, 100, 40)];
    _nameLabel.text = [AccountManager sharedManager].userName;
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.textColor = [UIColor whiteColor];
    
    
    
    [view addSubview:_nameLabel];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -5;

    UIBarButtonItem *baritem =[[UIBarButtonItem alloc]initWithCustomView:view];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, baritem, nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];

    
    self.navigationItem.rightBarButtonItem = rightButton;

    UILabel *label = [[UILabel alloc]init];
    label.text = @"";
    self.navigationItem.titleView = label;

    
}



#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else{
        if (_isFirstTableView) {
            return self.noticeData.count;
        }else{
            return self.newsData.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        static NSString *cellId = @"cell";
       UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            self.picView = [[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, heightOfImageScroll)];
            NSArray *arr=@[
                           @"http://src.zhids.cn/src/img/banner1.jpg",
                           @"http://src.zhids.cn/src/img/banner2.jpg",
                           @"http://src.zhids.cn/src/img/banner3.jpg",
                           @"http://src.zhids.cn/src/img/banner4.jpg"];
            self.ImageUrls=arr;
            self.picView.imagePlayerViewDelegate=self;
            self.picView.scrollInterval = 5.0f;
            self.picView.pageControlPosition = ICPageControlPosition_BottomCenter;
            self.picView.hidePageControl = NO;
            [cell.contentView addSubview:self.picView];
        }
        return cell;
    }
    else{
        if (self.isFirstTableView) {
        static NSString *cellId = @"cellNoImage";
        NoticeNewsModel *model = self.noticeData[indexPath.row];
        NoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[NoImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell setNoticeContent:model];
            cell.selectionStyle =UITableViewCellSelectionStyleDefault;

            return cell;
        }else{
            static NSString *cellNoId = @"cellImage";
            NoticeNewsModel *model = self.newsData[indexPath.row];
            ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNoId ];
            if (!cell) {
                cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNoId];
            }
            [cell setNewsContent:model];
            cell.selectionStyle =UITableViewCellSelectionStyleDefault;
            
            return cell;
        }
    }
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        NSArray *titleArray = @[@"通知公告",@"新闻信息"];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, heightOfButton)];
        for (NSInteger i = 0; i<2; i++) {
                        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*mScreenWidth/2, 0, mScreenWidth/2, heightOfButton)];
                        [btn addTarget:self action:@selector(changeContext:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = 10000+i;
                        [btn setBackgroundColor:[UIColor whiteColor]];
                        [btn setImageEdgeInsets:UIEdgeInsetsMake(heightOfButton - 2,0,0,0)];
                        [btn setTitleEdgeInsets:UIEdgeInsetsMake(5,-mScreenWidth/2, 5, 0)];
                        [btn setTitleColor:redBack forState:UIControlStateSelected];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageWithColor:redBack] forState:UIControlStateSelected];
                        [btn setImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        if (i== 0) {
                            btn.selected = self.isFirstTableView;
                        }else{
                            btn.selected = !self.isFirstTableView;
                        }
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [headView addSubview:btn];
                    }
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, heightOfButton, mScreenWidth, 0.5)];
            lineView.backgroundColor = halvingLineColor;
            [headView addSubview:lineView];
        return headView;
    }else{
        return nil;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return heightOfButton;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return heightOfImageScroll;
    }else{
        if (_isFirstTableView) {
            return RELATIVE_WIDTH(150);
        }else{
            return RELATIVE_WIDTH(200);
        }
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *strEnd = @"";
    NSString *title =@"";
    NoticeNewsModel *model;
    if (_isFirstTableView) {
        NoticeNewsModel *noticeModel = [self.noticeData objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"http://jssuxin.net:90/Web_MobileServer/ViewNews.aspx?id=%@&uname=%@",noticeModel.nid,[AccountManager sharedManager].userName];
        strEnd=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        model = noticeModel;
        title = @"通知";
    }
    else{
        if (self.newsData.count > 0) {
            NoticeNewsModel *newsModel = [self.newsData objectAtIndex:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"http://jssuxin.net:90/Web_MobileServer/ViewNews.aspx?id=%@&uname=%@",newsModel.nid,[AccountManager sharedManager].userName];
            strEnd=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model = newsModel;
            title = @"新闻";
        }
    }
        WebViewController *webView = [[WebViewController alloc]init];
        webView.urlString = strEnd;
        webView.NoticeModel = model;
        webView.title = title;
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - pictureDelegate
- (NSInteger)numberOfItems{
    return self.ImageUrls.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    //    NewsImg *newimg=[self.imageURLs objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.ImageUrls objectAtIndex:index]]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    IndexPictureModel *model = [self.pictureArray objectAtIndex:index];
    NSLog(@"点击了第%ld张图",index);
    NSString *urlString = [NSString stringWithFormat:@"http://jssuxin.net:90/Web_MobileServer/ViewNews.aspx?id=%@&uname=%@",model.nid,[AccountManager sharedManager].userName];
   NSString *strEnd=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    WebViewController *webView = [[WebViewController alloc]init];
    webView.title =@"";
    webView.urlString = strEnd;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 加载图片
- (void)feachPictureData{
    [IndexNet excuteGetPictureWithSuccess:^(id obj) {
        NSLog(@"数据下载成功");
        self.pictureArray = obj;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr removeAllObjects];
        for (IndexPictureModel *model in self.pictureArray) {
            [arr addObject:model.picurl];
        }
        self.ImageUrls = arr;
        [self.picView reloadData];
        
    } failed:^(id obj) {
        [MBProgressHUD showText_b:@"加载失败"];
    }];
}


- (void)feachNotice{
//    [MBProgressHUD showHUD];
    [IndexNet excuteGetNoticeWithStartPage:self.pageCount*self.noticePage
                                   endPage:self.pageCount*(self.noticePage +1)
                                   Success:^(id obj) {
                                       NSLog(@"%@",obj);
                                       [MBProgressHUD hideHUD];

                                       [self.noticeData addObjectsFromArray:(NSArray *)obj];
                                       [self.tableView.mj_footer endRefreshing];
                                       [self.tableView reloadData];
                                   } failed:^(id obj) {
                                       [MBProgressHUD showText_b:@"加载失败"];
                                   }];
}

- (void)feachNews{
//    [MBProgressHUD showHUD];
    [IndexNet excuteGetNewsWithStartPage:self.pageCount*self.newsPage
                                 endPage:self.pageCount*(self.newsPage +1)
                                 Success:^(id obj) {
                                     NSLog(@"%@",obj);
                                     [MBProgressHUD hideHUD];
                                     [self.newsData addObjectsFromArray:(NSArray *)obj];
                                     [self.tableView.mj_footer endRefreshing];
                                     [self.tableView reloadData];

                                 } failed:^(id obj) {
                                     [MBProgressHUD showText_b:@"加载失败"];
                                 }];
}

- (void)refreshNotice{
//    [MBProgressHUD showHUD];
    [IndexNet excuteGetNoticeWithStartPage:self.pageCount*self.noticePage
                                   endPage:self.pageCount*(self.noticePage +1)
                                   Success:^(id obj) {
                                       NSLog(@"%@",obj);
                                       [MBProgressHUD hideHUD];
                                       [self.noticeData removeAllObjects];
                                       [self.noticeData addObjectsFromArray:(NSArray *)obj];
                                       
                                       [self.tableView.mj_header endRefreshing];
                                       [self.tableView reloadData];
                                   } failed:^(id obj) {
                                       [MBProgressHUD showText_b:@"加载失败"];
                                   }];

}

- (void)refreshNews{
//    [MBProgressHUD showHUD];
    [IndexNet excuteGetNewsWithStartPage:self.pageCount*self.newsPage
                                 endPage:self.pageCount*(self.newsPage +1)
                                 Success:^(id obj) {
                                     NSLog(@"%@",obj);
//                                     [MBProgressHUD hideHUD];
                                     [self.newsData removeAllObjects];
                                     [self.newsData addObjectsFromArray:(NSArray *)obj];
                                    
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView reloadData];
                                     
                                 } failed:^(id obj) {
                                     [MBProgressHUD showText_b:@"加载失败"];
                                 }];

}



#pragma 退出登录
- (void)logout{
    NSLog(@"退出登录");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认注销" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        
        NSArray *array = @[@"loginUser.archiver",@"draftbox.archiver",@"outbox.archiver",@"inbox.archiver",@"dustbin.archiver"];
        for (NSString *archiver in array) {
            NSString *filePath = [documentsPath stringByAppendingPathComponent:archiver];
            NSFileManager *defaultManage = [NSFileManager defaultManager];
            if ([defaultManage isDeletableFileAtPath:filePath]) {
                [defaultManage removeItemAtPath:filePath error:nil];
                NSLog(@"删除本地缓存文件成功");
            }
        }
        LoginViewController *login = [[LoginViewController alloc]init];
        self.view.window.rootViewController =login;
        
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];

    }];
    [alertController  addAction:sure];
    [alertController addAction:cancle];
    
    [self presentViewController:alertController  animated:YES completion:nil];

    
    
    
    
    
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"loginUser.archiver"];
//    
//    NSFileManager *defaultManage = [NSFileManager defaultManager];
//    if ([defaultManage isDeletableFileAtPath:filePath]) {
//        [defaultManage removeItemAtPath:filePath error:nil];
//        NSLog(@"删除用户信息成功");
//    }
    
    
    
    
    
}
#pragma mark -刷新
- (void)loadNewData{
    self.newsPage = 0;
    self.noticePage = 0;
    [self refreshNews];
    [self refreshNotice];
    [self feachPictureData];
}

#pragma mark -加载更多
- (void)getMoreData{
    if (_isFirstTableView) {
        self.noticePage++;
        [self feachNotice];
    }else{
        self.newsPage++;
        [self feachNews];
    }
}

- (void)changeContext:(UIButton *)sender{
    if (sender.tag ==10000) {
        self.isFirstTableView = YES;
    }else{
        self.isFirstTableView = NO;
    }
    [self.tableView reloadData];
}

- (void)swipe:(UISwipeGestureRecognizer *)sender{
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"左滑");
            if (self.isFirstTableView) {
                self.isFirstTableView = NO;
                [self.tableView reloadData];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"右滑");
            if (!self.isFirstTableView) {
                self.isFirstTableView = YES;
                [self.tableView reloadData];
            }
            break;
        default:
            break;
    }
}


#pragma mark -跳转登录界面
//- (void)pushLoginView{
//    LoginViewController *login = [[LoginViewController alloc]init];
//    login.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:login animated:YES];
//}



//#pragma mark -自动登录
//- (void)autoLoginWithName:(NSString *)useName password:(NSString *)passWord{
//    [LoginNet excuteLoginWithUserName:useName password:passWord success:^(id obj) {
//        LoginModel *model = obj;
//        self.account.loginSucces = YES;
//        self.account.uid = model.uid;
//        self.account.userName = model.name;
//        self.account.headImage = [[NSString stringWithFormat:@"http://www.jssuxin.net:90%@",model.imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        self.hidesBottomBarWhenPushed = NO;
//
//        self.pageCount = 5;
//        
//        self.isFirstTableView = YES;
//        
//        [self feachPictureData];
//        
//        [self refreshNews];
//        
//        [self refreshNotice];
//        self.view.backgroundColor = [UIColor whiteColor];
//        [self setNavigationBar];
//        [self.view addSubview:self.tableView];
//        NSLog(@"自动登录成功");
//    } failed:^(id obj) {
////        [MBProgressHUD hideHUD];
//        [MBProgressHUD showText_b:@"自动登录失败，请重试新登录"];
//        [self pushLoginView];
//    }];
//
//
//}
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
