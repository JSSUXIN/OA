//
//  TelTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "TelTableViewCell.h"

@implementation TelTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUi];
    }
    return self;
}

- (void)creatUi{
    self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(65), 0, RELATIVE_WIDTH(80), RELATIVE_WIDTH(80))];
    self.headView.layer.cornerRadius = RELATIVE_WIDTH(40);
    self.headView.layer.masksToBounds = YES;
    self.headView.center = CGPointMake(self.headView.center.x, RELATIVE_WIDTH(70));
    [self.contentView addSubview:self.headView];
    
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(self.headView)+RELATIVE_WIDTH(35), 0, RELATIVE_WIDTH(120), RELATIVE_WIDTH(40))];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.center = CGPointMake(self.nameLabel.center.x, RELATIVE_WIDTH(50));
    [self.contentView addSubview:self.nameLabel];
    
    self.detailText = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(self.nameLabel), 0, mScreenWidth - RELATIVE_WIDTH(205), RELATIVE_WIDTH(30))];
    self.detailText.center = CGPointMake(self.detailText.center.x, RELATIVE_WIDTH(50));
    self.detailText.font = [UIFont systemFontOfSize:12];
    self.detailText.textColor = grayTextcolor;
    [self.contentView addSubview:self.detailText];
    
    UILabel *mobieLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_X(self.nameLabel), GG_BOTTOM_Y(self.nameLabel), RELATIVE_WIDTH(120), RELATIVE_WIDTH(30))];
    mobieLabel.font = [UIFont systemFontOfSize:12];
    mobieLabel.center = CGPointMake(mobieLabel.center.x, RELATIVE_WIDTH(90));
    mobieLabel.text = @"手机 ：";
    [self.contentView addSubview:mobieLabel];
    
    self.telep = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(mobieLabel), GG_Y(mobieLabel), RELATIVE_WIDTH(300), RELATIVE_WIDTH(30))];
    self.telep.font = [UIFont systemFontOfSize:12];
    self.telep.center = CGPointMake(self.telep.center.x, RELATIVE_WIDTH(90));
    [self.contentView addSubview:self.telep];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(138), mScreenWidth, 0.5)];
    lineView.backgroundColor = halvingLineColor;
    [self.contentView addSubview:lineView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithDic:(UsersModel *)model{
    self.detailText.text =[NSString stringWithFormat:@"<%@>",model.postName];
    self.telep.text = model.mobile;
    self.nameLabel.text = model.name;
    NSString *imageStr = model.headImg;
    NSString *strEnd=[imageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self.headView sd_setImageWithURL:mUrlWithString(strEnd) placeholderImage:mImageByName(@"ic_head_default")];
}

@end
