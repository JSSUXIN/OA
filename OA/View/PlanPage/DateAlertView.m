//
//  DateAlertView.m
//  OA
//
//  Created by Elon Musk on 16/7/18.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "DateAlertView.h"
#import "NSDateCalendar.h"

@interface DateAlertView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSArray *yearArray;
@property (nonatomic,strong)NSArray *monthArray;
@property (nonatomic,assign)NSInteger yearRow;
@property (nonatomic,assign)NSInteger monthRow;
@property (nonatomic,strong)UIPickerView *pickview;
@property (nonatomic,strong)UILabel *titleLabel;


@end

@implementation DateAlertView


-(NSArray *)yearArray{
    if (!_yearArray) {
        _yearArray = [NSArray array];
        _yearArray = @[@"2010年",@"2011年",@"2012年",@"2013年",@"2014年",@"2015年",@"2016年",@"2017年",@"2018年",@"2019年",@"2020年"];
    }
    return _yearArray;
}

- (NSArray *)monthArray{
    if (!_monthArray) {
        _monthArray = [NSArray array];
        _monthArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    }
    return _monthArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        self = [super initWithFrame:frame];
        [self creatUI];
        [self setTitleValue];

    }
    return self;
}

- (void)creatUI{
    UIView *backView = [[UIView alloc]initWithFrame:self.frame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(400), mScreenWidth-RELATIVE_WIDTH(40), RELATIVE_WIDTH(600))];
    view.center = self.center;
    view.layer.cornerRadius = RELATIVE_WIDTH(20);
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(10), mScreenWidth-RELATIVE_WIDTH(100), RELATIVE_WIDTH(80))];
    self.titleLabel.textColor = mRGBToColor(0x007aff);
    self.titleLabel.text = @"2016-7-18 星期一";
    self.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(30)];
    [view addSubview:self.titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(90), view.frame.size.width, 0.5)];
    line.backgroundColor = mRGBToColor(0x007aff);
    [view addSubview:line];
    
    self.pickview = [[UIPickerView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(120),
                                                                           RELATIVE_WIDTH(100),
                                                                           view.frame.size.width-RELATIVE_WIDTH(240),
                                                                           RELATIVE_WIDTH(410))];
    self.pickview.delegate = self;
    self.pickview.dataSource = self;
    [view addSubview:self.pickview];
    
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                    RELATIVE_WIDTH(510),
                                                                    view.frame.size.width/2,
                                                                    RELATIVE_WIDTH(90))];
    [okBtn setTitle:@"设定" forState:UIControlStateNormal];
    [okBtn setTitleColor:mRGBToColor(0x007aff) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:okBtn];

    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(okBtn.frame),
                                                                   okBtn.frame.origin.y,
                                                                   okBtn.frame.size.width,
                                                                   RELATIVE_WIDTH(90))];
    
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:mRGBToColor(0x007aff) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:cancleBtn];


    
    UIView *lineT = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(510), mScreenWidth-RELATIVE_WIDTH(40), 0.5)];
    lineT.backgroundColor = mRGBToColor(0x007aff);

    
    UIView *lineTh = [[UIView alloc]initWithFrame:CGRectMake(view.center.x-RELATIVE_WIDTH(20), RELATIVE_WIDTH(510), 0.5, RELATIVE_WIDTH(90))];
    lineTh.backgroundColor = mRGBToColor(0x007aff);

    [view addSubview:lineT];
    [view addSubview:lineTh];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.yearArray.count;
    }else{
        return self.monthArray.count;
    }
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return self.yearArray[row];
    }else{
        return self.monthArray[row];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return RELATIVE_WIDTH(90);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.yearRow=row;
    }else{
        self.monthRow = row;
    }
    NSLog(@"%@%@",self.yearArray[self.yearRow],self.monthArray[self.monthRow]);

}


- (void)cancle{
    [self removeFromSuperview];
}

- (void)ok{
    //执行代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(getDateWithYear:Month:)]) {
        [self.delegate getDateWithYear:self.yearArray[self.yearRow] Month:self.monthArray[self.monthRow]];
    }
    [self removeFromSuperview];
    
}


- (NSString *)getWeekOfDayWithDate:(NSDate *)date{
   NSInteger week = [NSDateCalendar getDayOfWeekWithDate:date];
    NSString *string = @"";
    switch (week) {
        case 1:
            string = @"星期一";
            break;
        case 2:
            string = @"星期二";

            break;
        case 3:
            string = @"星期三";

            break;
        case 4:
            string = @"星期四";

            break;
        case 5:
            string = @"星期五";

            break;
        case 6:
            string = @"星期六";

            break;
    
        default:
            string = @"星期日";

            break;
    }
    return string;
}

- (void)setTitleValue{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *time = [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:[NSDateCalendar getNowTime]],[self getWeekOfDayWithDate:[NSDateCalendar getNowTime]]];
    
    self.titleLabel.text = time;
    NSString *str = [formatter stringFromDate:[NSDateCalendar getNowTime]];
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSInteger valueOfYear = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%@年",array[0]]];
    self.yearRow = valueOfYear;
    NSString *tempString = @"";
    if ([array[1] integerValue]<10) {
        tempString = [NSString stringWithFormat:@"%ld",[array[1] integerValue]];
    }else{
        tempString = [NSString stringWithFormat:@"%@",array[1]];
    }
    NSInteger valueOfMonth = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%@月",tempString]];
    
    self.monthRow = valueOfMonth;
    
    [self.pickview selectRow:valueOfYear inComponent:0 animated:YES];
    [self.pickview selectRow:valueOfMonth inComponent:1 animated:YES];
}

@end
