//
//  MailTelTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/23.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MailTelTableViewCell.h"
#import "UsersModel.h"

@interface MailTelTableViewCell()
@end

@implementation MailTelTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(40), 0, RELATIVE_WIDTH(80), RELATIVE_WIDTH(80))];
    self.headView.layer.cornerRadius = RELATIVE_WIDTH(40);
    self.headView.layer.masksToBounds = YES;
    self.headView.center = CGPointMake(self.headView.center.x, RELATIVE_WIDTH(70));
    [self.contentView addSubview:self.headView];
    
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(self.headView)+RELATIVE_WIDTH(20), 0, RELATIVE_WIDTH(120), RELATIVE_WIDTH(30))];
    self.nameLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(25)];
    self.nameLabel.center = CGPointMake(self.nameLabel.center.x, RELATIVE_WIDTH(35));
    [self.contentView addSubview:self.nameLabel];
    
    self.detailText = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(self.nameLabel), 0, RELATIVE_WIDTH(600), RELATIVE_WIDTH(30))];
    self.detailText.center = CGPointMake(self.detailText.center.x, RELATIVE_WIDTH(35));
    self.detailText.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(20)];
    self.detailText.textColor = grayTextcolor;
    [self.contentView addSubview:self.detailText];
    
    UILabel *mobieLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_X(self.nameLabel), GG_BOTTOM_Y(self.nameLabel), RELATIVE_WIDTH(120), RELATIVE_WIDTH(30))];
    mobieLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(25)];
    mobieLabel.center = CGPointMake(mobieLabel.center.x, RELATIVE_WIDTH(105));
    mobieLabel.text = @"手机:";
    [self.contentView addSubview:mobieLabel];
    
    self.telep = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(mobieLabel), GG_Y(mobieLabel), RELATIVE_WIDTH(300), RELATIVE_WIDTH(30))];
    self.telep.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(25)];
    self.telep.center = CGPointMake(self.telep.center.x, RELATIVE_WIDTH(105));
    [self.contentView addSubview:self.telep];
    
    self.selectedBtn = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(100), 0, RELATIVE_WIDTH(100), RELATIVE_WIDTH(100))];
    self.selectedBtn.userInteractionEnabled = NO;
    self.selectedBtn.center = CGPointMake(self.selectedBtn.center.x, RELATIVE_WIDTH(70));

    [self.selectedBtn setImage:mImageByName(@"ic_selected_true") forState:UIControlStateSelected];
    [self.selectedBtn setImage:mImageByName(@"ic_selected_false") forState:UIControlStateNormal];
    [self.contentView addSubview:self.selectedBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(138), mScreenWidth, 0.5)];
    lineView.backgroundColor = halvingLineColor;
    [self.contentView addSubview:lineView];
}



- (void)setContentWithDic:(UsersModel *)model{
    self.detailText.text =model.postName;
    self.telep.text = model.mobile;
    self.nameLabel.text =model.name;
    self.selectedBtn.selected = model.selected;
    NSString *imageStr = model.headImg;
    NSString *strEnd=[imageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.headView sd_setImageWithURL:mUrlWithString(strEnd) placeholderImage:mImageByName(@"ic_head_default")];
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
