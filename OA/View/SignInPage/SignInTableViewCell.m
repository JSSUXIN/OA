//
//  SignInTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "SignInTableViewCell.h"

@implementation SignInTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;

}

- (void)initView{
    self.mainAddress = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, 3*mScreenWidth/4, RELATIVE_WIDTH(40))];
    self.mainAddress.center = CGPointMake(self.mainAddress.center.x, RELATIVE_WIDTH(35));
    self.detailAddress.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(30)];
    [self.contentView addSubview:self.mainAddress];
    
    self.detailAddress = [[UILabel alloc]initWithFrame:CGRectMake(GG_X(self.mainAddress), 0, 3*mScreenWidth/4, RELATIVE_WIDTH(40))];
    self.detailAddress.center = CGPointMake(self.detailAddress.center.x, RELATIVE_WIDTH(105));
    self.detailAddress.textColor = grayTextcolor;
    self.detailAddress.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(25)];
    [self.contentView addSubview:self.detailAddress];
    
    self.selectedButton = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(120), 0, RELATIVE_WIDTH(70), RELATIVE_WIDTH(70))];
    self.selectedButton.center = CGPointMake(self.selectedButton.center.x, RELATIVE_WIDTH(70));
    [self.selectedButton setImage:mImageByName(@"ic_selected_true") forState:UIControlStateSelected];
    [self.selectedButton setImage:mImageByName(@"ic_selected_false") forState:UIControlStateNormal];
    self.selectedButton.userInteractionEnabled = NO;
    [self.contentView addSubview:self.selectedButton];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(138), mScreenWidth, 0.5)];
    lineView.backgroundColor = halvingLineColor;
    [self.contentView addSubview:lineView];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentWithModel:(AddressModel *)model{
    self.mainAddress.text = model.name;
    self.detailAddress.text = model.address;
    self.selectedButton.selected = model.selected;
}

@end
