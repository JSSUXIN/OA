//
//  MailEditTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/11.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MailEditTableViewCell.h"
#import "ParseModelToAddressBook.h"
#import "UsersModel.h"

#define radiusOfImage RELATIVE_WIDTH(80)
#define radiusOfButoon RELATIVE_WIDTH(60)

@implementation MailEditTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUIView];
    }
    return self;
}


-(void)initUIView{
    self.selectedButton = [[UIButton alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, radiusOfButoon, radiusOfButoon)];
    [self.selectedButton setImage:mImageByName(@"ic_selected_false") forState:UIControlStateNormal];
    [self.selectedButton setImage:mImageByName(@"ic_selected_true") forState:UIControlStateSelected];
    self.selectedButton.center = CGPointMake(self.selectedButton.center.x, RELATIVE_WIDTH(60));
    self.selectedButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectedButton];
    
    self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_selectedButton), 0, radiusOfImage, radiusOfImage)];
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = radiusOfImage/2;
    self.headView.center = CGPointMake(self.headView.center.x, RELATIVE_WIDTH(60));
    [self.contentView addSubview:_headView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_headView) +RELATIVE_WIDTH(20), 0, RELATIVE_WIDTH(150), RELATIVE_WIDTH(35))];
    self.nameLabel.center = CGPointMake(self.nameLabel.center.x, RELATIVE_WIDTH(30));
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(280), 0,RELATIVE_WIDTH(260), RELATIVE_WIDTH(35))];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = grayTextcolor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.center = CGPointMake(self.timeLabel.center.x, RELATIVE_WIDTH(30));
    [self.contentView addSubview:_timeLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_X(_nameLabel), GG_BOTTOM_Y(_nameLabel), mScreenWidth -2* radiusOfImage, RELATIVE_WIDTH(35))];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.center = CGPointMake(self.detailLabel.center.x, RELATIVE_WIDTH(90));
    [self.contentView addSubview:_detailLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GG_X(_nameLabel), RELATIVE_WIDTH(118), mScreenWidth - 3*RELATIVE_WIDTH(20) - radiusOfImage - radiusOfButoon, 0.5)];
    lineView.backgroundColor = halvingLineColor;
    [self.contentView addSubview:lineView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setContentWithModel:(MailListModel*) model{
    NSString *headName = [NSString stringWithFormat:@"http://www.jssuxin.net:90/Static/UserFace/%@.jpg",model.sendFromName];
    [self.headView sd_setImageWithURL:mUrlWithString(mStringEncoding(headName)) placeholderImage:mImageByName(@"ic_head_default")];
    self.nameLabel.text = model.sendFromName;
    self.detailLabel.text = model.subject;
    self.timeLabel.text = [NSString parseTime:model.sendTime];
    self.selectedButton.selected = model.selected;
    
    if (model.isRead ==YES) {
        self.nameLabel.textColor = grayTextcolor;
        self.detailLabel.textColor = grayTextcolor;
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        self.detailLabel.textColor = [UIColor blackColor];
    }
}

@end
