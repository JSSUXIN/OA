//
//  MailEditTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/11.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MailListModel.h"

@interface MailEditTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *selectedButton;

- (void)setContentWithModel:(MailListModel*) model;

@end
