//
//  CheckLowViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "CheckLowViewController.h"
#import "CheckLowTableViewCell.h"
#import "PlanNet.h"
#import "CheckLowModel.h"
#import "LowPlanViewController.h"

@interface CheckLowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *checkLowtableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CheckLowViewController


-(UITableView *)checkLowtableView{
    if (!_checkLowtableView) {
        _checkLowtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
        _checkLowtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _checkLowtableView.delegate = self;
        _checkLowtableView.dataSource = self;
        _checkLowtableView.backgroundColor = [UIColor clearColor];
    }
    return _checkLowtableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self feachData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.checkLowtableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"checkLowReuserId";
    
    CheckLowModel *model = self.dataArray[indexPath.row];
    
    CheckLowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CheckLowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setInfomationWithCheckModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_WIDTH(120);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckLowModel *model = self.dataArray[indexPath.row];
    LowPlanViewController *lowPlan = [[LowPlanViewController alloc]init];
    lowPlan.checkModel = model;
    [self.navigationController pushViewController:lowPlan animated:YES];
}


- (void)feachData{
    [MBProgressHUD showHUD:@"正在加载"];
    [PlanNet excuteGetCheckLowWithUid:[AccountManager sharedManager].uid success:^(id obj) {
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:(NSArray *)obj];
        [self.checkLowtableView reloadData];
    } failed:^(id obj) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText_b:@"加载失败"];
    }];
    
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
