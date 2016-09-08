//
//  CheckLowTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "CheckLowTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation CheckLowTableViewCell{
    UIImageView *_headViewImage;
    UILabel *_nameLabel;
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(20), RELATIVE_WIDTH(80), RELATIVE_WIDTH(80))];
        _headViewImage.layer.cornerRadius = RELATIVE_WIDTH(40);
        _headViewImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headViewImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headViewImage.frame)+RELATIVE_WIDTH(30), RELATIVE_WIDTH(20), RELATIVE_WIDTH(200), RELATIVE_WIDTH(30))];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.center = CGPointMake(_nameLabel.center.x, _headViewImage.center.y);
        [self.contentView addSubview:_nameLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GG_X(_nameLabel), RELATIVE_WIDTH(119), mScreenWidth - GG_X(_nameLabel) , 0.5)];
        lineView.backgroundColor = halvingLineColor;
        [self.contentView addSubview:lineView];
    }
    return self;
}


- (void)setInfomationWithCheckModel:(CheckLowModel *)model{
    _nameLabel.text = model.name;
    NSString *headImage = [NSString stringWithFormat:@"http://www.jssuxin.net:90/Static/UserFace/%@.jpg",model.name];
    [_headViewImage sd_setImageWithURL:mUrlWithString(mStringEncoding(headImage)) placeholderImage:mImageByName(@"ic_head_default")];
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
