//
//  SignInViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/29.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInTableViewCell.h"
#import "MapAddressNet.h"
#import "AddressModel.h"
#import "DetailSigninViewController.h"
#import "NSDateCalendar.h"


static NSString *cellId = @"cell";


@interface SignInViewController()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate>{
    UIImageView *_headImage;
    UILabel *_nameLabel;
    UILabel *_signTimes;
    UIView *_backView;
//    BMKUserLocation *_location;
    NSString *_time;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *lalocation;

@property (nonatomic,copy) NSArray *addressArray;


@property (nonatomic,strong) BMKMapView* mapView;


@end

@implementation SignInViewController{
    BMKLocationService* _locService;
//    BMKMapView* _mapView;
}

- (NSArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSArray alloc]init];
    }
    return _addressArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight - mTabBarHeight- RELATIVE_WIDTH(90)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        _tableView.bounces = NO;
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}


- (void)viewDidLoad{
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    self.title = @"签到";
    _locService = [[BMKLocationService alloc]init];
    [self.view addSubview:self.tableView];
    [self startLocation];
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signInButton.frame = CGRectMake(0, GG_BOTTOM_Y(self.tableView), mScreenWidth, RELATIVE_WIDTH(90));
    [signInButton setTitleEdgeInsets:UIEdgeInsetsMake(3, RELATIVE_WIDTH(50), 3, RELATIVE_WIDTH(50))];
    [signInButton setTitle:@"立即签到" forState:UIControlStateNormal];
    [signInButton setImage:mImageByName(@"ic_location") forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    signInButton.backgroundColor = redBack;
    [self.view addSubview:signInButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.addressArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else{
        return RELATIVE_WIDTH(500);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return RELATIVE_WIDTH(280);
    }else{
        return RELATIVE_WIDTH(140);
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenHeight, RELATIVE_WIDTH(500))];
        for (NSInteger i = 0; i <2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*mScreenWidth/2, 0, mScreenWidth/2, RELATIVE_WIDTH(90));
            btn.backgroundColor = [UIColor whiteColor];
            btn.tag = 100+i;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [btn setImageEdgeInsets:UIEdgeInsetsMake( 3,RELATIVE_WIDTH(60), 3, mScreenWidth/2 - RELATIVE_WIDTH(100 ))];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(3,RELATIVE_WIDTH(40), 3, RELATIVE_WIDTH(20))];
            [btn setTitleColor:grayTextcolor forState:UIControlStateNormal];
            NSDate *date = [NSDateCalendar getNowTime];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            _time = [formatter stringFromDate:date];
            NSArray *timeArr = [_time componentsSeparatedByString:@" "];
            
            NSInteger number = [NSDateCalendar getDayOfWeekWithDate:date];
            if (i==0) {
                [btn setTitle:[NSString stringWithFormat:@"%@%@",[timeArr firstObject],[NSDateCalendar getWeekStringWithInteger:number]] forState:UIControlStateNormal];
                [btn setImage:mImageByName(@"ic_signincalendar") forState:UIControlStateNormal];
            }else{
                [btn setTitle:[NSString stringWithFormat:@"当前时间：%@",[timeArr lastObject]] forState:UIControlStateNormal];
                [btn setImage:mImageByName(@"ic_signinclock") forState:UIControlStateNormal];
            }
            [_backView addSubview:btn];
        }
        
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(mScreenWidth/2, RELATIVE_WIDTH(10), 0.5, RELATIVE_WIDTH(70))];
        lineview.backgroundColor = halvingLineColor;
        [_backView addSubview:lineview];
        if (![_backView.superview isKindOfClass:[BMKMapView class]]) {
            [self initmapView];
        }
        }
        return _backView;
    }else{
        return nil;
    }
    
}

- (void)initmapView{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(90), mScreenWidth, RELATIVE_WIDTH(410))];
    _mapView.delegate = self;
    _mapView.userInteractionEnabled = NO;
    _mapView.showsUserLocation = NO; //是否显示定位图层（即我的位置的小圆点）
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 17;//地图显示比例
    [_backView addSubview:_mapView];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        static NSString *cellheadId = @"cellhead";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellheadId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellheadId];
        }
        if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RELATIVE_WIDTH(130), RELATIVE_WIDTH(130))];
        _headImage.layer.cornerRadius = RELATIVE_WIDTH(65);
        _headImage.center = CGPointMake(self.view.center.x, _headImage.center.y);
        [cell.contentView addSubview:_headImage];
        }
        [_headImage sd_setImageWithURL:mUrlWithString([AccountManager sharedManager].headImage) placeholderImage:mImageByName(@"ic_head_default")];

        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, GG_BOTTOM_Y(_headImage)+RELATIVE_WIDTH(20), mScreenWidth, RELATIVE_WIDTH(40))];
            _nameLabel.textColor = [UIColor whiteColor];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            _nameLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:_nameLabel];
        }
        _nameLabel.text = [AccountManager sharedManager].userName;

        if (!_signTimes) {
            _signTimes = [[UILabel alloc]initWithFrame:CGRectMake(0, GG_BOTTOM_Y(_nameLabel)+RELATIVE_WIDTH(20), mScreenWidth, RELATIVE_WIDTH(40))];
            _signTimes.textColor = [UIColor whiteColor];
            _signTimes.font = [UIFont systemFontOfSize:12];
            _signTimes.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:_signTimes];
        }
            _signTimes.text = [NSString stringWithFormat:@"今天您已签到%d次",0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = blueBackGround;
        return cell;
    }else{
        AddressModel *model =self.addressArray[indexPath.row];
        SignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SignInTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.tag = 10000+indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell setContentWithModel:model];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (NSInteger i =0; i<self.addressArray.count; i++) {
        SignInTableViewCell *cell = (SignInTableViewCell *)[self.view viewWithTag:10000+i];
        AddressModel *model =self.addressArray[i];
        if (i ==indexPath.row) {
            model.selected = YES;
        }else{
            model.selected = NO;
        }
        cell.selectedButton.selected = model.selected;

    }
}


-(void)startLocation{
    NSLog(@"开始定位");
    [_locService startUserLocationService];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
//    _location = userLocation;
    [self searchDeatilWithLocation:userLocation];
    [_locService stopUserLocationService];
}


- (void)searchDeatilWithLocation:(BMKUserLocation *)userLocation{
        NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=写字楼$酒店&location=%f,%f&radius=500&output=json&mcode=%@&ak=%@",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,mcode,BaiduCode];
        NSString *endUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",endUrl);
        [MapAddressNet excuteGetAddressWithURL:endUrl Success:^(id obj) {
            self.addressArray = [AddressModel mj_objectArrayWithKeyValuesArray:obj[@"results"]];
            //设置第一个数据的选中为yes;
            if (self.addressArray.count>0) {
                AddressModel *model = [self.addressArray firstObject];
                model.selected = YES;
            }
            [self.tableView reloadData];

        } failed:^(id obj) {
            
        }];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

-(void)signIn{
    AddressModel *addressModel = [[AddressModel alloc]init];
    for (AddressModel *model in self.addressArray) {
        if (model.selected == YES) {
            addressModel = model;
        }
    }
    DetailSigninViewController *detailSign = [[DetailSigninViewController alloc]init];
    detailSign.time = _time;
    detailSign.address = addressModel.name;
    detailSign.loca = addressModel.location;
    detailSign.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailSign animated:YES];
}


@end
