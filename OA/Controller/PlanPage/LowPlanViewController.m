//
//  LowPlanViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/13.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "LowPlanViewController.h"
#import "CheckLowViewController.h"
#import "PlanNet.h"
#import "PlanModel.h"
#import "FilmView.h"
#import "NSDateCalendar.h"
#import "DateAlertView.h"


# define leftOrRightPadding RELATIVE_WIDTH(20)  //距左右边距
# define imageViewHeight RELATIVE_WIDTH(375)     //上部背景图高度
# define buttonHeight RELATIVE_WIDTH(150)         //button高度
#define marginWithImageAndButton RELATIVE_WIDTH(30)  //背景图和button之间的间隔
#define textViewHeight RELATIVE_WIDTH(300)          //
#define mViewHeight RELATIVE_WIDTH(260)

@interface LowPlanViewController ()<UITextViewDelegate,FilmScrollViewDelegate,FilmScrollViewDataSource,DateViewDelegate>

@property(nonatomic ,strong)UITextView *inputPlanTextView;
@property(nonatomic ,strong)UITextView *inputReportTextView;
@property(nonatomic ,strong)PlanModel *planModel;
@property(nonatomic ,copy) NSMutableArray *dayPlanArray;
@property(nonatomic ,copy) NSMutableArray *dateTitleArray;//展示出来的日期
@property(nonatomic ,copy) NSMutableArray *dateArray;//e.g  2016-07-11到2016-07-17
@property(nonatomic,strong)UIButton *textButton;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,assign) NSInteger ButtonIndex;


@end

@implementation LowPlanViewController{
    FilmView *mView;
    NSInteger _mIndex;
    dispatch_group_t _group;
    UIScrollView *_scrollview;
}

- (NSMutableArray *)dateArray{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}


- (NSMutableArray *)dayPlanArray{
    if (!_dayPlanArray) {
        _dayPlanArray = [NSMutableArray array];
    }
    return _dayPlanArray;
}

- (NSMutableArray *)dateTitleArray{
    if (!_dateTitleArray) {
        _dateTitleArray = [NSMutableArray array];
    }
    return _dateTitleArray;
}

-(void)loadView{
    [super loadView];
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.checkModel.name;
    self.uid = self.checkModel._id;
    NSLog(@"name = %@,uid = %@",self.checkModel.name,self.checkModel._id);
    [self initNavigationItem];
    [self initView];
    [self initDateSourceWithDate:[self setDate]];
}

- (NSString *)setDate{//初始化当前月
    NSDate *nowTime = [NSDateCalendar getNowTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *dateString =[NSString stringWithFormat:@"%@-01",[formatter stringFromDate:nowTime]];//表示 2016-07-01
    return dateString;
}

- (void)initDateSourceWithDate:(NSString *)dateString{//根据每月第一天时间计算周时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date = [NSDateCalendar getTimeWithDate:[dateFormatter dateFromString:dateString]];
    NSInteger monthInterger = [NSDateCalendar getNowMonthWithDate:date];//当前月
    NSInteger anotherMonth = [NSDateCalendar getNowMonthWithDate:date];
    NSInteger i = 0;
    while (monthInterger ==anotherMonth) {
        NSDate *thisMonday = [NSDateCalendar getThisMondayWithDate:date];//本周一
        NSDate *thisSunday = [NSDateCalendar getThisSundayWithDate:date];//本周末
        NSDate *nextMonday = [NSDateCalendar getNextMondayWithDate:date];//下周一
        if (i==0) {
            i=1;
            NSString *weekString = [NSString stringWithFormat:@"%@到%@",
                                    [dateFormatter stringFromDate:thisMonday],
                                    [dateFormatter stringFromDate:thisSunday]];
            [self.dateArray removeAllObjects];
            [self.dateArray addObject:weekString];
            date = nextMonday;
            
        }else{
            NSString *weekString = [NSString stringWithFormat:@"%@到%@",
                                    [dateFormatter stringFromDate:thisMonday],
                                    [dateFormatter stringFromDate:thisSunday]];
            [self.dateArray addObject:weekString];
            date = nextMonday;
            anotherMonth = [NSDateCalendar getNowMonthWithDate:date];
            
        }
    }
    NSDateFormatter *monthFormat = [[NSDateFormatter alloc]init];
    [monthFormat setDateFormat:@"MM.dd"];
    [self.dateTitleArray removeAllObjects];
    for (NSString *datestring in self.dateArray) {
        NSArray *array = [datestring componentsSeparatedByString:@"到"];
        NSString *showWeekString = [NSString stringWithFormat:@"%@.%@~%@.%@",
                                    [array[0] substringWithRange:NSMakeRange(5, 2)],
                                    [array[0] substringWithRange:NSMakeRange(8, 2)],
                                    [array[1] substringWithRange:NSMakeRange(5, 2)],
                                    [array[1] substringWithRange:NSMakeRange(8, 2)]];
        [self.dateTitleArray addObject:showWeekString];
    }
    [mView.pageScrollView reloadData];
    [self scrollWithScale];
}
#pragma mark -navigationItem

- (void)initNavigationItem{
    [self initTitleView];
}

- (void)initTitleView{

    self.textButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 90, 44)];
    self.textButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.textButton.titleLabel.textColor = [UIColor whiteColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *temp = [formatter stringFromDate:[NSDateCalendar getNowTime]];
    NSArray *array = [temp componentsSeparatedByString:@"-"];
    [self.textButton setTitle:[NSString stringWithFormat:@"%@年%ld月",array[0],(long)[array[1] integerValue]] forState:UIControlStateNormal];
    [self.textButton setImage:mImageByName(@"ic_direction_down") forState:UIControlStateNormal];
    
    [self.textButton setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.textButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [self.textButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.textButton;
}


#pragma mark -initView

- (void)initView{
    _scrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollview.contentSize = self.view.frame.size;
    _scrollview.scrollEnabled = YES;
    _scrollview.bounces = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollview];
    
    [self initDateView];
    [self initContentView];
    [self initBorder];
    
}

- (void)initDateView{
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, imageViewHeight)];
    backImageView.contentMode =UIViewContentModeScaleAspectFit;
    backImageView.image = mImageByName(@"ic_date_low_background");
    [_scrollview addSubview:backImageView];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(20), RELATIVE_WIDTH(90), RELATIVE_WIDTH(90))];
    headImageView.center = CGPointMake(self.view.center.x, headImageView.center.y);
    headImageView.layer.cornerRadius = RELATIVE_WIDTH(45);
    headImageView.layer.masksToBounds = YES;
    [headImageView sd_setImageWithURL:mUrlWithString(self.checkModel.headImg) placeholderImage:mImageByName(@"ic_head_default")];
    [_scrollview addSubview:headImageView];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, GG_BOTTOM_Y(headImageView)+RELATIVE_WIDTH(10), mScreenWidth, RELATIVE_WIDTH(40))];
    nameLabel.text = self.checkModel.name;
    nameLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(30)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollview addSubview:nameLabel];

    //滚动电影图效果
    mView = [[FilmView alloc] initWithFrame:CGRectMake(0, imageViewHeight-mViewHeight, mScreenWidth, mViewHeight)];
    mView.pageScrollView.dataSource = self;
    mView.pageScrollView.delegate = self;
    mView.pageScrollView.padding = 20;
    mView.pageScrollView.leftRightOffset = 0;
    mView.pageScrollView.frame = CGRectMake((mScreenWidth-100)/2, 0, 100, mViewHeight);
    [_scrollview addSubview:mView];
}

- (void)initBorder{//绘画边框
    for (NSInteger i =0; i<15; i++) {
        if (i==0) {
            UIView *lineHorView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding, imageViewHeight+marginWithImageAndButton, mScreenWidth - 2*leftOrRightPadding, 0.5)];
            lineHorView.tag = 100000+i;
            [_scrollview addSubview:lineHorView];
        }
        else if(i>0&&i<4){
            UIView *lineHorView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding,
                                                                          imageViewHeight+buttonHeight+marginWithImageAndButton+RELATIVE_WIDTH(300)*(i-1),  mScreenWidth - 2*leftOrRightPadding, 0.5)];
            lineHorView.tag = 100000+i;
            [_scrollview addSubview:lineHorView];
        }
        else if(i >=4&&i<13){
            UIView *lineVerView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding+(mScreenWidth-2*leftOrRightPadding)/8*(i-4), imageViewHeight+marginWithImageAndButton, 0.5, buttonHeight)];
            lineVerView.tag = 100000+i;
            [_scrollview addSubview:lineVerView];
        }else{
            UIView *lineVerView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding+(mScreenWidth - 2*leftOrRightPadding)*(i-13), imageViewHeight+marginWithImageAndButton+buttonHeight, 0.5, 2*textViewHeight)];
            lineVerView.tag = 100000+i;
            [_scrollview addSubview:lineVerView];
        }
    }
}
- (void)initContentView{
    NSArray *btnArray = @[@"本\n周",@"周\n一",@"周\n二",@"周\n三",@"周\n四",@"周\n五",@"周\n六",@"周\n日"];
    
    for (NSInteger i = 0; i<8; i++) {
        UIButton *dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dayBtn.frame = CGRectMake((mScreenWidth -2* leftOrRightPadding)/8*i +leftOrRightPadding,
                                  imageViewHeight + marginWithImageAndButton,
                                  (mScreenWidth- 2*leftOrRightPadding)/8,
                                  buttonHeight);
        dayBtn.tag = 10000+i;
        dayBtn.titleLabel.numberOfLines = 0;
        dayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        dayBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [dayBtn setTitle:btnArray[i] forState:UIControlStateNormal];
        [dayBtn addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollview addSubview:dayBtn];
    }
    self.inputPlanTextView = [[UITextView alloc]initWithFrame:CGRectMake(leftOrRightPadding, imageViewHeight+buttonHeight+marginWithImageAndButton, mScreenWidth - 2*leftOrRightPadding, textViewHeight)];
    self.inputPlanTextView.delegate = self;
    self.inputPlanTextView.font = [UIFont systemFontOfSize:15];

    self.inputPlanTextView.textAlignment = NSTextAlignmentLeft;
    [_scrollview addSubview:self.inputPlanTextView];
    
    self.inputReportTextView = [[UITextView alloc]initWithFrame:CGRectMake(leftOrRightPadding, GG_BOTTOM_Y(self.inputPlanTextView), GG_W(self.inputPlanTextView), textViewHeight)];
    self.inputReportTextView.delegate = self;
    self.inputReportTextView.font = [UIFont systemFontOfSize:15];
    self.inputReportTextView.textAlignment = NSTextAlignmentLeft;
    [_scrollview addSubview:self.inputReportTextView];
}


- (void)checkLow{//点击查看下级
    CheckLowViewController *checkLow = [[CheckLowViewController alloc]init];
    checkLow.title = @"下级列表";
    checkLow.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkLow animated:YES];
    
}

- (void)alert{//datepicker 弹窗
    DateAlertView *backView = [[DateAlertView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    backView.delegate = self;
    [self.view.window addSubview:backView];
}

- (void)moveToNow{
    [self initDateSourceWithDate:[self setDate]];
}

- (void)showContent:(UIButton *)btn{
    [self.inputPlanTextView resignFirstResponder];
    [self.inputReportTextView resignFirstResponder];

//    NSLog(@"%d",btn.tag);
    for (NSInteger i =0; i<8; i++) {
        if (i==btn.tag-10000) {
            btn.selected = YES;
        }else{
            UIButton *button = (UIButton *)[self.view viewWithTag:10000+i];
            button.selected = NO;
        }
    }
    switch (btn.tag-10000) {
        case 0:{
            [self setWeekContent];
        }
            break;
        default:
            [self setDayPlanContentWithIndex:btn.tag-10000];
            break;
    }
}

- (void)setWeekContent{
    self.inputPlanTextView.text = [NSString filterHTML:self.planModel.planContent];
    self.inputReportTextView.text = [NSString filterHTML:self.planModel.reportContent];
    NSLog(@"self.planModel.planContent = %@,self.planModel.reportContent = %@",self.planModel.planContent,self.planModel.reportContent);
}

- (void)setDayPlanContentWithIndex:(NSInteger )index{
    PlanModel *mPlanModel = [[PlanModel alloc]init];
    if (self.dayPlanArray.count>0) {
        mPlanModel = self.dayPlanArray[index-1];
        self.inputPlanTextView.text = [NSString filterHTML:mPlanModel.planContent];
        self.inputReportTextView.text = [NSString filterHTML:mPlanModel.reportContent];
    }else{
        for (NSInteger i =0; i<7; i++) {
            PlanModel *model = [[PlanModel alloc]init];
            model.planContent = @"";
            model.reportContent = @"";
            [self.dayPlanArray addObject:model];
        }
    }
}


#pragma mark - feachData

- (void)feachDataWithStartTIme:(NSString *)startTime endTime:(NSString *)endTime{
    [MBProgressHUD showHUD:@"正在加载"];
    _group = dispatch_group_create();
    
    dispatch_group_enter(_group);
    [self feachWeekPlanWithStartTIme:startTime endTime:endTime];
    NSLog(@"weekPlan数据加载完成!!");
    dispatch_group_enter(_group);
    [self feachDayPlanWithStartTIme:startTime endTime:endTime];
    NSLog(@"dayPlan数据加载完成!!!");
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{//只有执行了group_leave才可以执行此行
        NSLog(@"全部加载完成");
        [MBProgressHUD hideHUD];
        for (NSInteger i =0; i<8; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:10000+i];
            if (button.tag == 10000) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
        self.ButtonIndex =0;
        [self setWeekContent];
    });
    
    
}


- (void)feachWeekPlanWithStartTIme:(NSString *)startTime endTime:(NSString *)endTime{
    [PlanNet excuteGetWeekPlanWithUid:self.uid startTime:startTime endTime:endTime success:^(id obj) {
        self.planModel = obj;
        NSLog(@"%@,%@",self.planModel.planContent,self.planModel.reportContent);
        dispatch_group_leave(_group);
        
    } failed:^(id obj) {
        dispatch_group_leave(_group);
        
    }];
}

- (void)feachDayPlanWithStartTIme:(NSString *)startTime endTime:(NSString *)endTime{
    [PlanNet excuteGetDayPlanWithUid:self.uid startTime:startTime endTime:endTime success:^(id obj) {
        [self.dayPlanArray removeAllObjects];
        [self.dayPlanArray addObjectsFromArray:obj];
        dispatch_group_leave(_group);
        
    } failed:^(id obj) {
        dispatch_group_leave(_group);
        
    }];
}


#pragma mark - scrollView delegate
- (NSInteger)numberOfPageInPageScrollView:(FilmScrollView*)pageScrollView{
    return [self.dateTitleArray count];
}
- (UIView*)pageScrollView:(FilmScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    cell.tag = 40000+index;
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backImage.tag = 20000+index;
    UILabel *dateTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    if ([self isThisWeekWithIndex:(int)index] ==YES) {
        [backImage setImage:mImageByName(@"ic_textplan_yellow")];
    }else{
        [backImage setImage:mImageByName(@"ic_textplan_default")];
    }
    dateTextLabel.textAlignment = NSTextAlignmentCenter;
    dateTextLabel.backgroundColor = [UIColor clearColor];
    dateTextLabel.tag = 30000+index;
    dateTextLabel.text = self.dateTitleArray[index];
    dateTextLabel.font = [UIFont systemFontOfSize:10];
    [cell addSubview:backImage];
    [cell addSubview:dateTextLabel];
    if (index == 0) {
        cell.frame = CGRectMake(-10, -10, 100, 60);
        backImage.frame = CGRectMake(-5, -10, cell.frame.size.width, cell.frame.size.height);
        dateTextLabel.frame = CGRectMake(-5, -10, cell.frame.size.width, cell.frame.size.height);
        dateTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return cell;
}
- (CGSize)sizeCellForPageScrollView:(FilmScrollView*)pageScrollView
{
    return CGSizeMake(80, 40);
}
- (void)pageScrollView:(FilmScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    [self ScaleWithIndex:index];
    if (_mIndex !=index) {
        [self getStartTimeAndEndTimeWithIndex:index];
        _mIndex = index;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"offsetX = %f,,,,width = %f",scrollView.contentOffset.x,scrollView.frame.size.width);
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self ScaleWithIndex:index];
    if (_mIndex !=index) {
        [self getStartTimeAndEndTimeWithIndex:index];
        _mIndex = index;
    }
}


#pragma mark - dateAlertDelegate
- (void)getDateWithYear:(NSString *)year Month:(NSString *)month{//Alertview的代理
    NSString *yearTime = [year substringToIndex:4];
    //    NSRange range = [month rangeOfString:@"月"];//匹配得到的下标
    int monthInt = [month intValue];
    NSString *monthTime  = @"";
    if (monthInt<10) {
        monthTime = [NSString stringWithFormat:@"0%d",monthInt];
    }else{
        monthTime = [NSString stringWithFormat:@"%d",monthInt];
    }
    NSString *dateString =[NSString stringWithFormat:@"%@-%@-01",yearTime,monthTime];//表示 2016-07-01
    
    [self.textButton setTitle:[NSString stringWithFormat:@"%@%@",year,month] forState:UIControlStateNormal];
    [mView.pageScrollView reloadData];
    
    [self initDateSourceWithDate:dateString];
}

#pragma mark - others

- (BOOL)isThisWeekWithIndex:(int)index{//判断是否是本周
    NSString *string =  self.dateArray[index];
    NSArray *array = [string componentsSeparatedByString:@"到"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFir = [formatter dateFromString:array[0]];
    NSDate *dateSec = [formatter dateFromString:array[1]];
    NSDate *now = [NSDateCalendar getNowTime];
    if ((now == [now earlierDate:dateSec]||[now isEqualToDate:dateSec])&&(now == [dateFir laterDate:now]||[now isEqualToDate:dateFir])) {
        return YES;
    }else{
        return NO;
    }
}


- (void)getStartTimeAndEndTimeWithIndex:(NSInteger )index{//拨动scrollview，重新刷取数据，
    NSString *string = self.dateArray[index];

        for (NSInteger i = 0; i<15; i++) {
            UIView *boardView = [self.view viewWithTag:100000+i];
            boardView.backgroundColor = mRGBToColor(0xA0A0A0);
        }
        self.inputPlanTextView.editable = NO;
        self.inputReportTextView.editable = NO;
        for (NSInteger i = 0; i<8; i++) {
            UIButton *btn = [self.view viewWithTag:10000+i];
            [btn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateSelected];
            [btn setTitleColor:mRGBToColor(0xA0A0A0) forState:UIControlStateNormal];
            [btn setBackgroundColor:mRGBToColor(0xA0A0A0) forState:UIControlStateSelected];
            [btn setBackgroundColor:mRGBToColor(0xf3f3f7) forState:UIControlStateNormal];
        }
    
    NSArray *array = [string componentsSeparatedByString:@"到"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startTime = [formatter dateFromString:array[0]];
    NSDate *endTime = [formatter dateFromString:array[1]];
    [self feachDataWithStartTIme:[formatter stringFromDate:startTime] endTime:[formatter stringFromDate:endTime]];
}


- (NSInteger)scrollerToindex{//判断当前周是第几个item，本月就跳转到当前周，否则显示第一个
    NSInteger index = 0;
    for (NSInteger i = 0;i<self.dateArray.count;i++) {
        NSString *dateString = self.dateArray[i];
        NSArray *array = [dateString componentsSeparatedByString:@"到"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startTime = [formatter dateFromString:array[0]];
        NSDate *endTime = [formatter dateFromString:array[1]];
        NSDate *now = [NSDateCalendar getNowTime];
        if ((now == [now earlierDate:endTime]||[now isEqualToDate:endTime])&&(now == [startTime laterDate:now]||[now isEqualToDate:startTime])) {
            index = i;
            break;
        }else{
            index = 0;
        }
    }
    NSLog(@"滑动到第%ld个",(long)index);
    return index;
}


-(void)scrollWithScale{//跳转到当前周并放大
    NSInteger index = [self scrollerToindex];
    _mIndex = index;
    [mView.pageScrollView setContentOffset:CGPointMake(100*index, 0)];
    [self ScaleWithIndex:index];
    [self getStartTimeAndEndTimeWithIndex:index];
}

- (void)ScaleWithIndex:(NSInteger )index{//选中的item进行放大，其他的大小还原
    UIView *cell = (UIView *)[mView viewWithTag:40000+index];
    UILabel *dateTextLabel = (UILabel *)[cell viewWithTag:30000+index];
    UIImageView *backImage = (UIImageView *)[cell viewWithTag:20000+index];
    [UIView animateWithDuration:0.3 animations:^{
        backImage.frame = CGRectMake(-10, -10, 100, 60);
        dateTextLabel.frame = CGRectMake(-10, -10, 100, 60);
        dateTextLabel.font = [UIFont systemFontOfSize:15];
        dateTextLabel.textColor = [UIColor whiteColor];
        //        coverString = images[index];
    }];
    for (int i = 0; i < self.dateTitleArray.count; i++) {
        if (i != index) {
            UIView *cell = (UIView *)[mView viewWithTag:40000+i];
            UILabel *dateTextLabel = (UILabel *)[cell viewWithTag:30000+i];
            UIImageView *backImage = (UIImageView *)[cell viewWithTag:20000+i];
            [UIView animateWithDuration:0.3 animations:^{
                backImage.frame = CGRectMake(0, 0, 80, 40);
                dateTextLabel.frame = CGRectMake(0, 0, 80, 40);
                dateTextLabel.textColor = [UIColor whiteColor];
                dateTextLabel.font = [UIFont systemFontOfSize:10];
            }];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
