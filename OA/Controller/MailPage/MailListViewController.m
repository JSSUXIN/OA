//
//  MailListViewController.m
//  OA
//
//  Created by Elon Musk on 16/8/10.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MailListViewController.h"
#import "ElonHTTPSession.h"
#import "MailListModel.h"
#import "MailViewController.h"
#import "MailDetailViewController.h"
#import "MailTableViewCell.h"
#import "MailEditTableViewCell.h"

@interface MailListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UIButton *_recoveryBtn;
    UISearchBar *_searchBar;
}
@property(nonatomic,strong) NSMutableArray *MailData;


@property (nonatomic,strong) NSNotification *changeTitleNotification;
@property (nonatomic,strong) NSMutableArray *MailDataCopy;
@property (nonatomic,strong)  UITableView *tableview;
@property (nonatomic,assign)  BOOL isEdit;

@end

@implementation MailListViewController

-(NSMutableArray *)MailData
{
    if(!_MailData)
    {
        _MailData=[NSMutableArray array];
    }
    
    return _MailData;
}

-(NSMutableArray *)MailDataCopy{
    if (!_MailDataCopy) {
        _MailDataCopy = [NSMutableArray array];
    }
    return _MailDataCopy;
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, mScreenHeight - mNavBarWithStateHeight - mTabBarHeight -RELATIVE_WIDTH(90) - 44) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle =    UITableViewCellSeparatorStyleNone;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickEdit:) name:@"mailNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteMail:) name:@"maildeleteNotification" object:nil];
    self.changeTitleNotification = [NSNotification notificationWithName:@"changeTitleNotification" object:nil userInfo:nil];
    [self initSearchBar];
    self.isEdit = NO;
    [self.view addSubview:self.tableview];
    [self getCacheFile];
    
}
#pragma mark searchBar
- (void)initSearchBar{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, RELATIVE_WIDTH(90))];
    _searchBar.backgroundColor = grayBackGround;
    _searchBar.placeholder = @"搜索主题或收件人";
    _searchBar.delegate = self;
    _searchBar.barStyle=UIBarStyleDefault;
//    searchBar.backgroundColor = RGBACOLOR(249,249,249,1);
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];

    [self.view addSubview:_searchBar];
}


//取消searchbar背景色
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
#pragma mark 收缩键盘
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray *mulArr = [NSMutableArray array];
    
    if ([searchText isEqualToString:@""]) {
        [self.MailData removeAllObjects];
        [self.MailData addObjectsFromArray:self.MailDataCopy];
        [self.tableview reloadData];

    }else{
        for (MailListModel *model in self.MailData) {
            if ([model.subject containsString:searchText]||[model.sendFromName containsString:searchText]) {
                [mulArr addObject:model];
            }
        }
        [self.MailData removeAllObjects];
        [self.MailData addObjectsFromArray:mulArr];
        [self.tableview reloadData];
    }
    
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MailData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MailListModel *model = [self.MailData objectAtIndex:indexPath.row];
    static NSString *cellId = @"cell";
    static NSString *cellEditId = @"cellid";
    if (!self.isEdit) {
        MailTableViewCell *cell =(MailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell setContentWithModel:model];
        return cell;
    }else{
        MailEditTableViewCell *cell = (MailEditTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellEditId];
        if (!cell) {
            cell = [[MailEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEditId];
        }
        cell.tag = 10000+indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell setContentWithModel:model];
        return cell;
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_WIDTH(120);
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击后恢复颜色变化
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MailListModel *model = [self.MailData objectAtIndex:indexPath.row];
    if (!self.isEdit) {
        MailDetailViewController *mailDetail = [[MailDetailViewController alloc]init];
        mailDetail.hidesBottomBarWhenPushed = YES;
        mailDetail.mailId = model.mailId;
        switch (self.BoxType) {
            case Inbox:
                mailDetail.mailType = InboxMail;
                break;
            case Outbox:
                mailDetail.mailType = OutboxMail;
                break;
            case Draftbox:
                mailDetail.mailType = DraftboxMail;
                break;
            case Dusbinbox:
                mailDetail.mailType = DusbinboxMail;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:mailDetail animated:YES];
    }else{
        model.selected = !model.selected;
        MailEditTableViewCell *cell = (MailEditTableViewCell *)[self.view viewWithTag:10000+indexPath.row];
        cell.selectedButton.selected = model.selected;
    }
}

- (void)refreshTableView{
    [self getTableviewData];
}

- (void)clickEdit:(NSNotification*)dic{
    
    if([dic.userInfo[@"dd"] intValue]==0 && self.BoxType==Inbox)
    {
        self.isEdit = !self.isEdit;
        [self.tableview reloadData];
    }else if ([dic.userInfo[@"dd"] intValue ]==1&& self.BoxType == Outbox){
        self.isEdit = !self.isEdit;
        [self.tableview reloadData];
    }else if ([dic.userInfo[@"dd"] intValue ]==2&& self.BoxType == Draftbox){
        self.isEdit = !self.isEdit;
        [self.tableview reloadData];
    }else if ([dic.userInfo[@"dd"] intValue ]==3&& self.BoxType == Dusbinbox){
        self.isEdit = !self.isEdit;
        if (!_recoveryBtn) {
            _recoveryBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, mScreenHeight - mTabBarHeight -mNavBarWithStateHeight - 44- RELATIVE_WIDTH(90), mScreenWidth, RELATIVE_WIDTH(90))];
            [_recoveryBtn setTitle:@"恢复邮件" forState:UIControlStateNormal];
            _recoveryBtn.backgroundColor = redBack;
            [_recoveryBtn addTarget:self action:@selector(recoveryMail) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_recoveryBtn];
            }
        [self showRecovery];
        [self.tableview reloadData];
    }
}

- (void)deleteMail:(NSNotification *)dic{
    
    NSMutableArray *mularr = [NSMutableArray array];
    [mularr removeAllObjects];
    if([dic.userInfo[@"dd"] intValue]==0 && self.BoxType==Inbox){
        for (MailListModel *listModel in self.MailData) {
            if (listModel.selected == YES) {
                [mularr addObject:listModel.mailId];
            }
        }
        [self delWithMode:@"inbox" mailarr:mularr];
        
    }else if ([dic.userInfo[@"dd"] intValue ]==1&& self.BoxType == Outbox){
        for (MailListModel *listModel in self.MailData) {
            if (listModel.selected == YES) {
                [mularr addObject:listModel.mailId];
            }
        }
        [self delWithMode:@"outbox" mailarr:mularr];
    }else if ([dic.userInfo[@"dd"] intValue ]==2&& self.BoxType == Draftbox){
        for (MailListModel *listModel in self.MailData) {
            if (listModel.selected == YES) {
                [mularr addObject:listModel.mailId];
            }
        }
        [self delWithMode:@"draftbox" mailarr:mularr];
    }else if ([dic.userInfo[@"dd"] intValue ]==3&& self.BoxType == Dusbinbox){
        for (MailListModel *listModel in self.MailData) {
            if (listModel.selected == YES) {
                [mularr addObject:listModel.mailId];
            }
        }
        [self delWithMode:@"dustbin" mailarr:mularr];
    }
}


- (void)delWithMode:(NSString *)mode mailarr:(NSArray *)mailarr{
    NSString *mailIdsString = [mailarr componentsJoinedByString:@","];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:[NSString stringWithFormat:DELETEMAIL,mode,mailIdsString,[AccountManager sharedManager].uid] paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"object = %@, error = %@",object,error);
        if (!error) {
            NSMutableArray *mul = [NSMutableArray arrayWithArray:self.MailData];
            for (MailListModel *listmodel in mul) {
                if (listmodel.selected ==YES) {
                    [self.MailData removeObject:listmodel];
                }
            }
            self.isEdit = NO;
            [self.tableview reloadData];
        }else{
            NSLog(@"删除失败");
            self.isEdit = NO;
            [self.tableview reloadData];
        }
    }];
}


- (void)recoveryMail{
    NSLog( @"恢复邮件");
    NSMutableArray *mul = [NSMutableArray array];
    for (MailListModel *listmodel in self.MailData) {
        if (listmodel.selected ==YES) {
            [mul addObject:listmodel.mailId];
        }
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(clickRecovery)]) {
        [_delegate clickRecovery];
    }
    NSString *string = [mul componentsJoinedByString:@","];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:[NSString stringWithFormat:RECOVERYMAIL,string,[AccountManager sharedManager].uid] paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSMutableArray *mularr = [NSMutableArray arrayWithArray:self.MailData];
            for (MailListModel *listmodel in mularr) {
                if (listmodel.selected ==YES) {
                    [self.MailData removeObject:listmodel];
                }
            }
            self.isEdit = NO;
            [self showRecovery];
            [self.tableview reloadData];
        }else{
            NSLog(@"恢复失败");
            self.isEdit = NO;
            [self showRecovery];
            [self.tableview reloadData];
        }
    }];
    
    
}


- (void)showRecovery{
    if (self.isEdit) {
        _recoveryBtn.hidden = NO;
        self.tableview.frame = CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, mScreenHeight - mNavBarWithStateHeight - mTabBarHeight -RELATIVE_WIDTH(90) - 44 - RELATIVE_WIDTH(90));
    }else{
        _recoveryBtn.hidden = YES;
        self.tableview.frame = CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, mScreenHeight - mNavBarWithStateHeight - mTabBarHeight -RELATIVE_WIDTH(90) - 44);
    }
}

- (void) getTableviewData{
    switch (self.BoxType) {
        case Inbox:{
            NSLog(@"收件箱");
            [self getWithBox:@"inbox"];
            break;
        }
        case Outbox:{
            NSLog(@"发件箱");
            [self getWithBox:@"outbox"];
            break;
        }
            
        case Draftbox:{
            NSLog(@"草稿箱");
            [self getWithBox:@"draftbox"];
            break;
        }
            
        case Dusbinbox:{
            NSLog(@"垃圾箱");
            [self getWithBox:@"dustbin"];
            break;
        }
        default:
            break;
    }

}

- (void)getCacheFile{
    [self.MailData removeAllObjects];

    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    switch (self.BoxType) {
        case Inbox:{
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inbox.archiver"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

            if (!(arr.count>0)) {
                [self getTableviewData];
            }else{
                [self.MailData addObjectsFromArray:arr];
                self.MailDataCopy = [self.MailData mutableCopy];
            }
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%zd",[self getCountWithHasRead:self.MailData]] forKey:@"count"];
            [dic setObject:[NSString stringWithFormat:@"%zd",self.BoxType] forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTitleNotification" object:nil userInfo:dic];
        }
            break;
            case Outbox:
        { NSString *filePath = [documentsPath stringByAppendingPathComponent:@"outbox.archiver"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            if (!(arr.count>0)) {
                [self getTableviewData];
            }else{
                [self.MailData addObjectsFromArray:arr];
                self.MailDataCopy = [self.MailData mutableCopy];

            }
        
        }
            break;
        case Draftbox:{
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"draftbox.archiver"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            if (!(arr.count>0)) {
                [self getTableviewData];
            }else{
                [self.MailData addObjectsFromArray:arr];
                self.MailDataCopy = [self.MailData mutableCopy];

            }
        }
            break;
        case Dusbinbox:{
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"dustbin.archiver"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            if (!(arr.count>0)) {
                [self getTableviewData];
            }else{
                [self.MailData addObjectsFromArray:arr];
                self.MailDataCopy = [self.MailData mutableCopy];
            }
        }
            break;
        default:
            break;
    }
}

- (NSInteger )getCountWithHasRead:(NSArray *)data{
    NSInteger count = 0;
    for (MailListModel *model in data) {
        if (model.isRead ==NO) {
            count++;
        }
    }
    return count;
}


- (void)getWithBox:(NSString *)box{
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:[NSString stringWithFormat:GETMAILLIST,[AccountManager sharedManager].uid,box] paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"%@ == %@",box,object);
            [MailListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"mailId":@"id",
                         @"sendFromName":@"sendFromName",
                         @"sendFromId":@"sendFromId",
                         @"subject":@"subject",
                         @"sendTime":@"sendTime",
                         @"isRead":@"isRead",
                         @"content":@"content"};
            }];
            self.MailData = [MailListModel mj_objectArrayWithKeyValuesArray:object];
            NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",box]];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            if (arr.count>0) {
                NSFileManager *defaultManage = [NSFileManager defaultManager];
                if ([defaultManage isDeletableFileAtPath:filePath]) {
                    [defaultManage removeItemAtPath:filePath error:nil];
                }
            }
            BOOL success = [NSKeyedArchiver archiveRootObject:self.MailData toFile:filePath];
            if (success) {
                NSLog(@"%@保存成功",box);
            }
            self.MailDataCopy = [self.MailData mutableCopy];
            [self.tableview reloadData];
            [self.tableview.mj_header endRefreshing];
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%zd",[self getCountWithHasRead:self.MailData]] forKey:@"count"];
            [dic setObject:[NSString stringWithFormat:@"%zd",self.BoxType] forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTitleNotification" object:nil userInfo:dic];
        }
    }];
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
