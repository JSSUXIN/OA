//
//  ImageTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/4.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "ImageTableViewCell.h"


#define widthWithTimeImage RELATIVE_WIDTH(30)
#define widthWithDetailImage RELATIVE_WIDTH(214)
#define heightWithDetailImage RELATIVE_WIDTH(160)

#define titleFont 15//标题字体大小
#define timeFont 12//时间字体大小

#define leftPadding RELATIVE_WIDTH(20)//左右边距
#define upPadding  RELATIVE_WIDTH(20)//上下边距

#define leftTextPadding RELATIVE_WIDTH(20)//文字距图片左边距



@implementation ImageTableViewCell{
    UIImageView *_timeImageView;
    UIView *_lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUIView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailImageView.frame = CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(20), widthWithDetailImage, heightWithDetailImage);
    self.detailImageView.center = CGPointMake(self.detailImageView.center.x, RELATIVE_WIDTH(100));
    self.titleLabel.frame =CGRectMake(GG_RIGHT_X(self.detailImageView)+leftTextPadding, upPadding, mScreenWidth - widthWithDetailImage - RELATIVE_WIDTH(40) - leftTextPadding, RELATIVE_WIDTH(100));
    _timeImageView.frame = CGRectMake(GG_RIGHT_X(self.detailImageView)+leftTextPadding, RELATIVE_WIDTH(150), widthWithTimeImage, widthWithTimeImage);
    _timeImageView.center = CGPointMake(_timeImageView.center.x, RELATIVE_WIDTH(150));
    
    self.timeLabel.frame = CGRectMake(GG_RIGHT_X(_timeImageView)+RELATIVE_WIDTH(5), RELATIVE_WIDTH(150), 200, RELATIVE_WIDTH(30));
    self.timeLabel.center = CGPointMake(self.timeLabel.center.x, RELATIVE_WIDTH(150));
    _lineView.frame = CGRectMake(0, RELATIVE_WIDTH(198), mScreenWidth, 0.5);

}

- (void)initUIView{
    self.detailImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.detailImageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];

    
    [self.contentView addSubview:_titleLabel];
    
    _timeImageView = [[UIImageView alloc]initWithImage:mImageByName(@"ic_time")];
    [self.contentView addSubview:_timeImageView];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.center = CGPointMake(self.timeLabel.center.x, RELATIVE_WIDTH(150));
    self.timeLabel.font = [UIFont systemFontOfSize:timeFont];
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = halvingLineColor;
    [self.contentView addSubview:_lineView];
}



-(void)setNewsContent:(NoticeNewsModel *)model{
    self.titleLabel.text = model.title;
    [self.detailImageView sd_setImageWithURL:mUrlWithString(model.imageNewsFile) placeholderImage:mImageByName(@"ic_empty_default")];
    self.timeLabel.text = model.postdate;
    self.timeLabel.textColor = grayTextcolor;

    if (model.hasRead ==YES) {
        self.titleLabel.textColor = grayTextcolor;
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
    }
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.titleLabel.text length])];
    [self.titleLabel setAttributedText:attributedString1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
