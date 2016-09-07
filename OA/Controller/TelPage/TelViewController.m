//
//  TelViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "TelViewController.h"
#import "TelBookNet.h"
#import "TelBookModel.h"
#import "UsersModel.h"
#import "TelTableViewCell.h"
#import "MailTelTableViewCell.h"


@interface TelViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MFMessageComposeViewControllerDelegate>{
    UIButton *_sectionSelectedBtn;
}

@property (nonatomic,copy)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIAlertController *alertController;
@property (nonatomic,strong)MFMessageComposeViewController *messageController;
@property (nonatomic,strong)UITableView *searchTableView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *searchData;

@end

@implementation TelViewController

- (NSMutableArray *)searchData{
    if (!_searchData) {
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}

-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, RELATIVE_WIDTH(700)) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _searchTableView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, mScreenHeight-mNavBarWithStateHeight-mTabBarHeight- RELATIVE_WIDTH(90)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightItem];
    [self initSerachView];
    [self.dataArray removeAllObjects];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"telBook.archiver"];
        
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [self.dataArray addObjectsFromArray:arr];
        
    [self.view addSubview:self.tableView];
    if (!(self.dataArray.count >0)) {
        [self feachData];
    }
    if (self.isMailType) {
        self.tableView.frame = CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, mScreenHeight- mNavBarWithStateHeight - RELATIVE_WIDTH(90));
        for (UsersModel *model in self.contactArray) {
            for (TelBookModel *bookModel in self.dataArray) {
                for (UsersModel *usermodel in bookModel.users) {
                    if ([model.userId isEqualToString:usermodel.userId]) {
                        usermodel.selected = YES;
                    }
                }
            }
        }
        
        for (TelBookModel *telModel in self.dataArray) {
            BOOL allSelect = YES;
            if (!(telModel.users.count>0)) {
                allSelect = NO;
            }
            for (UsersModel *usermodel in telModel.users) {
                
                if (usermodel.selected ==NO) {
                    allSelect = NO;
                }
            }
            telModel.selected = allSelect;
        }
    }
    NSLog(@"%@",self.dataArray);
    
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)initSerachView{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, RELATIVE_WIDTH(90))];
    _searchBar.placeholder = @"搜索";
    _searchBar.backgroundColor = grayBackGround;
    _searchBar.delegate = self;
    _searchBar.barStyle=UIBarStyleDefault;
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    [self.view addSubview:_searchBar];
}
//searchbar 背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void) setRightItem{
        if (self.isMailType) {
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addPerson)];
            [self setRightItemFont:15];
    }else{
        
        self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"同步" style:UIBarButtonItemStylePlain target:self action:@selector(sync)];
        
        [self setRightItemFont:15];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"users.archiver"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (![searchText isEqualToString:@""]) {
        [self.view addSubview:self.searchTableView];
        [self.searchData removeAllObjects];
        for (UsersModel *user in arr) {
            if ([user.name containsString:searchText]) {
                [self.searchData addObject:user];
            }
        }
        [self.searchTableView reloadData];
    }else{
        [self.searchTableView removeFromSuperview];
    }
    
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView ==self.searchTableView) {
        return 1;
    }else{
    return self.dataArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.searchTableView) {
        return self.searchData.count;
    }else{
    TelBookModel *model = [[TelBookModel alloc]init];
    model=[self.dataArray objectAtIndex:section];
    
    NSArray *array= model.users;
    
    //判断是收缩还是展开
    
    if (model.expanded ==YES) {
        return array.count;
    }else{
        return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==self.searchTableView) {
        static NSString *cellReuseId = @"reuseCellId";
        UsersModel *usermodel = [self.searchData objectAtIndex:indexPath.row];
        TelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
        if (!cell) {
            cell = [[TelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setContentWithDic:usermodel];

        return cell;
    }else{
    
    TelBookModel *model=[self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = model.users;
    
    UsersModel *usermodel = [array objectAtIndex:indexPath.row];
    
    static NSString *mailCellId = @"mailCell";
    static NSString *cellId = @"cell";
    if (self.isMailType) {
        MailTelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mailCellId];
        if (!cell) {
            cell = [[MailTelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mailCellId];
        }
        cell.tag = indexPath.section *100000+indexPath.row+9;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = mRGBColor(250, 250, 251);
        [cell setContentWithDic:usermodel];
            return cell;
        }else{
     TelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = mRGBColor(250, 250, 251);
        [cell setContentWithDic:usermodel];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView ==self.searchTableView) {
        return 0.01;
    }else{
    return RELATIVE_WIDTH(100);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView ==self.searchTableView) {
        return nil;
    }else{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, RELATIVE_WIDTH(100))];
    
    hView.backgroundColor=[UIColor whiteColor];
    
    UIButton* eButton = [[UIButton alloc] init];
    
    //按钮填充整个视图
    eButton.frame = hView.frame;
    
    [eButton addTarget:self action:@selector(expandButtonClicked:)
     
      forControlEvents:UIControlEventTouchUpInside];
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    eButton.tag = section;
    
    //设置图标
    
    //根据是否展开，切换按钮显示图片
    
    if ([self isExpanded:section]){
        [eButton setImage: [UIImage imageNamed: @"contact_down" ]forState:UIControlStateNormal];
    } else {
        [eButton setImage: [UIImage imageNamed: @"contact_right" ]forState:UIControlStateNormal];
    }
    //设置分组标题
    TelBookModel *model = [[TelBookModel alloc]init];
    model = [self.dataArray objectAtIndex:section];
    [eButton setTitle:[NSString stringWithFormat:@"%@(%ld)",[model.deptName substringFromIndex:5],model.users.count] forState:UIControlStateNormal];
    
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    
    //4个参数是到上边界，左边界，下边界，右边界的距离
    
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    eButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(0,20, 0,0)];
    
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(-5,RELATIVE_WIDTH(20), -5,self.view.bounds.size.width - 40)];
    
    //下显示线
    
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, RELATIVE_WIDTH(98), mScreenWidth,0.5)];
    
    lineview.backgroundColor = halvingLineColor;
        
    [hView addSubview:lineview];
    
    [hView addSubview: eButton];
    
    if (self.isMailType) {
        CGRect frame = eButton.frame;
        frame.size.width -=RELATIVE_WIDTH(150);
        eButton.frame = frame;
        _sectionSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sectionSelectedBtn.frame = CGRectMake(mScreenWidth - RELATIVE_WIDTH(100), 0, RELATIVE_WIDTH(100), RELATIVE_WIDTH(100));
        
        [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,20, 0,0)];
        
        [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,10, 0,self.view.bounds.size.width - 35-RELATIVE_WIDTH(150))];
        _sectionSelectedBtn.tag = section*1000000+6;
        _sectionSelectedBtn.selected = model.selected;
        _sectionSelectedBtn.center = CGPointMake(_sectionSelectedBtn.center.x, RELATIVE_WIDTH(50));
        [_sectionSelectedBtn addTarget:self action:@selector(allChoose:) forControlEvents:UIControlEventTouchUpInside];
        [_sectionSelectedBtn setImage:mImageByName(@"ic_selected_false") forState:UIControlStateNormal];
        [_sectionSelectedBtn setImage:mImageByName(@"ic_selected_true") forState:UIControlStateSelected];
        [hView addSubview:_sectionSelectedBtn];
    }
    
    return hView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_WIDTH(140);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView ==self.searchTableView) {
        UsersModel *userModel = [self.searchData objectAtIndex:indexPath.row];
        NSInteger sec = 0;
        NSInteger row = 0;
        for (NSInteger i = 0; i<self.dataArray.count; i++) {
            TelBookModel *model = [self.dataArray objectAtIndex:i];
            NSArray *array = model.users;
            for (NSInteger j = 0; j<array.count; j++) {
                UsersModel *user = [array objectAtIndex:j];
                if ([userModel.name isEqualToString:user.name]) {
                    sec = i;
                    row = j;
                }
            }
        }
        if (self.isMailType) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:sec];
            [self.searchTableView removeFromSuperview];
            [self collapseOrExpand:sec];
            [self.tableView reloadData];

            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            [self pushAlertView:userModel.mobile];
        }

    }else{
    TelBookModel *model=[self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = model.users;
    UsersModel *userModel = [array objectAtIndex:indexPath.row];
    if (self.isMailType) {
        userModel.selected = !userModel.selected;
        MailTelTableViewCell *cell = (MailTelTableViewCell *)[self.view viewWithTag:100000*indexPath.section+indexPath.row+9];
        cell.selectedBtn.selected = userModel.selected;
        BOOL selecte = YES;
        for (UsersModel *useModel in array) {
            if (useModel.selected == NO) {
                selecte = NO;
            }
        }
        UIButton *btn = (UIButton *)[self.view viewWithTag:indexPath.section*1000000+6];
        NSLog(@"button 的tag ==%ld ，，，selecte ==%d",btn.tag,selecte);
        btn.selected = model.selected = selecte;
    }else{
        [self pushAlertView:userModel.mobile];
            }
    }
    
}


- (void)pushAlertView:(NSString *)telephone{
    self.alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择操作方式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *phone = [UIAlertAction actionWithTitle:@"打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"打电话");
        if (![telephone isEqualToString:@""]) {
            [self makePhotoWithNumber:telephone];
        }else{
            NSLog(@"未留电话");
            [MBProgressHUD showText_b:@"尚无电话"];
        }
    }];
    
    UIAlertAction *message = [UIAlertAction actionWithTitle:@"发短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"发短信");
        if (![telephone isEqualToString:@""]) {
            [self sendMessageWithNumber:telephone];
        }else{
            NSLog(@"未留电话");
            [MBProgressHUD showText_b:@"尚无电话"];
        }
    }];
    
    UIAlertAction *ceancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.alertController  dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.alertController  addAction:ceancle];
    [self.alertController  addAction:phone];
    [self.alertController  addAction:message];
    
    [self presentViewController:self.alertController  animated:YES completion:nil];

}

#pragma mark - Action

-(int)isExpanded:(NSInteger)section{
    TelBookModel *model = [[TelBookModel alloc]init];

    model=[self.dataArray objectAtIndex:section];
    
    BOOL expanded=model.expanded;
    
    return expanded;
    
}

-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn = (UIButton *)sender;
    
    NSInteger section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    
    [self.tableView reloadData];
    
}

//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠

-(void)collapseOrExpand:(NSInteger)section{
    TelBookModel *model = [[TelBookModel alloc]init];

    model= [self.dataArray objectAtIndex:section];
    
    BOOL expanded=model.expanded;
    
    if (expanded) {
        model.expanded =NO;
        
    }else {
        model.expanded =YES;
    }
    
}
- (void)feachData{
    [TelBookNet excuteGetTelBookWithSuccess:^(id obj) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        [data addObjectsFromArray:obj];
        for (TelBookModel *model in data) {
            NSMutableArray *mulArray =[[NSMutableArray alloc]init];
            [mulArray addObjectsFromArray:model.users];
            NSArray *array = [NSArray arrayWithArray:mulArray];
            for (UsersModel *dic in array) {
                if ([dic.name  isEqual:@"无人员"]||[dic.name  isEqual:@"超级管理员"]) {
                    [mulArray removeObject:dic];
                }
                model.users = (NSArray *)mulArray;
            }
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"telBook.archiver"];

        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr.count>0) {
            NSFileManager *defaultManage = [NSFileManager defaultManager];
            if ([defaultManage isDeletableFileAtPath:filePath]) {
                [defaultManage removeItemAtPath:filePath error:nil];
            }
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:self.dataArray toFile:filePath];
        if (success) {
            NSLog(@"电话本保存成功！");
            [MBProgressHUD showText_b:@"同步成功"];
            [self creatAllUsers];

        }
        [self.tableView reloadData];
    } failed:^(id obj) {
        [MBProgressHUD showText_b:@"同步失败"];
    }];
}

#pragma mark -clicK
- (void)sync{
    [self feachData];
}

- (void)addPerson{
    
    NSMutableArray *mulArr = [[NSMutableArray alloc]init];
    for (TelBookModel *model in self.dataArray) {
        for (UsersModel *userModel in model.users) {
            if (userModel.selected ==YES) {
                [mulArr addObject:userModel];
            }
        }
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(choosePersonWith:)]) {
        [_delegate choosePersonWith:mulArr];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)allChoose:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    TelBookModel *model = [self.dataArray objectAtIndex:(sender.tag - 6)/1000000];
    model.selected = !model.selected;
    sender.selected = model.selected;
    for (UsersModel *userModel in model.users) {
        userModel.selected = model.selected;
        
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatAllUsers{
    dispatch_queue_t urls_queue = dispatch_queue_create("users", NULL);
    dispatch_async(urls_queue, ^{
        NSMutableArray *mulArr = [[NSMutableArray alloc]init];
        for (TelBookModel *model in self.dataArray) {
            for (UsersModel *userModel in model.users) {
                [mulArr addObject:userModel];
            }
        }
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"users.archiver"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr.count>0) {
            NSFileManager *defaultManage = [NSFileManager defaultManager];
            if ([defaultManage isDeletableFileAtPath:filePath]) {
                [defaultManage removeItemAtPath:filePath error:nil];
            }
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:mulArr toFile:filePath];
        if (success) {
            NSLog(@"users保存成功");
        }
    });
}

- (void)makePhotoWithNumber:(NSString *)number{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]];
        [[UIApplication sharedApplication] openURL:url];
}

- (void)sendMessageWithNumber:(NSString *)number
{
    // 判断用户设备能否发送短信
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    
    // 1. 实例化一个控制器
    self.messageController = [[MFMessageComposeViewController alloc] init];
    
    // 2. 设置短信内容
    // 1) 收件人
    _messageController.recipients = @[number];
    
    // 2) 短信内容
    _messageController.body = @"";
    
    // 3) 设置代理
    _messageController.messageComposeDelegate = self;
    
    // 3. 显示短信控制器
    [self presentViewController:_messageController animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            [self.messageController dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            [self.messageController dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            [self.messageController dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"发送失败");
            break;
        default:
            break;
    }
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
