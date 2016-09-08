//
//  PlanViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "PlanViewController.h"
#import "CheckLowViewController.h"
#import "PlanNet.h"
#import "PlanModel.h"
#import "FilmView.h"
#import "NSDateCalendar.h"
#import "DateAlertView.h"



# define leftOrRightPadding RELATIVE_WIDTH(20)  //距左右边距
# define imageViewHeight RELATIVE_WIDTH(260)     //上部背景图高度
# define buttonHeght RELATIVE_WIDTH(150)         //button高度
#define marginWithImageAndButton RELATIVE_WIDTH(30)  //背景图和button之间的间隔
#define textViewHeight RELATIVE_WIDTH(300)          //textview高度




@interface PlanViewController ()<UITextViewDelegate,FilmScrollViewDelegate,FilmScrollViewDataSource,DateViewDelegate>

@property(nonatomic ,strong)UITextView *inputPlanTextView;
@property(nonatomic ,strong)UITextView *inputReportTextView;

@property (nonatomic,strong) UILabel *planPlaceHodler;

@property (nonatomic,strong) UILabel *reportPlanHodler;
@property(nonatomic ,strong)PlanModel *planModel;
@property(nonatomic ,copy) NSMutableArray *dayPlanArray;
@property(nonatomic ,copy) NSMutableArray *dateTitleArray;//展示出来的日期
@property(nonatomic ,copy) NSMutableArray *dateArray;//e.g  2016-07-11到2016-07-17
@property(nonatomic,strong)UIButton *textButton;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,assign) NSInteger ButtonIndex;


@end

@implementation PlanViewController{
    FilmView *mView;
    NSInteger _mIndex;
    dispatch_group_t _group;
//    NSString *coverString;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uid = [AccountManager sharedManager].uid;
    [self initNavigationItem];
    [self initView];
    [self initDateSourceWithDate:[self setDate]];
    
    // Do any additional setup after loading the view.
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
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc]initWithImage:mImageByName(@"ic_check_low") style:UIBarButtonItemStylePlain target:self action:@selector(checkLow)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, imageItem, nil];
    
    [self initTitleView];
    
//    修改item字体大小颜色
//    [leftButton setTitleTextAttributes:[NSDictionarydictionaryWithObjectsAndKeys:
//                                       [UIFontfontWithName:@"Helvetica-Bold"size:17.0],NSFontAttributeName,
//                                       [UIColorgreenColor],NSForegroundColorAttributeName,
//                                       nil] 
//                             forState:UIControlStateNormal];
}

- (void)initTitleView{
    self.textButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 90, 44)];
    self.textButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.textButton.titleLabel.textColor = [UIColor whiteColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *temp = [formatter stringFromDate:[NSDateCalendar getNowTime]];
    NSArray *array = [temp componentsSeparatedByString:@"-"];
    [self.textButton setTitle:[NSString stringWithFormat:@"%@年%ld月",array[0],[array[1] integerValue]] forState:UIControlStateNormal];
    [self.textButton setImage:mImageByName(@"ic_direction_down") forState:UIControlStateNormal];
    
    [self.textButton setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.textButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [self.textButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.textButton;
}



#pragma mark -initView

- (void)initView{
    [self initDateView];
    [self initContentView];
    [self initBorder];

}

- (void)initDateView{
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, imageViewHeight)];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    backImageView.image =  mImageByName(@"ic_date_background");
    
    [self.view addSubview:backImageView];
    //滚动电影图效果
    mView = [[FilmView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, imageViewHeight)];
    mView.backgroundColor = [UIColor clearColor];
    mView.pageScrollView.dataSource = self;
    mView.pageScrollView.delegate = self;
    mView.pageScrollView.padding = 20;
    mView.pageScrollView.leftRightOffset = 0;
    mView.pageScrollView.frame = CGRectMake((mScreenWidth-100)/2, 0, 100, imageViewHeight);
    [self.view addSubview:mView];
}


- (void)initBorder{//绘画边框
    for (NSInteger i =0; i<15; i++) {
        if (i==0) {
            UIView *lineHorView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding, imageViewHeight+marginWithImageAndButton, mScreenWidth - 2*leftOrRightPadding, 0.5)];
            lineHorView.tag = 100000+i;
            [self.view addSubview:lineHorView];
        }
        else if(i>0&&i<4){
            UIView *lineHorView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding,
                                                                          imageViewHeight+buttonHeght+marginWithImageAndButton+RELATIVE_WIDTH(300)*(i-1),  mScreenWidth - 2*leftOrRightPadding, 0.5)];
            lineHorView.tag = 100000+i;
            [self.view addSubview:lineHorView];
        }
        else if(i >=4&&i<13){
            UIView *lineVerView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding+(mScreenWidth-2*leftOrRightPadding)/8*(i-4), imageViewHeight+marginWithImageAndButton, 0.5, buttonHeght)];
            lineVerView.tag = 100000+i;
            [self.view addSubview:lineVerView];
        }else{
            UIView *lineVerView = [[UIView alloc]initWithFrame:CGRectMake(leftOrRightPadding+(mScreenWidth - 2*leftOrRightPadding)*(i-13), imageViewHeight+marginWithImageAndButton+buttonHeght, 0.5, 2*textViewHeight)];
            lineVerView.tag = 100000+i;
            [self.view addSubview:lineVerView];
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
                                  buttonHeght);
        dayBtn.tag = 10000+i;
        dayBtn.titleLabel.numberOfLines = 0;
        dayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        dayBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [dayBtn setTitle:btnArray[i] forState:UIControlStateNormal];
        [dayBtn addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dayBtn];
    }
    self.inputPlanTextView = [[UITextView alloc]initWithFrame:CGRectMake(leftOrRightPadding, imageViewHeight+buttonHeght+marginWithImageAndButton, mScreenWidth - 2*leftOrRightPadding, textViewHeight)];
    self.inputPlanTextView.delegate = self;
    self.inputPlanTextView.scrollEnabled = YES;
    self.inputPlanTextView.font = [UIFont systemFontOfSize:15];
    self.inputPlanTextView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.inputPlanTextView];
    
    self.planPlaceHodler = [[UILabel alloc]initWithFrame:CGRectMake(10, RELATIVE_WIDTH(10), 100, 20)];
    self.planPlaceHodler.layer.borderColor =grayTextcolor.CGColor;
    self.planPlaceHodler.layer.borderWidth = 0.5;
    self.planPlaceHodler.layer.cornerRadius = 10;
    self.planPlaceHodler.font = mFont(12);
    self.planPlaceHodler.textAlignment = NSTextAlignmentCenter;
    self.planPlaceHodler.textColor = grayTextcolor;
    [self.inputPlanTextView addSubview:self.planPlaceHodler];

    self.inputReportTextView = [[UITextView alloc]initWithFrame:CGRectMake(leftOrRightPadding, GG_BOTTOM_Y(self.inputPlanTextView), GG_W(self.inputPlanTextView), textViewHeight)];
    self.inputReportTextView.delegate = self;
    self.inputReportTextView.scrollEnabled = YES;
    self.inputReportTextView.font = [UIFont systemFontOfSize:15];
    self.inputReportTextView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.inputReportTextView];
    
    self.reportPlanHodler = [[UILabel alloc]initWithFrame:CGRectMake(10, RELATIVE_WIDTH(10), 100, 20)];
    self.reportPlanHodler.font = mFont(12);
    self.reportPlanHodler.layer.borderWidth = 0.5;
    self.reportPlanHodler.layer.borderColor = grayTextcolor.CGColor;
    self.reportPlanHodler.layer.cornerRadius = 10;
    self.reportPlanHodler.textAlignment = NSTextAlignmentCenter;
    self.reportPlanHodler.textColor = grayTextcolor;
    [self.inputReportTextView addSubview:self.reportPlanHodler];

}

#pragma mark - clickListening
- (void)checkLow{//点击查看下级
    CheckLowViewController *checkLow = [[CheckLowViewController alloc]init];
    checkLow.title = @"下级列表";
    checkLow.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkLow animated:YES];

}

- (void)alert{//datepicker 弹窗
    [self.inputPlanTextView resignFirstResponder];
    [self.inputReportTextView resignFirstResponder];

    DateAlertView *backView = [[DateAlertView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    backView.delegate = self;
    [self.view.window addSubview:backView];
}

- (void)saveData{//保存按钮
    [self.inputPlanTextView resignFirstResponder];
    [self.inputReportTextView resignFirstResponder];
    [self postPlan];
}

- (void)moveToNow{
    [self initDateSourceWithDate:[self setDate]];
}

- (void)showContent:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
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
            if ([self isThisWeekWithIndex:(int)_mIndex]) {
                [self setPlanModelWithIndex:self.ButtonIndex];
                self.ButtonIndex = 0;
            }
            [self setWeekContent];
            [self setWeekPlaceHolder];
        }
            break;
        default:
            if ([self isThisWeekWithIndex:(int)_mIndex]) {
                [self setPlanModelWithIndex:self.ButtonIndex];
                self.ButtonIndex = btn.tag-10000;
            }
            [self setDayPlanContentWithIndex:btn.tag-10000];
            [self setDayPlaceHodler];

            break;
    }
}
- (void)setPlanModelWithIndex:(NSInteger )index{//每次点击button都要保存上次的数据
    if (index==0) {
        self.planModel.planContent = self.inputPlanTextView.text;
        self.planModel.reportContent = self.inputReportTextView.text;
    }else{
            PlanModel *dayModel = [[PlanModel alloc]init];
            dayModel =self.dayPlanArray[index-1];
            dayModel.planContent = self.inputPlanTextView.text;
            dayModel.reportContent = self.inputReportTextView.text;
        }
}

- (void)setWeekContent{
    self.inputPlanTextView.text = [NSString filterHTML:self.planModel.planContent];
    self.inputReportTextView.text = [NSString filterHTML:self.planModel.reportContent];
    NSLog(@"self.planModel.planContent = %@,self.planModel.reportContent = %@",self.planModel.planContent,self.planModel.reportContent);
}

- (void)setDayPlanContentWithIndex:(NSInteger )index{
    PlanModel *mPlanModel = [[PlanModel alloc]init];
        mPlanModel = self.dayPlanArray[index-1];
        self.inputPlanTextView.text = [NSString filterHTML:mPlanModel.planContent];
        self.inputReportTextView.text = [NSString filterHTML:mPlanModel.reportContent];
}

#pragma -placeHolder

- (void)setDayPlaceHodler{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:mFont(12),NSFontAttributeName,nil];

    if ([self.inputPlanTextView.text isEqualToString:@""]) {
        self.planPlaceHodler.hidden = NO;
        self.planPlaceHodler.text = @"工作计划";
        self.planPlaceHodler.frame = CGRectMake(10, RELATIVE_WIDTH(10),RealSize(self.planPlaceHodler.text, MaxedSize,dict).width +6, 20);

    }else{
        self.planPlaceHodler.hidden = YES;
    }
    if ([self.inputReportTextView.text isEqualToString:@""]) {
        self.reportPlanHodler.hidden = NO;
        self.reportPlanHodler.text = @"工作总结";
        self.reportPlanHodler.frame = CGRectMake(10, RELATIVE_WIDTH(10),RealSize(self.reportPlanHodler.text, MaxedSize,dict).width+6 , 20);
    }else{
        self.reportPlanHodler.hidden = YES;
    }
}

- (void)setWeekPlaceHolder{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:mFont(12),NSFontAttributeName,nil];
    
    if ([self.inputPlanTextView.text isEqualToString:@""]) {
        self.planPlaceHodler.hidden = NO;
        self.planPlaceHodler.text = @"周工作计划";
        self.planPlaceHodler.frame = CGRectMake(10, RELATIVE_WIDTH(10),RealSize(self.planPlaceHodler.text, MaxedSize,dict).width +6, 20);
        
    }else{
        self.planPlaceHodler.hidden = YES;
    }
    if ([self.inputReportTextView.text isEqualToString:@""]) {
        self.reportPlanHodler.hidden = NO;
        self.reportPlanHodler.text = @"周工作总结";
        self.reportPlanHodler.frame = CGRectMake(10, RELATIVE_WIDTH(10),RealSize(self.reportPlanHodler.text, MaxedSize,dict).width+6 , 20);
    }else{
        self.reportPlanHodler.hidden = YES;
    }
}

#pragma mark -editviewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView ==self.inputPlanTextView) {
        if (![text isEqualToString:@""])
            
        {
            self.planPlaceHodler.hidden = YES;
        }
        
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
            
        {
            self.planPlaceHodler.hidden = NO;
        }
        
        return YES;

    }else{
        if (![text isEqualToString:@""])
            
        {
            self.reportPlanHodler.hidden = YES;
        }
        
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
            
        {
            self.reportPlanHodler.hidden = NO;
        }
        
        return YES;

    }
    
    
}

#pragma mark - feachData

- (void)feachDataWithStartTIme:(NSString *)startTime endTime:(NSString *)endTime{
    _group = dispatch_group_create();
    [MBProgressHUD showHUD:@"正在加载"];

    dispatch_group_enter(_group);
    [self feachWeekPlanWithStartTIme:startTime endTime:endTime];
    NSLog(@"weekPlan数据加载完成!!");
    dispatch_group_enter(_group);
    [self feachDayPlanWithStartTIme:startTime endTime:endTime];
    NSLog(@"dayPlan数据加载完成!!!");
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{//只有执行了group_leave才可以执行此行
        [MBProgressHUD hideHUD];
        NSLog(@"全部加载完成");
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
        [self setWeekPlaceHolder];
    });
    
}

- (void)feachWeekPlanWithStartTIme:(NSString *)startTime endTime:(NSString *)endTime{
    [PlanNet excuteGetWeekPlanWithUid:self.uid startTime:startTime endTime:endTime success:^(id obj) {
        self.planModel = obj;
        NSLog(@"%@,%@",self.planModel.planContent,self.planModel.reportContent);
        dispatch_group_leave(_group);

    } failed:^(id obj) {
        dispatch_group_leave(_group);

        [MBProgressHUD showText_b:@"获取数据失败"];
    }];
}

- (void)feachDayPlanWithStartTIme:(NSString *)startTime endTime:(NSString *)endTime{
    [PlanNet excuteGetDayPlanWithUid:self.uid startTime:startTime endTime:endTime success:^(id obj) {
        [self.dayPlanArray removeAllObjects];
        if ([(NSArray *)obj count]>0) {
            [self.dayPlanArray addObjectsFromArray:obj];
        }else{
            for (NSInteger i =0; i<7; i++) {
                PlanModel *model = [[PlanModel alloc]init];
                model.planContent = @"";
                model.reportContent = @"";
                [self.dayPlanArray addObject:model];
            }
        }
        
        dispatch_group_leave(_group);

    } failed:^(id obj) {
        dispatch_group_leave(_group);

        [MBProgressHUD showText_b:@"获取数据失败"];
    }];
}

- (void)postPlan{//上传数据
    [self setPlanModelWithIndex:self.ButtonIndex];
    NSString *string = self.dateArray[_mIndex];
    NSArray *array = [string componentsSeparatedByString:@"到"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startTime = [formatter dateFromString:array[0]];
    NSDate *endTime = [formatter dateFromString:array[1]];
    [MBProgressHUD showHUD:@"正在保存"];
    [PlanNet excutePostPlanWithUid:self.uid
                         startTime:[formatter stringFromDate:startTime]
                           endTime:[formatter stringFromDate:endTime]
                          weekPlan:self.planModel.planContent
                        weekReport:self.planModel.reportContent
                      dayPlanArray:[NSArray arrayWithArray:self.dayPlanArray]
                           success:^(id obj) {
                               [MBProgressHUD hideHUD];
                               [MBProgressHUD showText_b:@"保存成功"];
                               NSLog(@"%@",obj);
                           } failed:^(id obj) {
                               [MBProgressHUD hideHUD];
                               [MBProgressHUD showText_b:@"保存失败"];
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
        [self saveOrTodayWithIndex:index];
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
        [self saveOrTodayWithIndex:index];
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
    NSDate *dateFir =[NSDateCalendar getTimeWithDate:[formatter dateFromString:array[0]]];
    NSDate *dateSec = [NSDateCalendar getNextMondayWithDate:dateFir];
    NSDate *now = [NSDateCalendar getNowTime];
    if ((now == [now earlierDate:dateSec]||[now isEqualToDate:dateSec])&&(now == [dateFir laterDate:now]||[now isEqualToDate:dateFir])) {
        return YES;//yellow
    }else{
        return NO;
    }
}


- (void)getStartTimeAndEndTimeWithIndex:(NSInteger )index{//拨动scrollview，重新刷取数据，并且在该处判断边框线颜色和button背景色显示，textview是否可被编辑
    NSString *string = self.dateArray[index];
    if ([self isThisWeekWithIndex:(int)index]) {
        for (NSInteger i = 0; i<15; i++) {
            UIView *boardView = [self.view viewWithTag:100000+i];
            boardView.backgroundColor = mRGBToColor(0x007aff);
        }
        self.inputPlanTextView.editable = YES;
        self.inputReportTextView.editable = YES;
        for (NSInteger i = 0; i<8; i++) {
            UIButton *btn = [self.view viewWithTag:10000+i];
            [btn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateSelected];
            [btn setTitleColor:mRGBToColor(0x007aff) forState:UIControlStateNormal];
            [btn setBackgroundColor:mRGBToColor(0x007AFF) forState:UIControlStateSelected];
            [btn setBackgroundColor:mRGBToColor(0xeff7ff) forState:UIControlStateNormal];
        }
    }else{
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
    NSLog(@"滑动到第%ld个",index);
    return index;
}


-(void)scrollWithScale{//跳转到当前周并放大
    NSInteger index = [self scrollerToindex];
    _mIndex = index;
    [mView.pageScrollView setContentOffset:CGPointMake(100*index, 0)];
    [self ScaleWithIndex:index];
    [self getStartTimeAndEndTimeWithIndex:index];
    [self saveOrTodayWithIndex:index];
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

- (void)saveOrTodayWithIndex:(NSInteger)index{//导航栏保存图标和今的切换判断
    if ([self isThisWeekWithIndex:(int)index]) {
        UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
        [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = saveBtn;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
        negativeSpacer.width = 0;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,saveBtn,nil];
        
    }else{
        UIBarButtonItem *imaItem = [[UIBarButtonItem alloc]initWithImage:mImageByName(@"ic_today") style:UIBarButtonItemStyleDone target:self action:@selector(moveToNow)];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,imaItem,nil];
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
