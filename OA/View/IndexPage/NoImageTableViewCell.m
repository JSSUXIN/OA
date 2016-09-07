//
//  NoImageTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/4.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "NoImageTableViewCell.h"

#define widthWithTimeImage RELATIVE_WIDTH(30)
#define widthWithDetailImage RELATIVE_WIDTH(250)
#define heightWithDetailImage RELATIVE_WIDTH(200)

#define titleFont 15//标题字体大小
#define timeFont RELATIVE_WIDTH(25)//时间字体大小

#define leftPadding RELATIVE_WIDTH(20)//左右边距
#define upPadding  RELATIVE_WIDTH(20)//上下边距

#define cellHeight


@implementation NoImageTableViewCell{
    UIImageView *_timeImageView;
    UIView *_lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUiView];
    }
    return self;
}

- (void)initUiView{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftPadding, upPadding, mScreenWidth - 2*leftPadding, RELATIVE_WIDTH(60))];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, RELATIVE_WIDTH(38));
    [self.contentView addSubview:_titleLabel];
    _timeImageView = [[UIImageView alloc]initWithImage:mImageByName(@"ic_time")];
    _timeImageView.frame = CGRectMake(leftPadding, RELATIVE_WIDTH(100), widthWithTimeImage, widthWithTimeImage);
    _timeImageView.center = CGPointMake(_timeImageView.center.x, RELATIVE_WIDTH(113));
    [self.contentView addSubview:_timeImageView];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_timeImageView)+RELATIVE_WIDTH(5), RELATIVE_WIDTH(100), 200, RELATIVE_WIDTH(30))];
    self.timeLabel.font = [UIFont systemFontOfSize:timeFont];
    self.timeLabel.center = CGPointMake(self.timeLabel.center.x, RELATIVE_WIDTH(113));
    [self.contentView addSubview:_timeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(149), mScreenWidth, 0.5)];
    lineView.backgroundColor = halvingLineColor;
    [self.contentView addSubview:lineView];
}



- (void) setNoticeContent:(NoticeNewsModel *)model{
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.postdate;
    self.timeLabel.textColor = grayTextcolor;
    if (model.hasRead ==YES) {
        self.titleLabel.textColor = grayTextcolor;
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
