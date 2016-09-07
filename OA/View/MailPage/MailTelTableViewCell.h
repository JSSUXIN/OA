//
//  MailTelTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/23.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  UsersModel;
@interface MailTelTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UILabel *detailText;


@property (nonatomic,strong) UILabel *telep;


@property (nonatomic,strong) UILabel *nameLabel;



@property (nonatomic,strong) UIButton *selectedBtn;

- (void)setContentWithDic:(UsersModel *)model;

@end
