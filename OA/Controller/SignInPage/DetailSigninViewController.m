//
//  DetailSigninViewController.m
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "DetailSigninViewController.h"
#import "ElonHTTPSession.h"
#import "BRPlaceholderTextView.h"


@interface DetailSigninViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *_signTime;
    UILabel *_timeLabel;
    UILabel *_signAddress ;
    UILabel *_signDetail;
    BRPlaceholderTextView *_textView;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *timeArr;

@end


@implementation DetailSigninViewController

- (NSArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSArray array];
    }
    return _timeArr;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeArr = [self.time componentsSeparatedByString:@" "];
    [self.view addSubview:self.tableView];
    self.title = @"外勤签到";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor = redBack;
    button.frame = CGRectMake(0, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(90), mScreenWidth, RELATIVE_WIDTH(90)) ;
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            if (!_signTime) {
            _signTime = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, 80, RELATIVE_WIDTH(30))];
            _signTime.center = CGPointMake(_signTime.center.x, RELATIVE_WIDTH(50));
            _signTime.font = [UIFont systemFontOfSize:15];
            _signTime.text = @"签到时间:";
            [cell.contentView addSubview:_signTime];
            }
            if (!_timeLabel) {
                _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_signTime), 0, RELATIVE_WIDTH(120), RELATIVE_WIDTH(30))];
                _timeLabel.center = CGPointMake(_timeLabel.center.x, RELATIVE_WIDTH(50));
                _timeLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:_timeLabel];
            }
            
            _timeLabel.text = [self.timeArr lastObject];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(98), mScreenWidth, 0.5)];
            view.backgroundColor = halvingLineColor;
            [cell.contentView addSubview:view];
        }else if (indexPath.row ==1){
            _signAddress = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, 80, RELATIVE_WIDTH(30))];
            _signAddress.font = [UIFont systemFontOfSize:15];
            _signAddress.text = @"签到地点:";
            _signAddress.center = CGPointMake(_signAddress.center.x, RELATIVE_WIDTH(50));
            [cell.contentView addSubview:_signAddress];
            
            _signDetail = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_signAddress),0 , mScreenWidth - 80, RELATIVE_WIDTH(30))];
            _signDetail.text = self.address;
            _signDetail.font = [UIFont systemFontOfSize:15];
            _signDetail.center =CGPointMake(_signDetail.center.x, RELATIVE_WIDTH(50));
            [cell.contentView addSubview:_signDetail];
        }
    }else{
        _textView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 0, mScreenWidth-10, RELATIVE_WIDTH(400))];
        _textView.placeholder = @"填写说明";
        _textView.font = [UIFont systemFontOfSize:15];
        [_textView setPlaceholderFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:_textView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0.01;
    }else{
        return RELATIVE_WIDTH(30);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return RELATIVE_WIDTH(100);
    }else{
        return RELATIVE_WIDTH(400);
    }
}


- (void)submit{
    NSLog(@"点击提交");
    NSDictionary *params = @{
        @"id": @"",
        @"uid": [AccountManager sharedManager].uid,
        @"location": _signDetail.text,
        @"info": _textView.text,
        @"createtime": @"",
        @"state": @"",
        @"latitude": self.loca.lat,
        @"longitude":self.loca.lng,
        @"uName": [AccountManager sharedManager].userName
        };
    
    [ElonHTTPSession POST:SIGNIN paraments:params completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if ((object !=nil) &&(error == nil)) {
            [MBProgressHUD showText_b:@"签到成功"];
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
